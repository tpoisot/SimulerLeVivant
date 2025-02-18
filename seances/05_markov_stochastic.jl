using CairoMakie
using Distributions
using ProgressMeter

# States
# Barren
# Grass
# Shrubs
s = [0, 500_000, 0]
states = length(s)
patches = sum(s)

Tm = zeros(Float64, states, states)
Tm[1,:] = [110, 8, 0]
Tm[2,:] = [2, 120, 3]
Tm[3,:] = [1, 0, 94]


for ligne in axes(Tm, 1)
    if sum(Tm[ligne,:]) != 1
        @warn "La somme de la ligne $(ligne) n'est pas égale à 1 - MODIFIÉE"
        Tm[ligne,:] ./= sum(Tm[ligne,:])
    end
end


round.(Tm; digits=2)

generations = 500

timeseries = zeros(Int64, states, generations)
timeseries[:,1] = s

@showprogress for i in 2:generations
    for x in eachindex(s)
        new = rand(Multinomial(timeseries[x, i-1], Tm[x,:]))
        for j in eachindex(new)
            timeseries[j,i] += new[j]
        end
    end
end

f, ax, st = series(timeseries, labels=["Barren", "Grasses", "Shrubs"], color=[:grey40, :orange, :teal])
axislegend(ax)
ax.xlabel = "Génération"
ax.ylabel = "Nb. individus"
tightlimits!(ax)
current_figure()