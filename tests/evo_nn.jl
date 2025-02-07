using CairoMakie
using LinearAlgebra

# Define the number of inputs and outputs
n_inputs = 3
n_outputs = 2

# Initialize weights and biases
w = randn(Float64, n_inputs, n_outputs)
b = randn(Float64, n_outputs)

# Define the activation function (ReLU in this case)
function relu(x)
    return max.(0, x)
end

# Define the one-layer neural network function
function one_layer_nn(x, w, b)
    # Single layer
    z = w' * x .+ b
    a = tanh.(z)
    
    return a
end

# Example input
info = rand(n_inputs)

# Forward pass through the neural network
output = one_layer_nn(info, w, b)
println("Output of the neural network: ", output)

mutable struct LittleGuy
    w::Matrix{Float64} # Weights
    b::Vector{Float64} # Biases
    v::Float64 # Velocity
    a::Float64 # Angle
    e::Float64 # Energy
    x::Float64
    y::Float64
end

pop = [LittleGuy(randn(n_inputs, 2), randn(n_inputs), rand(), rand(), 10.0, randn(), randn()) for _ in 1:100]

# Function to cast rays and count visible LittleGuys
function cast_rays(guy::LittleGuy, population::Vector{LittleGuy}, num_rays::Int, angle_range::Float64)
    counts = zeros(Int, num_rays)
    ray_angles = LinRange(guy.a - angle_range / 2, guy.a + angle_range / 2, num_rays)
    
    for (i, ray_angle) in enumerate(ray_angles)
        for other_guy in population
            if other_guy !== guy
                dx = other_guy.x - guy.x
                dy = other_guy.y - guy.y
                distance = sqrt(dx^2 + dy^2)
                angle_to_other = atan(dy, dx)
                
                if abs(angle_to_other - ray_angle) < 0.1 # Adjust threshold as needed
                    counts[i] += 1
                end
            end
        end
    end
    
    return counts
end

# Example usage
[cast_rays(guy, pop, 10, π / 3) for guy in pop]

scatter([g.x for g in pop], [g.y for g in pop])