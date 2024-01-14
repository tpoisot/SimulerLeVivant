### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 4daecee2-b0ed-11ee-037a-27a1fac99fcd
using PlutoUI

# ╔═╡ 608acd8b-0bc4-49d9-abd0-5a9a816ddfb1
md"""
## Vecteurs
"""

# ╔═╡ 30ca87f7-1ad8-4a71-9025-22075dae1210
md"""
Éléments: $(@bind entries Scrubbable(1:8; default=4))
"""

# ╔═╡ 4acd2837-df8e-449e-b47c-07967ee2a33f
vecteur = rand(Float32, entries)

# ╔═╡ 532a24be-84c2-4aa9-953c-b34fb7786d3d
md"""
⚠️ Les vecteurs sont des *colonnes* par défaut
"""

# ╔═╡ d0e52727-9729-4209-b876-c9d137dd8681
md"""
## Matrices
"""

# ╔═╡ b667171f-6539-4dad-998b-62c8fca8a6ed
md"""
Colonnes: $(@bind cols Scrubbable(3:6; default=3))

Lignes: $(@bind rows Scrubbable(4:7; default=5))
"""

# ╔═╡ f39cb991-e0a6-49a2-9915-c3bd8ca92856
matrice = rand(Bool, (rows, cols))

# ╔═╡ 8e88146d-061a-413b-9886-f2c46a79002e
@info size(matrice)

# ╔═╡ bbf93d45-e419-49e4-a074-a4c9879aa4ba
@info axes(matrice, 1)

# ╔═╡ bfa5ff30-4107-4f3f-88a2-ce28253902e2
md"""
## Comment accéder à des éléments
"""

# ╔═╡ 4bf606ff-4359-4599-b9d1-e5fbd5d6dcea
collect(CartesianIndices(matrice))

# ╔═╡ 77f13ae3-c7f5-46d9-b3d5-7e105cfacc24
collect(LinearIndices(matrice))

# ╔═╡ fb393a33-c70b-4871-94ea-12bd22dc46c6
md"""
💁 Les matrices sont stockées en mémoire *par colonnes*
"""

# ╔═╡ bc38da6b-ff94-4c24-a7dd-026c09e35662
for i in eachindex(vecteur) # Accès aux positions d'une collection
	@info i
end

# ╔═╡ b43420e3-3ec4-431e-adbe-267f29ddd089
for (i,e) in enumerate(vecteur) # Accès aux entrées et à la position
	@info i, e
end

# ╔═╡ 421d5a31-7dfa-4089-9224-7752f5b96c09
for e in vecteur # Accès au contenu seulement
	@info e
end

# ╔═╡ 71156fef-c75f-4bb7-b4f5-8d644cd8addc
for p in CartesianIndices(vecteur) # On peut itérer sur n'importe quelle collection!
	@info p, vecteur[p]
end

# ╔═╡ 2ab9bf51-c1b3-400a-9439-ea78cead00cc
md"""
⚠️ On ne peut pas accéder à une entrée qui n'existe pas!

La `matrice` a $(rows) lignes et $(cols) colonnes.

`matrice`[$(@bind row Scrubbable(3:12; default=3)), $(@bind col Scrubbable(4:8; default=5))]
"""

# ╔═╡ faaf662c-1957-41bf-b62b-95f733d26fc8
matrice[row, col]

# ╔═╡ 7abde2f3-e53e-414b-b989-9632a975a7b7
md"""
💁 On peut accéder à une ligne ou une colonne

La `matrice` a $(rows) lignes et $(cols) colonnes.

`matrice`[$(@bind slicei Scrubbable(1:rows; default=3)), `:`]
"""

# ╔═╡ 2fa0c162-11d4-49b5-8b2e-32bd07523cf0
matrice[slicei,:]

# ╔═╡ 93d5fc2e-10c0-4548-b266-2d08a62ab977
md"""
🧪 Quel est le résultat de `matrice[:, 1:2]` ?
"""

