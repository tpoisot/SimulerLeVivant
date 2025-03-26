using Random
using Distributions
using CairoMakie
using Statistics
using ProgressMeter

number_of_agents = 120

iterations, timestep = 3.0, 1e-3

clicks = round(Int, iterations * (1 / timestep))

plot_size = (3, 3)

plot_at = round.(Int, LinRange(0, clicks, prod(plot_size)))

begin
	fig = Figure(; size=(1000, 1000))
	fig_axs = [Axis(fig[i,j]; aspect=DataAspect()) for i in 1:plot_size[1], j in 1:plot_size[2]]
	for fig_ax in fig_axs
		xlims!(fig_ax, (0.0, 1.0))
		ylims!(fig_ax, (0.0, 1.0))
		hidedecorations!(fig_ax)
	end
end

Base.@kwdef mutable struct Fish
    x::Float64 = rand() # Position
    y::Float64 = rand()
    vx::Float64 = 0.1rand()-0.05 # Velocity
    vy::Float64 = 0.1rand()-0.05
    fx::Float64 = 0.0 # Total forces
    fy::Float64 = 0.0
	repulsion::Float64 = 0.0
	repulsion_radius::Float64 = 0.0
	flocking::Float64 = 1.0
	flocking_radius::Float64 = 0.1
	propulsion::Float64 = 10.0
	stochasticity::Float64 = 0.1
	target_speed::Float64 = 0.0
end

function update!(school, timestep)
    for fish in school
        fish.vx += fish.fx * timestep
        fish.x += fish.vx * timestep
        fish.x = (1 + fish.x) % 1.0
        fish.vy += fish.fy * timestep
        fish.y += fish.vy * timestep
        fish.y = (1 + fish.y) % 1.0
    end
	return school
end

function speeds(school)
	raw = [sqrt(fish.vx^2 + fish.vy^2) for fish in school]
	return clamp.((raw .- mean(raw)) ./ std(raw), -0.1, 0.1)
end

function generate_school(n; kwargs...)
	return [
    Fish(; kwargs...)
    for _ in Base.OneTo(n)
]
end

school = generate_school(number_of_agents)

function movefish(fish; x::Float64=fish.x, y::Float64=fish.y)
	newfish = deepcopy(fish)
	newfish.x = x
	newfish.y = y
	return newfish
end

begin
leftfish(fish, radius) = fish.x <= radius ? movefish(fish, x=fish.x + 1, y=fish.y) : nothing
rightfish(fish, radius) = fish.x >= 1.0 - radius ? movefish(fish, x=fish.x - 1, y=fish.y) : nothing
bottomfish(fish, radius) = fish.y <= radius ? movefish(fish, x=fish.x, y=fish.y + 1) : nothing
topfish(fish, radius) = fish.y >= 1.0 - radius ? movefish(fish, x=fish.x, y=fish.y - 1) : nothing
bottomleftfish(fish, radius) = (fish.y <= radius) & (fish.x <= radius) ? movefish(fish, x=fish.x + 1, y=fish.y + 1) : nothing
bottomrightfish(fish, radius) = (fish.y <= radius) & (fish.x >= 1 - radius) ? movefish(fish, x=fish.x - 1, y=fish.y + 1) : nothing
topleftfish(fish, radius) = (fish.y >= 1 - radius) & (fish.x <= radius) ? movefish(fish, x=fish.x + 1, y=fish.y - 1) : nothing
toprightfish(fish, radius) = (fish.y >= 1 - radius) & (fish.x >= 1 - radius) ? movefish(fish, x=fish.x - 1, y=fish.y - 1) : nothing
end

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

begin
	# Figure with the buffer area around the fish
	scatter([(fish.x, fish.y) for fish in school], color=:blue)
	scatter!([(phantom.x, phantom.y) for phantom in buffer(school, 0.2)], color=:orange)
	hidedecorations!(current_axis())
	current_figure()
end

