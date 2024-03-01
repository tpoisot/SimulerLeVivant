using Random
using Distributions
using CairoMakie

number_of_agents = 350
iterations = 2_000
timestep = 1e-2
target_speed = 0.01

mutable struct Force
    r::Float64
    f::Float64
end

repulsion = Force(5e-3, 1e-5)
flocking = Force(0.1, 1.0)
propulsion = Force(0.0, 10.0)
stochasticity = Force(0.0, 0.1)

mutable struct Fish
    x::Float64 # Position
    y::Float64
    vx::Float64 # Velocity
    vy::Float64
    fx::Float64 # Total forces
    fy::Float64
end

school = [
    Fish(
        rand(), rand(),
        rand(Uniform(-1, 1)), rand(Uniform(-1, 1)),
        0.0, 0.0
    )
    for _ in Base.OneTo(number_of_agents)
]

# INFO: This boring block of functions will simply create additional ghost fish in the
# buffer area - this speeds up the calculation of forces, but at what cost?
leftfish(fish, radius) = fish.x <= radius ? Fish(fish.x + 1, fish.y, fish.vx, fish.vy, 0.0, 0.0) : nothing
rightfish(fish, radius) = fish.x >= 1.0 - radius ? Fish(fish.x - 1, fish.y, fish.vx, fish.vy, 0.0, 0.0) : nothing
bottomfish(fish, radius) = fish.y <= radius ? Fish(fish.x, fish.y + 1, fish.vx, fish.vy, 0.0, 0.0) : nothing
topfish(fish, radius) = fish.y >= 1.0 - radius ? Fish(fish.x, fish.y - 1, fish.vx, fish.vy, 0.0, 0.0) : nothing
bottomleftfish(fish, radius) = (fish.y <= radius) & (fish.x <= radius) ? Fish(fish.x + 1, fish.y + 1, fish.vx, fish.vy, 0.0, 0.0) : nothing
bottomrightfish(fish, radius) = (fish.y <= radius) & (fish.x >= 1 - radius) ? Fish(fish.x - 1, fish.y + 1, fish.vx, fish.vy, 0.0, 0.0) : nothing
topleftfish(fish, radius) = (fish.y >= 1 - radius) & (fish.x <= radius) ? Fish(fish.x + 1, fish.y - 1, fish.vx, fish.vy, 0.0, 0.0) : nothing
toprightfish(fish, radius) = (fish.y >= 1 - radius) & (fish.x >= 1 - radius) ? Fish(fish.x - 1, fish.y - 1, fish.vx, fish.vy, 0.0, 0.0) : nothing

function buffer(school, radius)
    phantoms = Fish[]
    mirrors = [leftfish, rightfish, bottomfish, topfish, bottomleftfish, bottomrightfish, topleftfish, toprightfish]
    for fish in school
        fakes = filter(!isnothing, [mirror(fish, radius) for mirror in mirrors])
        if !isempty(fakes)
            append!(phantoms, fakes)
        end
    end
    return phantoms
end

function forces!(school, repulsion, flocking, propulsion, stochasticity)
    buffer_radius = max(repulsion.r, flocking.r)
    phantoms = buffer(school, buffer_radius)
    for (j, focal) in enumerate(school)
        rx, ry, fx, fy, n = 0.0, 0.0, 0.0, 0.0, 0
        for (k, distal) in enumerate(vcat(school, phantoms))
            d2 = (focal.x - distal.x)^2 + (focal.y - distal.y)^2
            if (d2 <= flocking.r) & (j != k)
                fx += distal.vx
                fy += distal.vy
                n += 1
                if (d2 <= 4 * repulsion.r^2)
                    d = sqrt(d2)
                    rx += repulsion.f * exp(1 - d / (2 * repulsion.f))^1.5 * (focal.x - distal.x) / d
                    ry += repulsion.f * exp(1 - d / (2 * repulsion.f))^1.5 * (focal.y - distal.y) / d
                end
            end
        end
        norm = n > 0 ? sqrt(fx^2 + fy^2) : 1.0
        fx = flocking.f * fx / norm
        fy = flocking.f * fy / norm

        vnorm = sqrt(focal.vx^2 + focal.vy^2)
        px = propulsion.f * (target_speed - vnorm) * (focal.vx / vnorm)
        py = propulsion.f * (target_speed - vnorm) * (focal.vy / vnorm)

        sx, sy = stochasticity.f .* rand(Uniform(-1, 1), 2)

        focal.fx = fx + sx + px + rx
        focal.fy = fy + sy + py + ry

    end
end

phantoms = buffer(school, 0.1)

# Figure with the buffer area around the fish
[(fish.x, fish.y) for fish in school] |> scatter
[(phantom.x, phantom.y) for phantom in phantoms] |> scatter!
current_figure()

# Loop

fig = Figure()
ax = Axis(fig[1, 1]; aspect=DataAspect())
pldt = scatter!(ax, [(fish.x, fish.y) for fish in school], color=:black)
xlims!(ax, (0.0, 1.0))
ylims!(ax, (0.0, 1.0))
hidedecorations!(ax)
display(fig)

record(fig, "swimming.mp4", Base.OneTo(iterations); framerate=30) do iteration
    forces!(school, repulsion, flocking, propulsion, stochasticity)
    for fish in school
        fish.vx += fish.fx * timestep
        fish.x += fish.vx * timestep
        fish.x = (1 + fish.x) % 1.0
        fish.vy += fish.fy * timestep
        fish.y += fish.vy * timestep
        fish.y = (1 + fish.y) % 1.0
    end
    pldt[1] = [(fish.x, fish.y) for fish in school]
end
