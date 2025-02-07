using ProgressMeter
using CairoMakie
CairoMakie.activate!(; px_per_unit=2)

W = 100
H = 200
T = 1000
forest = zeros(UInt8, T, W, H)

fire_state_palette = cgrad([:white, :orange, :green], 3; categorical=true)

pt = 1e-2
pc = 0.1
S = 130
pf = pt * (1 / S)

function neighborsof(x, y, sx, sy)
    nx = [x - 1, x, x + 1]
    ny = [y - 1, y, y + 1]
    nx[1] = iszero(nx[1]) ? sx : nx[1]
    ny[1] = iszero(ny[1]) ? sy : ny[1]
    nx[3] = (nx[3] == sx + 1) ? 1 : nx[3]
    ny[3] = (ny[3] == sy + 1) ? 1 : ny[3]
    return [(i, j) for i in nx for j in ny]
end

function cluster!(forest, i, j, p)
    ns = neighborsof(i, j, size(forest)...)
    for n in ns
        if forest[n...] == 0
            if rand() <= p
                forest[n...] = 2
                cluster!(forest, n..., p)
            end
        end
    end
    return forest
end

function initial!(forest, pc, tr)
    for i in axes(forest, 1)
        for j in axes(forest, 2)
            if rand() < pc
                forest[i, j] = 2
                cluster!(forest, i, j, pt / pc)
            end
        end
    end
    return forest
end

initial!(view(forest, 1, :, :), pc, pt)
heatmap(forest[1, :, :])

@showprogress for t in 1:(T-1)
    current = view(forest, t, :, :)
    future = view(forest, t + 1, :, :)
    for i in axes(current, 1)
        for j in axes(current, 2)
            if current[i, j] == 2
                if rand() <= pf
                    future[i, j] = 1
                else
                    future[i, j] = 2
                    for n in neighborsof(i, j, size(current)...)
                        if rand() <= pt
                            future[n...] = 2
                        end
                    end
                end
            end
            if current[i, j] == 1
                future[i, j] == 0
                for n in neighborsof(i, j, size(future)...)
                    if future[n...] == 2
                        future[n...] = 1
                    end
                end
            end
        end
    end
end

fig = Figure()
ax = Axis(fig[1,1], aspect=DataAspect())
heatmap!(ax, forest[T,:,:], colormap=fire_state_palette)
current_figure()