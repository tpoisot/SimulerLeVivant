# ---
# title: Séance 2
# topic: Les tâches et les rayures
# author: Timothée Poisot
# ---

# # Concepts principaux

# ## Indexation basique dans les matrices

# Dans la séance précédente, nous avons vu comment créer des matrices, et
# comment lire le contenu à une ligne et colonne particulière. On peut, en
# pratique, faire beaucoup plus avec des matrices.

# Prenons l'exemple de la matrice suivante, avec trois lignes et cinq colonnes,
# qui contient des nombres aléatoires entiers entre 1 et 5:

V = rand(1:5, 3, 5)

# On peut accéder à la première ligne de cette matrice avec

V[1,:]

# et à sa deuxième colonne avec

V[:,2]

# On peut aussi prendre les deux premières lignes, et les trois dernières
# colonnes, avec

V[begin:(begin+1), (end-2):end]

# Ce qui est la même chose que 

V[1:2, 3:5]

# mais sans avoir besoin d'avoir les coordonées exactes de la dernière colonne.

# ## Indexation avancée dans les matrices

# Les matrices ont toutes un système de coordonées, qui sont soit les coordonées
# Cartésiennes:

collect(CartesianIndices(V))

# soit les coordonées linéaires:

collect(LinearIndices(V))

# Notez que les coordonées linéaires suivent les colonnes: Julia est un langage
# _column-major_, qui va stocker les colonnes ensemble dans la mémoire. Si on
# veut améliorer la performance de nos simulations, opérer sur les colonnes sera
# souvent beaucoup plus rapide que d'opérer sur les lignes.

# Une caractéristique importante des indices est qu'ils sont _relatifs_. Par
# exemple, si on veut exprimer la position qui est "la cellule à gauche de la
# position 3, 4", on peut l'écrire

CartesianIndex(3, 4) + CartesianIndex(-1, 0)

# La position `CartesianIndex(-1, 0)` signifie: une colonne avant, sur la même
# ligne. Nous allons _beaucoup_ utiliser cette propriété pour nous déplacer
# rapidement dans des matrices.

# ## Iteration

# Dans la séance précédente, nous avions utilisé une boucle `for`, qui
# permettait de répéter un processus plusieurs fois. Dans cette séance, nous
# allons formaliser ce concept, qui est fondamental pour le reste du cours.

# Une boucle `for` est une structure qui s'écrit en général de la manière
# suivante:

# ~~~ raw
# for ELEMENT in COLLECTION
#   instructions
# end
# ~~~

# La variable `ELEMENT` n'existe pas en dehors de la boucle. C'est une nuance
# importante: elle est créée par la boucle, et détruite quand la boucle est
# terminée. Une boucle `for` va simplement prendre chaque valeur de
# `COLLECTION`, les stocker dans `ELEMENT`, et on pourra donc appliquer des
# opérations de manière itérative.

# Par exemple, si on veut multiplier par deux tous les éléments du vecteur `[1,
# 2, 3, 4]`, et afficher le résultat sur une nouvelle ligne avec `println`, on
# peut utiliser une boucle `for`:

for x in [1, 2, 3, 4]
    println(2x)
end

# ## Iteration avancée dans les matrices

# On peut traverser des matrices de façon beaucoup plus efficace en combinant
# les boucles `for` et les techniques d'indexation. Pour rappel, dans cette
# section, nous utilisons la matrice suivante:

V = rand(1:9, 3, 4)

# Par exemple, on peut prendre chaque élément d'une matrice sans devoir
# spécifier les lignes et les colonnes:

for v in V
    println(v)
end

# Remarquez que l'ordre des éléments suit ici le `LinearIndex`. On peut aussi
# aller chercher directement les indices des matrices:

for i in eachindex(V)
    println(i)
end

# Mais les indices sont eux-même retournés sous forme de matrice. On peut donc
# itérer sur les indices Cartésiens:

for ci in CartesianIndices(V)
    println(ci)
end

# Cette structure est particulièrement utile, parce que nous aurons souvent
# besoin de faire des tâches comme: pour chaque cellule, prendre la cellue du
# dessus, et si cette cellule est dans la matrice, effectuer une opération sur
# sa valeur.

for position in CartesianIndices(V)
    dessous = position + CartesianIndex(0, -1)
    if dessous in CartesianIndices(V)
        println(dessous)
    end
end

# On utilise ici la structure `if un truc in plusieurs trucs`, qui renvoie
# `true` si l'élément `un truc` fait partie de la collection `plusieurs trucs`.

