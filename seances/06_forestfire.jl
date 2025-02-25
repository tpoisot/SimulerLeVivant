using CairoMakie
CairoMakie.activate!(; px_per_unit = 2)
using ProgressMeter

grid_size = (300, 300)

forest = zeros(Int64, grid_size .+ 2);
forestchange = zeros(Int64, grid_size .+ 2);

p = 1e-2
S = 130
f = p * (1 / S)

locations_to_plant = filter(i -> rand() <= p, eachindex(forest[2:(end - 1), 2:(end - 1)]))
forest[locations_to_plant] .= 2;

fire_state_palette = cgrad([:white, :orange, :green], 3; categorical = true)

figure = Figure(; size = (1200, 600), fontsize = 20, backgroundcolor = :transparent)
forest_plot = Axis(figure[1:3, 1])
B_plot = Axis(figure[1, 2])
P_plot = Axis(figure[2, 2])
V_plot = Axis(figure[3, 2])
hidedecorations!(forest_plot)
hidedecorations!(B_plot)
hidedecorations!(P_plot)
hidedecorations!(V_plot)
rowgap!(figure.layout, 5)
colgap!(figure.layout, 5)
current_figure()

heatmap!(forest_plot, forest; colormap = fire_state_palette)
current_figure()

epochs = 1:1000

V = zeros(Int64, length(epochs));
P = zeros(Int64, length(epochs));
B = zeros(Int64, length(epochs));

function _manage_empty_cells!(change, state, position, p_tree)
    if rand() <= p_tree
        setindex!(change, 2, position)
    else
        setindex!(change, 0, position)
    end
    return nothing
end

function _manage_planted_cells!(change, state, position, p_fire)
    if rand() <= p_fire
        setindex!(change, 1, position)
    end
    return nothing
end

function _manage_burning_cells!(change, state, position, kernel)
    for surrounding in kernel
        if state[position + surrounding] == 2
            setindex!(change, 1, position + surrounding)
        end
    end
    setindex!(change, 0, position)
    return nothing
end

function fire!(change, state, p_tree, p_fire; kernel = CartesianIndices((-1:1, -1:1)))
    used_indices = CartesianIndices(forest)[(begin + 1):(end - 1), (begin + 1):(end - 1)]
    for pixel_position in used_indices
        if state[pixel_position] == 0
            _manage_empty_cells!(change, state, pixel_position, p_tree)
        elseif state[pixel_position] == 2
            _manage_planted_cells!(change, state, pixel_position, p_fire)
        elseif state[pixel_position] == 1
            _manage_burning_cells!(change, state, pixel_position, kernel)
        end
    end
    for pixel_position in used_indices
        state[pixel_position] = change[pixel_position]
        change[pixel_position] = state[pixel_position]
    end
    return (count(iszero, state), count(isone, state), count(isequal(2), state))
end

@showprogress for epoch in epochs
    V[epoch], B[epoch], P[epoch] = fire!(forestchange, forest, p, f)
end

heatmap!(forest_plot, forest; colormap = fire_state_palette)
lines!(P_plot, P; color = :green)
lines!(B_plot, B; color = :orange)
lines!(V_plot, V; color = :black)
current_figure()