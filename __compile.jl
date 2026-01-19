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
    "continue_on_error" => true,
)

run(`cp bibliography.bib $(out_path)`)

# Run the files
for seance in seances
    out_file = Literate.markdown(seance, out_path; config=cfg, flavor = Literate.CommonMarkFlavor())
    @info out_file
    run(`pandoc $(out_file) -o $(replace(out_file, ".md" => ".typ")) --template=template.typ`)
    run(`typst compile $(replace(out_file, ".md" => ".typ"))`)
end

# TODO: pandoc -> typst -> PDF