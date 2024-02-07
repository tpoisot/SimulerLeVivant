### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 6c29c2f0-c5d6-11ee-3a73-b9ec268c8591
md"""
# `map`, `filter`, et `reduce`
"""

# ╔═╡ bf419cff-bcb7-40a9-a175-7098a5c707c2
md"""
Dans certaines situations, on peut éviter le recours à l'itération pour travailler rapidement sur des collections de valeurs.
"""

# ╔═╡ ecf8fc94-a2d7-4555-9cd2-4a2bbcb4dc46
md"""
## `map`
"""

# ╔═╡ 8fc3daf8-db3b-4cc6-bee1-b46d10af06b1
map(x -> 2x, [1, 2, 3])

# ╔═╡ bbecee5f-7e2d-452c-bfbb-f3657c9b6521
md"""
L'opérateur `map` permet d'appliquer une fonction (son premier argument) sur une collection (son deuxième argument). Notez qu'on peut définir une fonction "anonyme" (avec la syntaxe `x -> ...`), ou utiliser une fonction existante:
"""

# ╔═╡ 48f24fd3-6b0e-490a-850c-bf2f1b00903a
map(iseven, [1,2,3])

# ╔═╡ cda49cc8-13c8-415f-8f8d-22efc7d3d72b
md"""
**À lire aussi**: la documentation de `map!`, `pmap`, et `mapslices`.
"""

# ╔═╡ 660e7120-d1a9-4d89-a188-c057df1350ad
md"""
## `filter`
"""

# ╔═╡ bddb0e70-c3ae-4215-a3b8-9aadf4c169f3
filter(iseven, [1,2,3,4,5])

# ╔═╡ 73ad4a92-7fbc-4419-aa86-7bcb25d69c1e
md"""
L'opérateur `filter` permet de garder seulement les éléments d'une collection qui correspondent à un critère, donné par une fonction qui est son premier argument. C'est une méthode très pratique pour sélectionner des éléments d'une collection quand on sait ce qu'on cherche!
"""

# ╔═╡ 36a2e769-9d37-427e-9e47-cc11b3e9e6d3
md"""
## `reduce`
"""

# ╔═╡ 5852a25c-b3e0-40e7-ab58-3a4b1acc20a0
reduce(+, [1,2,3,4])

# ╔═╡ 7b843b57-f2ff-4b52-9f54-366c738874ea
md"""
L'opérateur `reduce` applique son premier argument de manière récursive.
"""

# ╔═╡ 648cb0ca-2dba-4c79-b9d0-17b4f0901f18
md"""
## Exercice optionnel
"""

# ╔═╡ 80dc5475-aae6-4b08-94f0-05998ef24af6
md"""
Il y à une erreur dans la définition de la fonction `map2`, qui est une ré-écriture de `map` "à la main".
"""

# ╔═╡ 47f905cc-edbe-4486-a0ea-9de256489921
function map2(f, x)
	resultat = []
	for element in x
		push!(resultat, f(x))
	end
	return resultat
end

# ╔═╡ 2afad73f-d180-4418-a94c-7643186903b9
resultat2 = map2(x -> 2x, [1,2,3,4])

# ╔═╡ e330ebb5-6403-4a9d-a59d-74923a9550be
md"""
**Résultat**: $(resultat2 != [2,4,6,8] ? "Le bug est toujours présent" : "C'est ça!")
"""

# ╔═╡ Cell order:
# ╟─6c29c2f0-c5d6-11ee-3a73-b9ec268c8591
# ╟─bf419cff-bcb7-40a9-a175-7098a5c707c2
# ╟─ecf8fc94-a2d7-4555-9cd2-4a2bbcb4dc46
# ╠═8fc3daf8-db3b-4cc6-bee1-b46d10af06b1
# ╟─bbecee5f-7e2d-452c-bfbb-f3657c9b6521
# ╠═48f24fd3-6b0e-490a-850c-bf2f1b00903a
# ╟─cda49cc8-13c8-415f-8f8d-22efc7d3d72b
# ╟─660e7120-d1a9-4d89-a188-c057df1350ad
# ╠═bddb0e70-c3ae-4215-a3b8-9aadf4c169f3
# ╟─73ad4a92-7fbc-4419-aa86-7bcb25d69c1e
# ╟─36a2e769-9d37-427e-9e47-cc11b3e9e6d3
# ╠═5852a25c-b3e0-40e7-ab58-3a4b1acc20a0
# ╟─7b843b57-f2ff-4b52-9f54-366c738874ea
# ╟─648cb0ca-2dba-4c79-b9d0-17b4f0901f18
# ╠═80dc5475-aae6-4b08-94f0-05998ef24af6
# ╠═47f905cc-edbe-4486-a0ea-9de256489921
# ╠═2afad73f-d180-4418-a94c-7643186903b9
# ╟─e330ebb5-6403-4a9d-a59d-74923a9550be
