using CairoMakie
using Statistics
using ProgressMeter
CairoMakie.activate!(px_per_unit = 6.0)

function disposition_points(n)
    angles = rand(n) .* 2π
    radii = sqrt.(rand(length(angles)) .* 3.0 .+ 1.0)
    x = cos.(angles) .* radii
    y = sin.(angles) .* radii

    stops = permutedims(hcat(x, y))
    return stops
end

function random_choice_weighted(choices, weights)
    total_weight = sum(weights)
    rand_val = rand() * total_weight
    cumulative_weight = 0.0
    for (choice, weight) in zip(choices, weights)
        cumulative_weight += weight
        if rand_val < cumulative_weight
            return choice
        end
    end
end

points = 55

P = zeros(Float64, points, points)
D = zeros(Float64, points, points)

xy = disposition_points(points)

for i in 1:points
    for j in 1:points
        D[i,j] = sqrt(sum((xy[:,i] .- xy[:,j]) .^2.0))
    end
end

scatter(xy)

function walk_on_graph(D, P, i)
    α = 0.9
    β = 1.5
    n_sites = size(D, 1)

    visites = zeros(Bool, n_sites)
    visites[i] = true

    chemin = [i]

    while sum(visites) != n_sites
        voisins = []
        cible = []
        for voisin in setdiff(1:n_sites, chemin)
            pheromones = max(P[last(chemin), voisin], 1e-5)
            poids = (pheromones^α)/D[last(chemin), voisin]^β
            push!(cible, poids)
            push!(voisins, voisin)
        end
        
        next_site = random_choice_weighted(voisins, cible)
        push!(chemin, next_site)
        visites[next_site] = true
    end
    return chemin
end

function chemin_distance(chemin, D)
    d = D[chemin[end], chemin[begin]]
    for i in 2:length(chemin)
        d += D[chemin[i-1], chemin[i]]
    end
    return d
end

function pheromones!(P, chemin, D)
    Q = size(P, 1)
    score = Q / chemin_distance(chemin, D)
    P[chemin[end], chemin[1]] += score
    for i in 2:length(chemin)
        P[chemin[i-1], chemin[i]] += score
    end
    return P
end

track = zeros(Float64, 200)

@showprogress for i in 1:length(track)

    chemins = [walk_on_graph(D, P, rand(1:points)) for i in 1:10points]

    # Remove the chemins with more than the median chemin_distance
    distances = [chemin_distance(chemin, D) for chemin in chemins]
    median_distance = median(distances)
    chemins = chemins[findall(distances .<= median_distance)]

    for chemin in chemins
        pheromones!(P, chemin, D)
    end
    P ./= length(chemins)
    #P .+= rand(size(P)).*0.02 .- 0.01
    P .*= 0.9

    track[i] = minimum(distances)

end

# Plotting the points and lines colored by the value of P
fig = Figure(size=(1000, 400))
ax = Axis(fig[1, 1], aspect=1)
ax2 = Axis(fig[1,2], yscale=sqrt)
lines!(ax2, track, color=:black, linewidth=2)

# Collect all lines with their P values
lines_data = []
for i in 1:points
    for j in 1:points
        if i != j
            push!(lines_data, (i, j, P[i, j]))
        end
    end
end

# Sort lines by P values
sorted_lines = sort(lines_data, by=x -> x[3])

# Plot lines with the highest P values last
max_P = maximum(P)
for (i, j, p_val) in sorted_lines
    z_val = p_val / max_P
    lines!(ax, [xy[1, i], xy[1, j]], [xy[2, i], xy[2, j]], color=log1p.(z_val), colormap=:Blues, colorrange=log1p.(extrema(P)))
end

scatter!(ax, xy[1, :], xy[2, :], color=:black)
hidespines!(ax)
hidedecorations!(ax)

fig
