using CairoMakie

import StatsBase
import Random

w, h = 80, 80

# Setup
food = fill(50, w, h)
genome = zeros(Float64, w, h)
age = zeros(Int, w, h)

# Age at reproduction
age_at_repro = 8
mutation_effect = 1e-2
competition_tolerance = 0.2

# Initial state
age[rand(CartesianIndices(age))] = 1

heatmap(age)

neighbors = [CartesianIndex(0, -1), CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(-1, 0)]

function competition_strength(x, y, xi)
    return exp(-((x-y)^2)/(2*xi^2))
end

# Radius for new cells
function create_circular_neighborhood(R)
    square = CartesianIndices((-R:R, -R:R))
    circle = filter(r -> sqrt(sum(Tuple(CartesianIndex(0, 0) - r) .^ 2)) <= R, square)
    return circle
end

competition_neighbors = create_circular_neighborhood(4)

for gen in 1:250
    @info gen

    # Step 1 - growth and starvation
    for cell in findall(!iszero, age)
        food[cell] -= 1
        if food[cell] <= 0
            age[cell] = 0
        else
            age[cell] += 1
        end
    end

    # Step 2 - cells that reproduce
    cells = Random.shuffle(findall(==(age_at_repro), age))
    for cell in cells
        # We find the possible neighbors
        N = cell .+ collect(neighbors)
        N = filter(n -> n in CartesianIndices(food), N)
        N = filter(n -> (food[n] > 0) & (age[n] == 0), N)
        if !isempty(N)
            # These neighbors have different competition
            competition = zeros(length(N))
            for (i, n) in enumerate(N)
                all_around = n .+ competition_neighbors
                all_around = filter(n -> n in CartesianIndices(food), all_around)
                for a in all_around
                    if age[a] != 0
                        competition[i] += competition_strength(genome[cell], genome[a], competition_tolerance)
                    end
                end
            end
            competition ./= length(competition_neighbors)
            for i in eachindex(competition)
                if competition[i] < rand()
                    competition[i] = 1.0
                end
            end
            offsprings = StatsBase.sample(N, StatsBase.Weights(1.0.-competition.+eps()), min(2, length(N)), replace=false)
            for offspring in offsprings
                age[offspring] = 1
                genome[offspring] = genome[cell] + mutation_effect * randn()
            end
        end
        age[cell] = 0 # Cell dies after reproduction
    end
end