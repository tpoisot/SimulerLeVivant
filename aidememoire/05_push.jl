### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 537a2c06-c1e4-11ee-2726-87a51a06f1b5
md"""
# Modifier un vecteur

L'objectif de cet aide-mémoire est de lister les fonctions qui permettent de modifier un vecteur.
"""

# ╔═╡ ad1c8f9c-0384-4f33-b144-e35ad2c1e68a
vecteur = [1,2,3,4,5,6]

# ╔═╡ 9d0b6606-602e-4cf8-b117-f23a9bd9cdaa
md"""
On peut **ajouter un élément** à un vecteur avec `push!`:
"""

# ╔═╡ b3a9447b-d57d-49fc-949f-8c793d2dfa69
push!(vecteur, maximum(vecteur)+1)

# ╔═╡ 1cc24d94-5933-4292-9a1a-3c430b8e218a
md"""
On peut **ajouter un vecteur** à un vecteur avec `append!`:
"""

# ╔═╡ 57319563-f9a5-4725-9a38-5830f9004d12
append!(vecteur, [1,2,3,4])

# ╔═╡ 6622cccb-e5e0-43e5-90c0-9222c57973e1
md"""
On peut **retirer le dernier élément d'un vecteur** avec `pop!`:
"""

# ╔═╡ c4a4a726-26df-415a-b12c-f965c5c27e86
ancien_dernier_element = pop!(vecteur)

# ╔═╡ 9ede533b-2da4-4242-bb19-083911feb830
vecteur

# ╔═╡ dfcd24c2-7808-458b-aac4-5268d27462eb
md"""
On peut **retirer le premier élément d'un vecteur** avec `popfirst!`:
"""

# ╔═╡ 330c4204-8eab-44dc-86db-c9923117fc96
ancien_premier_element = popfirst!(vecteur)

# ╔═╡ c99074c6-2f4f-4fd7-9d9e-66ba091330c3
vecteur

# ╔═╡ dea9ecee-eea8-4c36-9d39-1ca0ffa4b9b5
md"""
On peut **retirer un élément arbitraire d'un vecteur** avec `popat!`:
"""

# ╔═╡ 61926aa7-3114-4207-929b-c1e8bb67f677
ancien_deuxieme_element = popat!(vecteur, 2)

# ╔═╡ 42d79b5b-b7b6-4c28-8542-9746959a82f4
vecteur

# ╔═╡ 29ae457d-c940-49bb-95c0-388a3ad9cdd6
md"""
Les fonctions `pop!`, `popfirst!`, et `popat!` renvoient l'élément qui a été supprimé. La fonction `deleteat!` fait la même chose que `popat!` mais **renvoie le vecteur**:
"""

# ╔═╡ 8a68eff8-2602-4867-83b6-b33928b1784c
deleteat!(vecteur, 3)

# ╔═╡ 9f8f35bb-a24e-4de1-af0b-7c02ab3d8bbd
md"""
## Exercice

En utilisant `popat!` et `push!, ainsi que `for` et `if`, écrivez une boucle pour passer au travers du vecteur `nombres`, retirer les nombres pairs (regardez la documentation de la fonction `iseven`), et les stocker dans le vecteur `nombres_pairs`.
"""

# ╔═╡ 73e4bbb0-8700-466c-aa86-878b67d9670a
nombres = [1,2,3,4,5,6,7]

# ╔═╡ 0baa3082-e3c1-4844-b965-2fb3fb25d370
nombres_pairs = Int64[]

# ╔═╡ Cell order:
# ╟─537a2c06-c1e4-11ee-2726-87a51a06f1b5
# ╠═ad1c8f9c-0384-4f33-b144-e35ad2c1e68a
# ╟─9d0b6606-602e-4cf8-b117-f23a9bd9cdaa
# ╠═b3a9447b-d57d-49fc-949f-8c793d2dfa69
# ╟─1cc24d94-5933-4292-9a1a-3c430b8e218a
# ╠═57319563-f9a5-4725-9a38-5830f9004d12
# ╟─6622cccb-e5e0-43e5-90c0-9222c57973e1
# ╠═c4a4a726-26df-415a-b12c-f965c5c27e86
# ╠═9ede533b-2da4-4242-bb19-083911feb830
# ╟─dfcd24c2-7808-458b-aac4-5268d27462eb
# ╠═330c4204-8eab-44dc-86db-c9923117fc96
# ╠═c99074c6-2f4f-4fd7-9d9e-66ba091330c3
# ╟─dea9ecee-eea8-4c36-9d39-1ca0ffa4b9b5
# ╠═61926aa7-3114-4207-929b-c1e8bb67f677
# ╠═42d79b5b-b7b6-4c28-8542-9746959a82f4
# ╟─29ae457d-c940-49bb-95c0-388a3ad9cdd6
# ╠═8a68eff8-2602-4867-83b6-b33928b1784c
# ╟─9f8f35bb-a24e-4de1-af0b-7c02ab3d8bbd
# ╠═73e4bbb0-8700-466c-aa86-878b67d9670a
# ╠═0baa3082-e3c1-4844-b965-2fb3fb25d370
