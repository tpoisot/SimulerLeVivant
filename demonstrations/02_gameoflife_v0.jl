### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ b21940b0-754b-481c-ad4b-047988d12c18
md"""
# *Game of Life* (version 0)

Pendant les deux semaines suivant la séance, commentez ce code pour expliquer *ce qu'il fait*.

Un commentaire commence après le symbole `#`

~~~julia
2 + 2 # Ça fait 4
~~~

On peut écrire un bloc de commentaires entre `#=` et `=#`

~~~julia
#=
Ça fait toujours
à peu près
4
=#
2 + 2
~~~

"""

# ╔═╡ 90a78c2d-5a16-4bae-b4bc-4736be80a2c8
md"""
## Variables de base pour la simulation
"""

# ╔═╡ d33f2da3-9227-4be0-b8c0-cd26c9ec9dcf
n_colonnes = 250

# ╔═╡ 101971da-adad-4bd2-8cef-246ddfe6b7e7
n_lignes = 250

# ╔═╡ 1209ff9d-ddd6-46a3-803e-71617cf857ab
life = rand(Bool, (n_lignes, n_colonnes))

# ╔═╡ ff31d715-74ae-47f8-8192-86c5f4570324
md"""
## Définition des voisins
"""

# ╔═╡ 3d06a979-9e10-44e4-aae4-6392155c0e38
voisins = [
	CartesianIndex(-1,-1),
	CartesianIndex(-1,0),
	CartesianIndex(-1,1),
	CartesianIndex(0,-1),
	CartesianIndex(0,1),
	CartesianIndex(1,-1),
	CartesianIndex(1,0),
	CartesianIndex(1,1)
]

# ╔═╡ 93e32a7c-5850-49d4-9c93-b8d0eae7ff35
md"""
## Fonctions

L'aide-mémoire sur les fonctions a des exemples de *documentation* (pas simplement de *commentaires*) des fonctions, vous pouvez essayer de les adapter!

"""

# ╔═╡ 14589d68-9068-431e-826f-5b6897475ede
function nombre_de_voisins(etat, voisins)
	voisins_actifs = zeros(Int64, size(etat))
	for cell in CartesianIndices(etat)
		for voisin in voisins
			if cell + voisin in CartesianIndices(etat)
				if etat[cell + voisin]
					voisins_actifs[cell] += 1
				end
			end
		end
	end
	return voisins_actifs
end

# ╔═╡ 6d4ba2b7-6ba1-4ec6-85cb-fa3e20e162ee
function mise_a_jour!(etat, voisins)
	voisins_actifs = nombre_de_voisins(etat, voisins)
	for cell in CartesianIndices(etat)
		if etat[cell] == true
			if voisins_actifs[cell] in [2,3]
				etat[cell] = true
			else
				etat[cell] = false
			end
		else
			if voisins_actifs[cell] == 3
				etat[cell] = true
			end
		end
	end
	return etat
end

# ╔═╡ f703e977-5ec9-4e6f-bbe1-2bbc1e029ea5
md"""
## Simulation sur 1000 pas de temps
"""

# ╔═╡ 463b28b7-736c-42e2-89db-c4bd7f37ee04
for t in 1:1000
	mise_a_jour!(life, voisins)
end

# ╔═╡ Cell order:
# ╟─b21940b0-754b-481c-ad4b-047988d12c18
# ╟─90a78c2d-5a16-4bae-b4bc-4736be80a2c8
# ╠═d33f2da3-9227-4be0-b8c0-cd26c9ec9dcf
# ╠═101971da-adad-4bd2-8cef-246ddfe6b7e7
# ╠═1209ff9d-ddd6-46a3-803e-71617cf857ab
# ╟─ff31d715-74ae-47f8-8192-86c5f4570324
# ╠═3d06a979-9e10-44e4-aae4-6392155c0e38
# ╟─93e32a7c-5850-49d4-9c93-b8d0eae7ff35
# ╠═14589d68-9068-431e-826f-5b6897475ede
# ╠═6d4ba2b7-6ba1-4ec6-85cb-fa3e20e162ee
# ╟─f703e977-5ec9-4e6f-bbe1-2bbc1e029ea5
# ╠═463b28b7-736c-42e2-89db-c4bd7f37ee04
