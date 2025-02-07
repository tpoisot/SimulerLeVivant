using CairoMakie
using StatsBase

mutable struct Agent
    x::Int64
    y::Int64
    clock::Int64
    infectious::Bool
end

xmax = 50
ymax = 50

population = [Agent(rand(1:xmax), rand(1:ymax), 20, false) for _ in 1:2000]
rand(population).infectious = true

infectious(pop) = filter(ag -> ag.infectious, pop)
healthy(pop) = filter(ag -> !ag.infectious, pop)
incell(target, pop) = filter(ag -> (ag.x, ag.y) == (target.x, target.y), pop)


tick = 0
maxlength = 200
S = zeros(Int64, maxlength)
I = zeros(Int64, maxlength)
events = []

while (length(infectious(population)) != 0)&(tick < maxlength)

    tick += 1

    # Move
    for agent in population
        agent.x += rand(-1:1)
        agent.y += rand(-1:1)
        agent.y = agent.y < 1 ? ymax : agent.y
        agent.x = agent.x < 1 ? xmax : agent.x
        agent.y = agent.y > ymax ? 1 : agent.y
        agent.x = agent.x > xmax ? 1 : agent.x
    end

    # Infection
    for agent in infectious(population)
        neighbors = healthy(incell(agent, population))
        for neighbor in neighbors
            if rand() <= 0.4
                neighbor.infectious = true
                push!(events, (tick, agent.x, agent.y))
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

scatter(x, y, color=t, colormap=:lipari)
