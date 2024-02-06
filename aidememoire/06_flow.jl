### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 391ff076-c526-11ee-349a-bd0f0e0aad1a
md"""
# *Control Flow*
"""

# ╔═╡ c9a3d3e1-6128-49f6-9c61-0aea2b411705
md"""
Dans une boucle, le mot-clé `continue` a pour effet de *sauter* l'itération en cours:
"""

# ╔═╡ 7cabe841-265d-4930-a16d-19440a8c7389
for i in 1:5
	if i == 3
		continue
	end
	@info i
end

# ╔═╡ 096d0b52-2a72-4d48-b5f6-6e104854932a
md"""
Le mot-clé `break` va mettre fin à la boucle entièrement:
"""

# ╔═╡ 58001665-91d8-4aa6-a5cc-2457614a2bf8
for i in 1:5
	if i == 4
		break
	end
	@info i
end

# ╔═╡ d7b827bb-f01e-4f85-b9bd-a0e9e7835be6
md"""
L'utilisation de `continue` et `break` permet d'économiser du temps en s'assurant de ne faire que les opérations nécessaires!
"""

# ╔═╡ Cell order:
# ╟─391ff076-c526-11ee-349a-bd0f0e0aad1a
# ╟─c9a3d3e1-6128-49f6-9c61-0aea2b411705
# ╠═7cabe841-265d-4930-a16d-19440a8c7389
# ╟─096d0b52-2a72-4d48-b5f6-6e104854932a
# ╠═58001665-91d8-4aa6-a5cc-2457614a2bf8
# ╟─d7b827bb-f01e-4f85-b9bd-a0e9e7835be6
