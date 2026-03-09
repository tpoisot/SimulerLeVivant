using Literate
using CairoMakie

@info pwd()

const DEVOIR = "BIO2045-A-H26-Devoir 1-6473166"

devoir_path = joinpath(pwd(), "correction", DEVOIR)

# Read the files
travaux = filter(isfile, readdir(devoir_path, join=true))

# Output path
out_path = joinpath(devoir_path, "compilation")
if ~ispath(out_path)
    mkpath(out_path)
end

# Config for the execution of notebooks
cfg = Dict(
    "credit" => false,
    "execute" => true,
    "continue_on_error" => true,
)

# Handling of inline comments

function handle_comments(content)
    matcher = r"^(?<spc>[ \t]++)#\s+(?<txt>.+)$"m
    replacer = "\\g<spc>## \\g<txt>" |> SubstitutionString
    content = replace(content, matcher => replacer)
    content = replace(content, "Pkg.activate(\".\")" => "")
    return content
end

# Run the files
for travail in travaux
    stu_name = split(basename(travail), "_")[1]
    @info stu_name
    md_destination = joinpath(out_path, replace(basename(travail), ".jl" => ".md"))
    if mtime(md_destination) <= mtime(travail)
        try
            out_file = Literate.markdown(travail, out_path; config=cfg, flavor=Literate.CommonMarkFlavor(), preprocess = handle_comments)
            run(`pandoc $(out_file) -o $(replace(out_file, ".md" => ".typ")) --template=correction/template.typ`)
            run(`typst compile $(replace(out_file, ".md" => ".typ"))`)
            run(`rm $(replace(out_file, ".md" => ".typ"))`)
            run(`rm $(out_file)`)
        catch
            @warn "\t$(stu_name) did not compile"
        end
    end
    for f in readdir(out_path; join=true)
        if !(endswith(f, ".pdf") | endswith(f, ".md"))
            rm(f)
        end
    end
end