# On peut enfin itérer d'une manière qui nous renvoie à la fois la position et
# la valeur:

for (position, valeur) in enumerate(V)
    println("La position $position contient la valeur $valeur")
end

# ## Nombres (pseudo)-aléatoires 

import Random
Random.seed!(2045)

# ## Fonctions (moins que le minimum nécessaire!)

function operation(entree1, entree2)
    resultat = entree1 + entree2
    return resultat
end

#-

operation(1, 2)

#-

operation(3.0, 2.5)

# Au cours de la session, nous allons _considérablement_ complexifier les tâches
# que l'on peut faire en déclarant des fonctions, en introduisant notamment des
# valeurs par défaut, des mot-clés, puis enfin des restrictions sur le type des
# entrées. Pour cette séance, cette compréhension de base est suffisante.

# # Un automate cellulaire pour la pigmentation

# Avec cette simulation, nous voulons observer la pigmentation d'un tissu en
# utilisant une série de règles simples qui vont approximer un modèle dit de
# réaction/diffusion. Ces modèles ont été introduits par Alan Turing dans les
# années 1950 @turing1952chemical.

# Le modèle d'origine utilise des équations différentielles partielles pour
# modéliser la diffusion, mais on peut approximer les même mécanismes avec un
# automate cellulaire. Nous allons d'abord définir le problème et son état
# initial, puis introduire les différents règles.

# Ce modèle représente un tissu (la peau ou le pelage d'un animal) comme un
# espace en deux dimensions, dans lequel chaque position (cellule dans une
# lattice) est soit pigmentée (`true`), soit non-pigmentée (`false`).

# ## État initial

# Le tissu a une dimension qui reste fixe pendant toute la simulation. Notez
# qu'ici on définit deux variables sur la même ligne. C'est un raccourci
# d'écriture qui n'est pas nécessaire.

lignes, colonnes = 205, 155 

# On définit ensuite une probabilité que les cellules soient initialement
# pigmentées. Puisque c'est une probabilité, ce nombre devrait être entre 0 et
# 1.

p_activation = 0.01

# Pour l'état initial, on va devoir parcourir une grille de taille `lignes`,
# `colonnes`, et pour chaque cellule, lui donner la valeur qui correspond à la
# pigmentation (`true`) avec une probabilité `p_activation`.

function etat_initial(rows, cols, p_activation)
    lattice = zeros(Bool, rows, cols)
    for row in 1:rows
        for col in 1:cols
            lattice[row, col] = rand() < p_activation
        end
    end
    return lattice
end

# Cette fonction utilise `rand()`, qui par défaut génère un nombre aléatoire
# entre 0 et 1, avec une distribution uniforme.

# Avec ces informations, on peut maintenant créer notre lattice:

lattice = etat_initial(lignes, colonnes, p_activation);

# On n'affiche pas cette lattice, qui peut être très grande.

# Ici, on choisit d'appeller cet object `lattice`, puisque c'est ce qu'il
# représente. Mais on peut donner un nom plus explicite à cet object, comme par
# exemple `pelage`, ou encore `🦓`. Julia accepte la majorité des [symboles
# unicode](https://docs.julialang.org/en/v1/manual/unicode-input/). Il se peut
# que votre police de caractère ne les affiche pas tous --- celles qui ont le
# plus de support sont [Iosevka](https://typeof.net/Iosevka/) (ma préférée!),
# [JuliaMono](https://juliamono.netlify.app/#), et dans une moindre mesure,
# [Noto Sans Mono](https://fonts.google.com/noto/specimen/Noto+Sans+Mono). Elles
# sont toutes gratuites.

# ## Règles biologiques

# Dans notre simulation du modèle de réaction/diffusion, une cellule va
# s'activer si le signal qui encourage son activation est plus grand que le
# signal qui encourage sa désactivation. Ces deux signaux se calculent de la
# même façon: le nombre de voisins actifs, multiplié par le poids du signal d'activation.

# Autrement dit, une cellule se pigmente _si_ $w_a N_a > w_i N_i$, avec $w_a$ et
# $w_i$ les poids de l'activation et de l'inhibition, et $N_a$ et $N_i$ le
# nombre de cellules voisines qui sont activées et inhibées.

# Ce modèle représente une situation dans laquelle une cellule est activée en
# réponse à la diffusion de deux substances: les cellules activées diffusent une
# substance activatrice, et les cellules inhibées diffusent une substance
# inhibitrice. Les poids $w_a$ et $w_i$ mesurent l'affinité des cellules pour
# ces substances, et on peut modifier le rayon de diffusion des substances en
# calculant le nombre de voisins dans un voisinage toujours plus grand.

