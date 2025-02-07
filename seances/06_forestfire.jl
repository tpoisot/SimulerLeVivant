using CairoMakie
CairoMakie.activate!(; px_per_unit=2)

grid_size = (550, 450)
epochs = 1:100
forest = zeros(Int64, grid_size);
forestchange = zeros(Int64, grid_size);

fire_state_palette = cgrad([:white, :orange, :green], 3; categorical = true)

p = 1e-2
S = 230
f = p * (1 / S)

function neighborsof(x, y, sx, sy)
    nx = [x - 1, x, x + 1]
    ny = [y - 1, y, y + 1]
    nx[1] = iszero(nx[1]) ? sx : nx[1]
    ny[1] = iszero(ny[1]) ? sy : ny[1]
    nx[3] = (nx[3] == sx + 1) ? 1 : nx[3]
    ny[3] = (ny[3] == sy + 1) ? 1 : ny[3]
    return [(i, j) for i in nx for j in ny if i != j]
end

function grow_cluster!(forest, i, j, ptree)
    ns = neighborsof(i, j, size(forest)...)
    for n in ns
        if rand() <= ptree
            forest[n...] = 2
            grow_cluster!(forest, n..., ptree)
        end
    end
    return forest
end

function plant!(forest, pcluster, ptree)
    for i in axes(forest, 1)
        for j in axes(forest, 2)
            if forest[i, j] != 2
                if rand() < pcluster
                    forest[i, j] = 2
                    grow_cluster!(forest, i, j, ptree)
                end
            end
        end
    end
end

function spread!(forest)
    for i in axes(forest, 1)
        for j in axes(forest, 2)
            if forest[i, j] == 1
                forest[i, j] = 0
                for n in neighborsof(i, j, size(forest)...)
                    if forest[n...] == 2
                        forest[n...] = 1
                    end
                end
            end
        end
    end
end

function grow!(forest, ptree)
    for i in axes(forest, 1)
        for j in axes(forest, 2)
            if forest[i, j] == 2
                grow_cluster!(forest, i, j, ptree)
            end
        end
    end
end

function zap!(forest, pfire)
    for i in axes(forest, 1)
        for j in axes(forest, 2)
            if forest[i, j] == 2
                forest[i, j] = rand() < pfire ? 1 : 2
            end
        end
    end
end

# Initial
plant!(forest, 0.04, 0.1)
heatmap(forest, colormap=fire_state_palette)

plant!(forest, 0.01, p)

grow!(forest, p)
heatmap(forest, colormap=fire_state_palette)

zap!(forest, f)
heatmap(forest, colormap=fire_state_palette)

spread!(forest)
heatmap(forest, colormap=fire_state_palette)
