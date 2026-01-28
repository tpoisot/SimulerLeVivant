using CairoMakie

import StatsBase
import Random

cells = 150
generations = 501
mutation = 1e-4
parents_distance = 5

# État initial
lattice = zeros(Bool, (cells, generations, 3))
for i in Base.OneTo(cells)
    lattice[i,1,:] = rand(Bool, 3)
end

# Première génération
for generation in 2:generations
    for i in Base.OneTo(cells)
        parents_possibles = filter(p -> 1 <= p <= cells, (i-parents_distance):(i+parents_distance))
        parents = StatsBase.sample(parents_possibles, 2, replace=false)
        for gene in 1:3
            lattice[i,generation,gene] = lattice[rand(parents),generation-1,gene]
            if rand() <= mutation
                lattice[i,generation,gene] = !lattice[i,generation,gene]
            end
        end
    end
end

# Fonction pour les couleurs
colormap = dropdims(mapslices(x -> CairoMakie.Colors.RGB(x...), lattice, dims=3), dims=3)

# Heatmap et diversité
f = Figure()
ax = Axis(f[2,1])
heatmap!(ax, 0:(generations-1), 1:cells, permutedims(colormap))
hideydecorations!(ax)
plax = Axis(f[1,1])
scatter!(plax, 0:(generations-1), vec(mapslices(x -> length(unique(x)), colormap, dims=1)), color=:black)
ylims!(plax, 1, 8)
xlims!(plax, 0, generations-1)
xlims!(ax, 0, generations-1)
f
