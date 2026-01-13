using Random
using Statistics

# Vous devrez installer ces deux packages
using StatsBase
using CairoMakie
using ProgressMeter

CairoMakie.activate!(px_per_unit = 6.0)


# Conversion des fréquences
frequences_genotypes(p, q) = [p*p, 2*p*q, q*q]
frequences_genotypes(p) = frequences_genotypes(p, 1-p)

function drift(ft, Ne)
    gen = sample(1:length(ft), Weights(ft), Ne; replace=true)
    return [sum(gen .== i) / length(gen) for i in eachindex(ft)]
end

function simulate(p, s, gen, Ne)
    pop = zeros(Float64, length(s), gen)
    pop[:,1] = frequences_genotypes(p)
    w = 1.0 .+ s
    for i in 2:gen
        wt = pop[:,(i-1)] .* w
        wbar = sum(wt)
        pop[:,i] = drift(wt./wbar, Ne)
    end
    return pop
end

# Paramètres
p = 0.3  # Fréquence de l'allèle 'A'
generations = 500
Ne = 200
s = [0.005, -0.01, 0.005] # AA, Aa, aa

S = simulate(p, s, generations, Ne)

fig = Figure(size=(700, 300))
ax = Axis(fig[1,1]; xlabel="Génération", ylabel="Fréquence")
lines!(ax, S[1,:], label="AA")
lines!(ax, S[2,:], label="Aa")
lines!(ax, S[3,:], label="aa")
ylims!(ax, 0, 1)
tightlimits!(ax)
Legend(fig[1,2], ax)
fig
