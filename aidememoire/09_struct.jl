### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 0beb29b2-cab6-11ee-3eb0-3f37fff39bbc
md"""
# Création de nouveaux types

On peut créer de nouveaux types (`struct`), qui permettent de regrouper plusieurs données sur les mêmes objets:
"""

# ╔═╡ aa3a0406-6913-40c4-97cb-d38b70560067
mutable struct Walker
	x::Integer
	y::Integer
	age::Integer
end

# ╔═╡ 488ed10a-86b1-4b25-82f9-6cceca1994de
md"""
Pour créer un `Walker` à la position 1,1 et avec un age de 10, on peut utiliser:
"""

# ╔═╡ 3704a4e7-2496-4ac9-8ea4-7fd96989e53f
Walker(1,1,10)

# ╔═╡ 7b2ed64c-ba06-445c-bc6a-b3d02878ad53
md"""
Dans certains cas, on veut pouvoir utiliser des valeurs par défaut:
"""

# ╔═╡ 39ea288b-9e18-4dfb-96a7-6c13adc2fbaa
Base.@kwdef mutable struct Walker2
	x::Integer = rand(1:128)
	y::Integer = rand(1:128)
	age::Integer = 10
end

# ╔═╡ aa218511-ff55-4b3f-961a-a2e799457ef7
Walker2()

# ╔═╡ e415607f-a9c3-4305-ac61-e0f26f35e786
Walker2(y=5)

# ╔═╡ 784a4eed-82ec-4f9e-bea4-1e71719ba071
md"""
On peut accéder aux *champs* d'un `struct` en utilisant le point:
"""

# ╔═╡ fd3a6ecf-efbd-4689-9671-7b4196cfe3f8
example = Walker2()

# ╔═╡ 0943c8f3-2210-4f6c-adb5-4023bcf05851
example.age

# ╔═╡ 58b75324-2d08-4016-a626-8b7f5775786a
md"""
Si le `struct` est *mutable*, on peut modifier la valeur des champs:
"""

# ╔═╡ 2741f73a-9f3a-47de-9dbd-d3933e9f80d3
example.age += 2

# ╔═╡ 84f40372-d6ac-4eee-baed-81885a13475d
example

# ╔═╡ fbb95215-2c4e-400f-82a8-f2b7ef424875
md"""
*Julia* permet de limiter l'application d'une fonction selon le type des arguments. Par exemple, on peut écrire une fonction qui simule le déplacement, en la limitant aux `Walker2`:
"""

# ╔═╡ 8b92fd03-f250-49cb-b22c-a4e769c7cc07
function move!(walker::Walker2)
	Δx, Δy = rand(-1:1, 2)
	walker.x = min(128, max(walker.x + Δx, 1))
	walker.y = min(128, max(walker.y + Δy, 1))
	return walker
end

# ╔═╡ f91d23f7-a43a-43fa-9474-2f1a0d4c56f3
move!(example)

# ╔═╡ ab12d7ab-035e-4892-9019-ffb29cfe1a30
md"""
Remarquez qu'on utilise la notation `!` à la fin de la fonction pour *indiquer* qu'on va modifier l'argument.
"""

# ╔═╡ 7f0ca721-e601-4122-981b-877286f3888d
for t in 1:10
	move!(example)
	@info "L'agent est à la position $(example.x), $(example.y)"
end

# ╔═╡ Cell order:
# ╟─0beb29b2-cab6-11ee-3eb0-3f37fff39bbc
# ╠═aa3a0406-6913-40c4-97cb-d38b70560067
# ╟─488ed10a-86b1-4b25-82f9-6cceca1994de
# ╠═3704a4e7-2496-4ac9-8ea4-7fd96989e53f
# ╟─7b2ed64c-ba06-445c-bc6a-b3d02878ad53
# ╠═39ea288b-9e18-4dfb-96a7-6c13adc2fbaa
# ╠═aa218511-ff55-4b3f-961a-a2e799457ef7
# ╠═e415607f-a9c3-4305-ac61-e0f26f35e786
# ╟─784a4eed-82ec-4f9e-bea4-1e71719ba071
# ╠═fd3a6ecf-efbd-4689-9671-7b4196cfe3f8
# ╠═0943c8f3-2210-4f6c-adb5-4023bcf05851
# ╟─58b75324-2d08-4016-a626-8b7f5775786a
# ╠═2741f73a-9f3a-47de-9dbd-d3933e9f80d3
# ╠═84f40372-d6ac-4eee-baed-81885a13475d
# ╟─fbb95215-2c4e-400f-82a8-f2b7ef424875
# ╠═8b92fd03-f250-49cb-b22c-a4e769c7cc07
# ╠═f91d23f7-a43a-43fa-9474-2f1a0d4c56f3
# ╟─ab12d7ab-035e-4892-9019-ffb29cfe1a30
# ╠═7f0ca721-e601-4122-981b-877286f3888d
