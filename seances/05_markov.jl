using CairoMakie
using Distributions
using LinearAlgebra

# States
# Barren
# Grass
# Shrubs
# Tree 1
# Tree 2
# Burning
s = rand(6)
s ./= sum(s)

Tm = zeros(Float64, length(s), length(s))
Tm[1,:] = [50, 8, 0, 0, 0, 0]
Tm[2,:] = [0, 90, 5, 0, 0, 0]
Tm[3,:] = [0, 3, 94, 2, 3, 0]
Tm[4,:] = [2, 0, 0, 220, 0, 16]
Tm[5,:] = [2, 0, 0, 0, 220, 20]
Tm[6,:] = [1, 0, 0, 0, 0, 0]
Tm ./= sum(Tm, dims=2)

patches = 1000
generations = 600
timeseries = zeros(Float64, length(s), generations)
timeseries[:,1] = s
for i in 2:generations
    newstate = (timeseries[:,(i-1)]' * Tm)'
    if !isinf(patches)
        M = Multinomial(patches, newstate)
        N = rand(M)
        newstate  = N ./ sum(N)
    end
    timeseries[:,i] = newstate
end

ct = cumsum(timeseries, dims=1)

fig = Figure(size=(800, 600))
ax1 = Axis(fig[1,1], xlabel="Génération")
ax2 = Axis(fig[2,1], xlabel="Génération")
ax3 = Axis(fig[3,1], xlabel="Génération")
lines!(ax1, 1:generations, timeseries[1,:], label="Barren", color="#A9A9A9")  # Dark Gray
lines!(ax1, 1:generations, timeseries[6,:], label="Burning", color="#FF4500")  # Orange Red
lines!(ax2, 1:generations, timeseries[2,:], label="Grass", color="#32CD32")   # Lime Green
lines!(ax2, 1:generations, timeseries[3,:], label="Shrubs", color="#FFA500")  # Orange
lines!(ax3, 1:generations, timeseries[4,:], label="Tree sp. 1", color="#1E90FF")  # Dodger Blue
lines!(ax3, 1:generations, timeseries[5,:], label="Tree sp. 2", color="#8A2BE2")  # Blue Violet
Legend(fig[1,2], ax1, framevisible=false)
Legend(fig[2,2], ax2, framevisible=false)
Legend(fig[3,2], ax3, framevisible=false)
tightlimits!(ax1)
tightlimits!(ax2)
tightlimits!(ax3)
fig