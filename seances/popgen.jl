using StatsBase
using CairoMakie

pA = 0.4
pB = 0.6

function genotype(g)
    p = ["a", "a", "b", "b"]
    return join([g[i] ? uppercase(p[i]) : p[i] for i in eachindex(p)], "")
end

function initial_population(pA, pB, n)
    return genotype.([(rand() < pA, rand() < pA, rand() < pB, rand() < pB) for _ in 1:n])
end

changecase(x) = islowercase(x) ? uppercase(x) : lowercase(x)

function mutate(genotype)
    return join([rand() <= 0.001 ? changecase(x) : x for x in genotype], "")
end

function random_mating(p1, p2)
    return mutate(join([rand() < 0.5 ? p1[i] : p2[i] for i in eachindex(p1)], ""))
end

function fN(population, allele)
    return sum([count(allele, p) for p in population]) / 2length(population)
end
fA(x) = fN(x, "A")
fB(x) = fN(x, "B")

function fitness(genotype, population; h=0.04, k=0.0)
    pA, pB = fA(population), fB(population)
    s = h * (pB - 0.5)
    t = k * (pA - 0.5)
    W = Dict("AA" => 1, "Aa" => 1 - s / 2, "aA" => 1 - s / 2, "aa" => 1 - s, "BB" => 1, "Bb" => 1 - t / 2, "bB" => 1 - t / 2, "bb" => 1 - t)
    return convert(Float64, W[genotype[1:2]] * W[genotype[3:4]])
end

population = initial_population(pA, pB, 500)

A = zeros(Float64, 1000)
B = zeros(Float64, length(A))

W = zeros(Float64, length(population))

for i in eachindex(A)

    for j in eachindex(population)
        W[j] = fitness(population[j], population)
    end

    # version 1
    # population = StatsBase.sample(population, Weights(W), length(population); replace=true)
    # population = [random_mating(rand(population, 2)...) for _ in eachindex(population)]

    # version 2
    population = [random_mating(rand(population, 2)...) for _ in 2eachindex(population)]
    population = StatsBase.sample(population, Weights(W), length(population); replace=false)

    A[i] = fA(population)
    B[i] = fB(population)

end

f = Figure()
ax = Axis(f[1,1], xlabel="Génération", ylabel="Fréquence de l'allèle dominant")
lines!(ax, A, color=:teal, label="f(A)")
lines!(ax, B, color=:purple, label="f(B)")
tightlimits!(ax)
ylims!(ax, 0, 1)
axislegend(ax, position=:lb)
f