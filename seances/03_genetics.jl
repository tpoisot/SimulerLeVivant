using CairoMakie

w, h = 100, 100

# Setup
food = fill(20, w, h)
genome = zeros(Float64, w, h)
age = zeros(Int, w, h)

# Age at reproduction
age_at_repro = 8
mutation_effect = 1e-4

# Initial state
age[rand(CartesianIndices(age))] = 1

heatmap(age)

neighbors = CartesianIndices((-1:1, -1:1))

for gen in 1:2000
    @info gen
    for cell in findall(!iszero, age)
        if food[cell] == 0
            age[cell] = 0
            break
        end
        age[cell] += 1
        if age[cell] == age_at_repro
            N = cell .+ collect(CartesianIndices((-1:1, -1:1)))
            N = filter(neighbor -> neighbor in CartesianIndices(food), N)
            N = filter(neighbor -> age[neighbor] == 0, N)
            for newposition in rand(N, 2)
                age[newposition] = 1
                genome[newposition] = genome[cell] + mutation_effect * randn()
            end
            age[cell] = 0
        end
        food[cell] -= 1
    end
end