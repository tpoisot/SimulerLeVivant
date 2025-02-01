using Random
using StatsBase
using CairoMakie
using ProgressMeter
using Statistics

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
        wt = drift(pop[:,(i-1)], Ne) .* w
        wbar = sum(wt)
        #pop[:,i] = drift(wt./wbar, Ne)
        pop[:,i] = wt./wbar
    end
    return pop
end

# Paramètres
p = 0.3  # Fréquence de l'allèle 'A'
generations = 500
Ne = 2_000
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

# Replicates, pop size
replicates = 400
popsizes = 20
Ns = ceil.(Int64, logrange(100, 10_000, popsizes))
results = zeros(Float64, replicates, popsizes)

@showprogress for replicate in axes(results, 1)
    for i in axes(results, 2)
        S = simulate(p, s, generations, Ns[i])
        results[replicate, i] = S[2,end]
    end
end

# Treatment
M = vec(mean(results; dims=1))
Q10 = [quantile(results[:,i], [0.1])[1] for i in axes(results, 2)]
Q90 = [quantile(results[:,i], [0.9])[1] for i in axes(results, 2)]

fig2 = Figure()
ax = Axis(fig2[1,1], xscale=log10)
band!(ax, Ns, Q10, Q90, color=:grey, alpha=0.5)
scatter!(ax, Ns, M, color=:black)
lines!(ax, Ns, Q10, color=:black, linestyle=:dash)
lines!(ax, Ns, Q90, color=:black, linestyle=:dash)
ylims!(ax, 0, 1)
tightlimits!(ax)
fig2
