using Literate
using CairoMakie

# Read the files
seances = readdir("seances", join=true)

# Output path
out_path = joinpath(pwd(), "output")
if ~ispath(out_path)
    mkpath(out_path)
end

# Config for the execution of notebooks
cfg = Dict(
    "credit" => false,
    "execute" => true,
    "continue_on_error" => true
)

# Run the files
for seance in seances
    Literate.markdown(seance, out_path; config=cfg)
end

# TODO: pandoc -> typst -> PDF