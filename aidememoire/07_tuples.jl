### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ db9c51b4-c526-11ee-340f-dbac455b3581
md"""
# Tuples

Les tuples sont des collections *immuables*, c'est à dire qu'on ne peut pas modifier. C'est une structure de données idéale pour stocker des paramètres, ou des résultats de modèle.
"""

# ╔═╡ baec0602-f313-4a5e-8c29-3e0191faf391
md"""
Un tuple est défini en utilisant des parenthèses (au lieu des crochets):
"""

# ╔═╡ a01b0186-1435-413e-9daf-c8840171a9cd
x = (1, 2, 3)

# ╔═╡ b055a347-1b62-4282-980c-ae460dd52931
md"""
On peut accéder aux éléments d'un tuple de la même manière qu'un vecteur:
"""

# ╔═╡ 92eaca50-41f4-48e2-94dd-7d8993b06b53
x[1]

# ╔═╡ d2852707-38cb-4423-bdad-01c78280318b
x[2:3]

# ╔═╡ 3458f83a-3d31-4989-a181-4b558626e784
md"""
Julia offre aussi des `NamedTuple`s, qui sont des tuples avec des noms:
"""

# ╔═╡ cc6b8d48-609a-4797-9c0f-17eb59087635
n = (a=1, b=3, c=5)

# ╔═╡ fcd07bc3-6dbe-4f98-a6ca-2abb6373acd9
md"""
On peut accéder aux éléments de ces tuples avec le nom de l'élément:
"""

# ╔═╡ 4d7d6837-1212-4ab1-9fa6-6b0ff237d043
n.a + (n.b * n.c)

# ╔═╡ a6f4983d-2f55-4380-bca1-0dbc767612ef
md"""
Par défaut, une fonction qui renvoie plusieurs arguments les renvoie dans un tuple:
"""

# ╔═╡ 070197e9-484a-4834-bf80-438319f3c7f3
function abc()
	return rand(), rand(), rand()
end

# ╔═╡ 6020e714-e08b-4b50-90d7-2d3a501085fb
abc()

# ╔═╡ 0a5ecc14-266c-4bc6-8c2a-34eacf02f3f0
md"""
On peut aussi allouer les éléments d'un tuple directement dans des variables:
"""

# ╔═╡ 8e7be667-606c-4bac-865b-e4bef771d9ed
a, b, c = abc()

# ╔═╡ 94b9d0ab-2e1a-4878-8f4e-601bb7a3292f
a

# ╔═╡ Cell order:
# ╟─db9c51b4-c526-11ee-340f-dbac455b3581
# ╟─baec0602-f313-4a5e-8c29-3e0191faf391
# ╠═a01b0186-1435-413e-9daf-c8840171a9cd
# ╟─b055a347-1b62-4282-980c-ae460dd52931
# ╠═92eaca50-41f4-48e2-94dd-7d8993b06b53
# ╠═d2852707-38cb-4423-bdad-01c78280318b
# ╟─3458f83a-3d31-4989-a181-4b558626e784
# ╠═cc6b8d48-609a-4797-9c0f-17eb59087635
# ╟─fcd07bc3-6dbe-4f98-a6ca-2abb6373acd9
# ╠═4d7d6837-1212-4ab1-9fa6-6b0ff237d043
# ╟─a6f4983d-2f55-4380-bca1-0dbc767612ef
# ╠═070197e9-484a-4834-bf80-438319f3c7f3
# ╠═6020e714-e08b-4b50-90d7-2d3a501085fb
# ╟─0a5ecc14-266c-4bc6-8c2a-34eacf02f3f0
# ╠═8e7be667-606c-4bac-865b-e4bef771d9ed
# ╠═94b9d0ab-2e1a-4878-8f4e-601bb7a3292f