# ╔═╡ 57241797-f606-4c11-a07c-2773cc823f57
md"""
## Les `CartesianIndices`

🕵️ On peut additionner ces objets!
"""

# ╔═╡ 6cbb0b85-36df-4cb4-ba86-24316b32d9f7
CartesianIndex(1,2) + CartesianIndex(1,0)

# ╔═╡ fd2771f8-0faa-4cfa-8a9d-8be9f8484bc4
CartesianIndex(1,1) + CartesianIndex(-1, 2)

# ╔═╡ 0e49b12a-f59a-44d7-a86c-13b7f126e831
neighbors = [
	CartesianIndex(0,+1),
	CartesianIndex(-1,0),
	CartesianIndex(+1,0),
	CartesianIndex(0,-1), 
] # C'est un vecteur!

# ╔═╡ b3d236c8-846b-4f55-9f47-04b691527d8b
for neighbor in neighbors
	@info CartesianIndex(2,3) + neighbor
end

# ╔═╡ 67c26ac0-10a8-48b2-a388-698adfe4d04c
md"""
⁉️ Que fait le code suivant?
"""

# ╔═╡ fc989a47-fdc2-4637-b868-f392e12c63a2
for neighbor in neighbors
	if CartesianIndex(1,1) + neighbor in CartesianIndices(matrice)
		@info CartesianIndex(1,1) + neighbor
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "3c61004d0ad425a97856dfe604920e9ff261614a"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─608acd8b-0bc4-49d9-abd0-5a9a816ddfb1
# ╟─30ca87f7-1ad8-4a71-9025-22075dae1210
# ╠═4acd2837-df8e-449e-b47c-07967ee2a33f
# ╟─532a24be-84c2-4aa9-953c-b34fb7786d3d
# ╟─d0e52727-9729-4209-b876-c9d137dd8681
# ╟─b667171f-6539-4dad-998b-62c8fca8a6ed
# ╠═f39cb991-e0a6-49a2-9915-c3bd8ca92856
# ╠═8e88146d-061a-413b-9886-f2c46a79002e
# ╠═bbf93d45-e419-49e4-a074-a4c9879aa4ba
# ╟─bfa5ff30-4107-4f3f-88a2-ce28253902e2
# ╠═4bf606ff-4359-4599-b9d1-e5fbd5d6dcea
# ╠═77f13ae3-c7f5-46d9-b3d5-7e105cfacc24
# ╟─fb393a33-c70b-4871-94ea-12bd22dc46c6
# ╠═bc38da6b-ff94-4c24-a7dd-026c09e35662
# ╠═b43420e3-3ec4-431e-adbe-267f29ddd089
# ╠═421d5a31-7dfa-4089-9224-7752f5b96c09
# ╠═71156fef-c75f-4bb7-b4f5-8d644cd8addc
# ╟─2ab9bf51-c1b3-400a-9439-ea78cead00cc
# ╟─faaf662c-1957-41bf-b62b-95f733d26fc8
# ╟─7abde2f3-e53e-414b-b989-9632a975a7b7
# ╟─2fa0c162-11d4-49b5-8b2e-32bd07523cf0
# ╟─93d5fc2e-10c0-4548-b266-2d08a62ab977
# ╟─57241797-f606-4c11-a07c-2773cc823f57
# ╠═6cbb0b85-36df-4cb4-ba86-24316b32d9f7
# ╠═fd2771f8-0faa-4cfa-8a9d-8be9f8484bc4
# ╠═0e49b12a-f59a-44d7-a86c-13b7f126e831
# ╠═b3d236c8-846b-4f55-9f47-04b691527d8b
# ╟─67c26ac0-10a8-48b2-a388-698adfe4d04c
# ╠═fc989a47-fdc2-4637-b868-f392e12c63a2
# ╟─4daecee2-b0ed-11ee-037a-27a1fac99fcd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
