# ---
# title: Séance 3
# topic: Génétique des populations
# author: Timothée Poisot
# ---

# # Concepts principaux

# ## Fonctions anonymes

# Dans la séance précédente, nous avons commencé a écrire des fonctions. Dans
# certaines situations, il est nécessaire d'utiliser des fonctions, mais
# puisqu'elles sont très simples et à usage unique, on dispose d'une syntaxe
# simplifiée, `argument -> operation`:

x -> 2*x + 1

# Le symbole `->` est simplement `-` puis `>`.

# Ces fonctions peuvent s'utiliser comme des fonctions régulières:

(x -> 2*x + 1)(3)

# ## Mapping et slicing

# On peut automatiser certaines opérations _via_ la fonction `map`:

import Random
Random.seed!(2045)
x = rand(1:5, 10)

#-

map(v -> sqrt(v + 1), x)

# Cette syntaxe est équivalente à l'utilisation d'une boucle `for`: on applique
# la fonction anonyme `x -> sqrt(x + 1)` à chaque élément du vecteur.

# On peut aussi appliquer la fonction `map` sur certaines dimensions d'un objet,
# _via_ `mapslices`. Par exemple:

V = rand(1:10, 3, 4)

#-

mapslices(x -> minimum(x) % 2 == 0, V, dims=1)

# Cette fonction va appliquer la fonction `minimum(x) % 2 == 0`, qui renvoie
# `true` si la plus petite valeur de la colonne est un nombre pair, et `false`
# sinon, pour chaque _colonne_ de la matrice.

# On peut faire la même chose pour les lignes:

mapslices(x -> minimum(x) % 2 == 0, V, dims=2)

# Deux choses sont importantes ici:

# D'abord, la dimension 1 correspond aux _colonnes_, et pas aux _lignes_. C'est
# parce que Julia stocke les colonnes en premier dans la mémoire, et non les
# lignes.

# Enfin, l'objet est retourné sous forme de _matrice_, parce que l'objet donné
# en agument est une matrice.

# On peut éliminer les dimensions qui ne sont plus nécessaires pour obtenir un
# vecteur:

v = mapslices(x -> minimum(x) % 2 == 0, V, dims=2)
dropdims(v, dims=2)

# Notez qu'on peut utiliser `map` et `mapslices` avec le nom d'une fonction qui
# accepte un unique argument:

mapslices(sum, V, dims=1)

# ## Filtres

# # Simulation: maintien du polymorphisme

using CairoMakie
CairoMakie.activate!(px_per_unit=2.0)

import StatsBase

cells = 100
generations = 501
mutation = 1e-4
parents_distance = 3

# État initial
lattice = zeros(Bool, (cells, generations, 3))
for i in Base.OneTo(cells)
    lattice[i,1,:] = rand(Bool, 3)
end

# Première génération
for generation in 2:generations
    for i in Base.OneTo(cells)
        parents_possibles = filter(p -> 1 <= p <= cells, (i-parents_distance):(i+parents_distance))
        parents = StatsBase.sample(parents_possibles, 2, replace=false)
        for gene in 1:3
            lattice[i,generation,gene] = lattice[rand(parents),generation-1,gene]
            if rand() <= mutation
                lattice[i,generation,gene] = !lattice[i,generation,gene]
            end
        end
    end
end

# Fonction pour les couleurs
colormap = dropdims(mapslices(x -> CairoMakie.Colors.RGB(x...), lattice, dims=3), dims=3);

# Heatmap et diversité
f = Figure(; size=(700, 500))
ax = Axis(f[2,1])
heatmap!(ax, 0:(generations-1), 1:cells, permutedims(colormap))
hideydecorations!(ax)
plax = Axis(f[1,1])
lines!(plax, 0:(generations-1), vec(mapslices(x -> length(unique(x)), colormap, dims=1)), color=:black)
ylims!(plax, 1, 8)
xlims!(plax, 0, generations-1)
xlims!(ax, 0, generations-1)
f

# # Suggestions pour le premier devoir

# ## Paysage circulaire

# ## Sélection génétique

# ## Déséquilibre de liaison

# ## Traits quantitatifs