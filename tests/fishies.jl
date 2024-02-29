using Random
using Distributions
using CairoMakie

number_of_agents = 350
iterations = 1_000
timestep = 1e-2

mutable struct Force
    r::Float64
    f::Float64
end

repulsion = Force(5e-3, 1e-1)
flocking = Force(0.1, 1.0)
propulsion = Force(0.0, 10.0)
stochasticity = Force(0.0, 0.5)

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
        0.0, 0.0,
        rand(Uniform(-1, 1)), rand(Uniform(-1, 1))
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

phantoms = buffer(school, 0.1)

# Figure with the buffer area around the fish
[(fish.x, fish.y) for fish in school] |> scatter
[(phantom.x, phantom.y) for phantom in phantoms] |> scatter!
current_figure()
