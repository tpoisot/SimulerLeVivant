using CairoMakie
using StatsBase
import Random
import UUIDs

Base.@kwdef mutable struct Agent
    x::Int64 = 0
    y::Int64 = 0
    clock::Int64 = 20
    infectious::Bool = false
    id::UUIDs.UUID = UUIDs.uuid4()
end

Base.@kwdef mutable struct Landscape
    xmin::Int64 = -25
    xmax::Int64 = 25
    ymin::Int64 = -25
    ymax::Int64 = 25
end

L = Landscape()

Random.rand(::Type{Agent}, L::Landscape) = Agent(x=rand(L.xmin:L.xmax), y=rand(L.ymin:L.ymax))
Random.rand(::Type{Agent}, L::Landscape, n::Int64) = [rand(Agent, L) for _ in 1:n]

function move!(A::Agent, L::Landscape; torus=true)
    A.x += rand(-1:1)
    A.y += rand(-1:1)
    if torus
        A.y = A.y < L.ymin ? L.ymax : A.y
        A.x = A.x < L.xmin ? L.xmax : A.x
        A.y = A.y > L.ymax ? L.ymin : A.y
        A.x = A.x > L.xmax ? L.xmin : A.x
    else
        A.y = A.y < L.ymin ? L.ymin : A.y
        A.x = A.x < L.xmin ? L.xmin : A.x
        A.y = A.y > L.ymax ? L.ymax : A.y
        A.x = A.x > L.xmax ? L.xmax : A.x
    end
    return A
end

population = rand(Agent, L, 900)
rand(population).infectious = true

infectious(pop) = filter(ag -> ag.infectious, pop)
healthy(pop) = filter(ag -> !ag.infectious, pop)
incell(target, pop) = filter(ag -> (ag.x, ag.y) == (target.x, target.y), pop)

tick = 0
maxlength = 1000
S = zeros(Int64, maxlength)
I = zeros(Int64, maxlength)
events = []

while (length(infectious(population)) != 0)&(tick < maxlength)

    tick += 1

    # Move
    for agent in population
        move!(agent, L; torus=false)
    end

    # Infection
    for agent in Random.shuffle(infectious(population))
        neighbors = healthy(incell(agent, population))
        for neighbor in neighbors
            if rand() <= 0.4
                neighbor.infectious = true
                push!(events, (tick, agent.x, agent.y, agent.id, neighbor.id))
            end
        end
    end

    # Click
    for agent in infectious(population)
        agent.clock -= 1
    end

    # Remove
    population = filter(x -> x.clock > 0, population)

    # Store
    S[tick] = length(healthy(population))
    I[tick] = length(infectious(population))

end

S = S[1:tick]
I = I[1:tick]

lines(S)
lines!(I)
current_figure()

t = [e[1] for e in events]
x = [e[2] for e in events]
y = [e[3] for e in events]

f = Figure()
axl = Axis(f[1,1])
lines!(axl, S)
lines!(axl, I)
axh = Axis(f[2,1])
hist!(axh, collect(values(countmap([e[4] for e in events]))))
axm = Axis(f[1:2,2:3])
scatter!(axm, x, y, color=t, colormap=:lipari)
current_figure()