function forces!(school)
	
	buffer_radius = maximum([max(fish.repulsion_radius, fish.flocking_radius) for fish in school])
    phantoms = buffer(school, buffer_radius)
	
    for (j, focal) in enumerate(school)
        rx, ry, fx, fy, n = 0.0, 0.0, 0.0, 0.0, 0
        for (k, distal) in enumerate(vcat(school, phantoms))
			if j != k
	            d2 = (focal.x - distal.x)^2 + (focal.y - distal.y)^2
	            if (d2 <= (focal.flocking_radius^2))
	                fx += distal.vx
	                fy += distal.vy
	                n += 1
	            end
				if (d2 <= (4 * distal.repulsion_radius^2))
	                d = sqrt(d2)
	                rx += distal.repulsion * exp(1 - d / (2 * distal.repulsion))^1.5 * (focal.x - distal.x) / d
	                ry += distal.repulsion * exp(1 - d / (2 * distal.repulsion))^1.5 * (focal.y - distal.y) / d
	            end
			end
        end
		
        norm = n > 0 ? sqrt(fx^2 + fy^2) : 1.0
        fx = focal.flocking * fx / norm
        fy = focal.flocking * fy / norm

        vnorm = sqrt(focal.vx^2 + focal.vy^2)
        px = focal.propulsion * (focal.target_speed - vnorm) * (focal.vx / vnorm)
        py = focal.propulsion * (focal.target_speed - vnorm) * (focal.vy / vnorm)

        sx, sy = focal.stochasticity .* rand(Uniform(-1, 1), 2)

        focal.fx = fx + sx + px + rx
        focal.fy = fy + sy + py + ry

    end
end

parameters_shared = (repulsion_radius = 0.035, repulsion = 2.5, flocking_radius = 0.1, propulsion = 10.)
parameters_slow = (parameters_shared..., flocking=3.0, target_speed = 0.02, stochasticity = 0.1)
parameters_fast = (parameters_shared..., flocking=0.1, target_speed = 0.1, stochasticity = 0.1)


#f = Figure()
#ax = Axis(f[1,1]; aspect=DataAspect())
#xlims!(ax, 0, 1)
#ylims!(ax, 0, 1)
#tightlimits!(ax)
#hidedecorations!(ax)

@showprogress for i in Base.OneTo(clicks)
	if i == 1
		school = generate_school(number_of_agents; parameters_slow...)
		
        school[1].repulsion_radius *= 3.0
        school[1].repulsion *= 5.0
        school[1].flocking_radius *= 2.0
        school[1].target_speed *= 2.0
        school[1].stochasticity /= 2.0

        #fraction_slow = 0.90
		#n_slow = ceil(Int, fraction_slow * number_of_agents)
		#n_fast = number_of_agents - n_slow
		#slow = generate_school(n_slow; parameters_slow...)
		#fast = generate_school(n_fast; parameters_fast...)
		#school = vcat(slow, fast)
		
		empty!(fig_axs[1])
		fig_axs[1].title = "t ≈ 0.0"
		arrows!(fig_axs[1], [fish.x for fish in school], [fish.y for fish in school], [0.2fish.vx for fish in school], [0.2fish.vy for fish in school], alpha=0.5, color=speeds(school), colormap=:berlin)
	end
	forces!(school)
	update!(school, timestep)
	if i in plot_at
		plot_position = findfirst(isequal(i), plot_at)
		empty!(fig_axs[plot_position])
		fig_axs[plot_position].title = "t ≈ $(round(i*timestep; digits=1))"
		arrows!(fig_axs[plot_position], [fish.x for fish in school], [fish.y for fish in school], [0.2fish.vx for fish in school], [0.2fish.vy for fish in school], alpha=0.5, color=speeds(school), colormap=:berlin)
        scatter!(fig_axs[plot_position], [school[1].x], [school[1].y], color=:red, markersize=24)
	end
    #scatter!(ax, [fish.x for fish in school], [fish.y for fish in school], alpha=0.5, color=speeds(school), colormap=:Spectral, colorrange=(-0.1, 0.1), markersize=2)
    #display(f)
end

fig