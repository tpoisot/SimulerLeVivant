using CairoMakie
using Statistics

landscape_size = (50, 50)

# Lattices
H₀ = zeros(Float64, landscape_size)
P₀ = zeros(Float64, landscape_size)
Hₜ = zeros(Float64, landscape_size)
Pₜ = zeros(Float64, landscape_size)

# Initial population
for xᵢ in CartesianIndices(H₀)
    H₀[xᵢ] = rand()
    P₀[xᵢ] = rand()
end

# Parameters
k = 2.0
α = 0.2
c = 1.0
δₕ = 0.1
δₚ = 0.05

# Figure
fig = Figure(size = (600, 600))
ax1 = Axis(fig[1, 1])
hm1 = heatmap!(ax1, H₀; colormap = :Spectral)
fig

function _generate_valid_neighbors(i, j, G)
    iₙ = filter(x -> 0 < x <= size(G, 1), i .+ (-1:1))
    jₙ = filter(x -> 0 < x <= size(G, 2), j .+ (-1:1))
    return CartesianIndex.([(ii, jj) for ii in iₙ for jj in jₙ if (ii, jj) != (i, j)])
end

# Dynamics
Nᵢ = CartesianIndices((-1:1, -1:1))
record(fig, "population_dynamics.mp4", 1:100; framerate=10) do i
    @info extrema(H₀)
    for i in axes(H₀, 1)
        for j in axes(H₀, 2)
            xᵢ = CartesianIndex(i, j)
            # List of valid neighbors
            N = _generate_valid_neighbors(i, j, H₀)
            # Loss due to migration
            Hₜ[xᵢ] = (1 - δₕ) * H₀[xᵢ] + δₕ / length(N) * sum(H₀[N])
            Pₜ[xᵢ] = (1 - δₚ) * P₀[xᵢ] + δₚ / length(N) * sum(P₀[N])
            # Growth of the parasitoid
            Pₜ[xᵢ] = c * Hₜ[xᵢ] * (1.0 - exp(-α * Pₜ[xᵢ]))
            # Growth of the host
            Hₜ[xᵢ] = k * Hₜ[xᵢ] * exp(-α * Pₜ[xᵢ])
        end
    end
    for xᵢ in CartesianIndices(H₀)
        H₀[xᵢ] = Hₜ[xᵢ]
        P₀[xᵢ] = Pₜ[xᵢ]
    end
    hm1[1] = H₀
end