# ## Mise à jour de l'activation des cellules

# ## Résultat final

using CairoMakie

# Seed


"""
    voisins_valides(lattice, row, col, rayon)

Retourne les voisins valides d'une cellule dans un certain rayon.

Arguments:
- `lattice::Array{Bool, 2}`: Grille de cellules
- `row::Int`: Ligne de la cellule
- `col::Int`: Colonne de la cellule
- `rayon::Int`: Rayon de recherche des voisins

Retourne:
- `Array{Bool, 2}`: Sous-grille des voisins valides
"""
function voisins_valides(lattice, row, col, rayon)
    d_lignes = max(row - rayon, 1)
    f_lignes = min(row + rayon, size(lattice, 1))
    d_colonnes = max(col - rayon, 1)
    f_colonnes = min(col + rayon, size(lattice, 2))
    return lattice[d_lignes:f_lignes, d_colonnes:f_colonnes]
end

"""
    nombre_voisins(lattice, row, col, rayon)

Calcule le nombre de voisins d'une cellule dans un certain rayon.

Arguments:
- `lattice::Array{Bool, 2}`: Grille de cellules
- `row::Int`: Ligne de la cellule
- `col::Int`: Colonne de la cellule
- `rayon::Int`: Rayon de recherche des voisins

Retourne:
- `Int`: Nombre de voisins
"""
function nombre_voisins(lattice, row, col, rayon)
    voisinnage = voisins_valides(lattice, row, col, rayon)
    n_voisins = count(voisinnage)
    return n_voisins
end

"""
    nouvel_etat(Na, Ni, wa, wi)

Détermine le nouvel état d'une cellule en fonction du nombre de voisins activés et inhibés.

Arguments:
- `Na::Int`: Nombre de voisins activés
- `Ni::Int`: Nombre de voisins inhibés
- `wa::Float64`: Poids de l'activation
- `wi::Float64`: Poids de l'inhibition

Retourne:
- `Bool`: Nouvel état de la cellule (true pour activé, false pour désactivé)
"""
function nouvel_etat(Na, Ni, wa, wi)
    etat = wa * Na > wi * Ni
    return etat
end

"""
    afficher_matrice(matrice)

Affiche une matrice de cellules, où les cellules activées sont représentées par '█' et les cellules désactivées par un espace.

Arguments:
- `matrice::Array{Bool, 2}`: Matrice de cellules à afficher

Retourne:
- Rien
"""
function afficher_matrice(matrice)
    for i in 1:size(matrice, 1)
        for j in 1:size(matrice, 2)
            if matrice[i, j] == 1
                print("█")
            else
                print(" ")
            end
        end
        println()
    end
end

# Variables
wa = 1.0   # Poids de l'activation
wi = 0.12  # Poids de l'inhibition
Ra = 2  # Rayon d'activation
Ri = 9  # Rayon d'inhibition

# stuff i guess

temps = 100  # Nombre de générations à simuler

# Initialisation de la grille

# Pour chaque génération
for gen in 1:temps
    ## Grille au temps suivant
    temps_suivant = zeros(Bool, lignes, colonnes)
    ## Pour chaque cellule
    for row in 1:lignes
        for col in 1:colonnes
            ## Calcul du nombre de voisins activés et inhibés
            activation = nombre_voisins(lattice, row, col, Ra)
            inhibition = nombre_voisins(lattice, row, col, Ri)
            ## Détermination du nouvel état de la cellule
            temps_suivant[row, col] = nouvel_etat(activation, inhibition, wa, wi)
        end
    end
    for i in 1:lignes
        for j in 1:colonnes
            lattice[i, j] = temps_suivant[i, j]
        end
    end
end


## Visualisation de type heatmap
heatmap(
    ## On passe d'abord l'objet a visualiser
    lattice,
    ## Puis on fixe les deux couleurs à blanc et noir
    ## pour resp. `false` et `true`
    colormap=[:white, :black],
    ## On spécifie que les cellules du heatmap
    ## sont des carrés
    axis=(; aspect=DataAspect()),
    ## Et on fixe enfin un plus grand nombre de pixles pour avoir
    ## une meilleure résolution
    figure=(; figure_padding=0)
)

## On termine enfin cette figure en retirant les axes et les graduations,
## puis en affichant la figure finale
hidespines!(current_axis())
hidedecorations!(current_axis())
current_figure()
