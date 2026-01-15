---
title: Séance 1
topic: La pigmentation de _Conus textile_
author: Timothée Poisot
---

# Concepts principaux

## Valeurs Booléennes

Les valeurs Booléennes représentent les états "vrai" et "faux", et sont
particulièrement importantes pour nous: elles vont intervenir dans la majorité
des sénces. De manière générale, beaucoup de décisions que nous allons prendre
seront _in fine_ des questions dont la réponse est "oui" ou "non", et les
valeurs Booléennes sont appropriés dans ce contexte.

La première valeur est "vrai":

````julia
true
````

````
true
````

et la seconde est "faux":

````julia
false
````

````
false
````

Nous pouvons combiner ces valeurs via différentes opérations.

## Opérations sur les valeurs Booléennes

Les valeurs Booléennes ont leurs propres opérations. Ces opérations ont la
propriété de prendre comme entrée une où plusieurs valeurs Booléenes, et de
retourner une réponse Booléenne.

La première est le `or`, qui renvoie vrai _ssi_ au moins une de ses entrées
est vrai. Elle est représentée par la barre verticale:

````julia
true | true
````

````
true
````

````julia
true | false
````

````
true
````

````julia
false | false
````

````
false
````

La seconde opération importante est `and`, qui renvoie vrai _ssi_ ses deux
entrées sont vraies. Elle est représentée par le signe `&`:

````julia
true & true
````

````
true
````

````julia
true & false
````

````
false
````

````julia
false & false
````

````
false
````

On peut aussi prendre la _négation_ d'une valeur Booléenne avec l'opérateur
`not`, qui est en général représenté par `!`, mais parfois aussi par `~`:

````julia
!true
````

````
false
````

````julia
!false
````

````
true
````

Le dernier opérateur Booléen est le `xor` ("où exclusif"), qui renvoie vrai
uniquement _ssi_ l'opération `or` appliquée à des deux entrées revnoie vrai
_et_ que l'opération `and` renvoie faux. Il est representé par le signe `⊻`,
qui s'écrit `\xor<Tab>`

````julia
true ⊻ false
````

````
true
````

````julia
false ⊻ false
````

````
false
````

````julia
true ⊻ true
````

````
false
````

Ces opérateurs peuvent être utilisés pour prendre des décisions complexes. Par
exemple, `⊻` est défini, pour deux entrées `x₁` et `x₂`, comme `(x₁ | x₂) &
(!(x₁ & x₂))`.

## Vecteurs et matrices

Une des tâches les plus courantes que nous devrons réaliser est de stocker de
l'information dans des structures avec plusieurs dimensions. Autant que
possible, nous essaierons de connaître les dimensions de ces objets avant de
les créer.

Un objet à une seule dimension est un vecteur, et on peut en créer un avec la
commande

````julia
zeros(5)
````

````
5-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 0.0
````

qui se lit "un vecteur de cinq positions initialement rempli de zéros". Par
défaut, ce vecteur pourra stocker des _nombres_ (nous reviendrons sur la
définition d'un nombre plus tard), mais on peut créer un vecteur qui contient
des valeurs Booléennes:

````julia
zeros(Bool, 3)
````

````
3-element Vector{Bool}:
 0
 0
 0
````

**NB**: même si le résultat est affiché avec des `0` et des `1`, il s'agit
bien de valeurs Booléennes; pour gagner de la place, `true` est en général
remplacé par `1` et `false` par `0`.

On peut aussi créer des objets avec plus d'une dimension, comme des matrices
(deux dimensions), des tenseurs (trois dimensions), etc.. Par exemple, cette
commande crée une matrice initialement rempli de valeurs Booléennes
aléatoires, avec 3 lignes et 2 colonnes:

````julia
rand(Bool, 3, 2)
````

````
3×2 Matrix{Bool}:
 0  0
 1  1
 1  1
````

**NB:** regardez la documentation des fonctions `rand` et `ones`.

Au cours de la session, nous allons identifier des façons différentes de
naviguer dans ces objets. Pour le moment, nous allons nous contenter de
trouver et de modifier le contenu de ces objets en utilisant les coordonées.

Pour un vecteur, on peut extraire l'information en utilisant le numéro de la
position. Notez que les vecteurs dans Julia sont des colonnes (pour faciliter
les opérations d'algèbre linéaire):

````julia
V = zeros(Bool, 3)
V[1]
````

````
false
````

On peut modifier la deuxième position de ce vecteur:

````julia
V[2] = true
V
````

````
3-element Vector{Bool}:
 0
 1
 0
````

Il existe aussi les raccourcies `begin` (premier élément) et `end` (dernier
élément):

````julia
V[begin] = true
V
````

````
3-element Vector{Bool}:
 1
 1
 0
````

Pour une matrice, l'indexation se fait exactement de la même manière, mais on
utilise les coordonées sous la forme ligne, colonne:

````julia
M = zeros(Bool, 2, 3)
M[1, 2] = true
M[2, 3] = true
M
````

````
2×3 Matrix{Bool}:
 0  1  0
 0  0  1
````

# Installer des packages

## Les projets

~~~ julia
import Pkg
Pkg.activate(".")
~~~

## Installer un package

~~~ julia
Pkg.add("CairoMakie")
~~~

## Charger un package

````julia
using CairoMakie
````

# Simulation: _Conus textile_

## Définir les paramètres de la simulation

````julia
n_cellules = 191
````

````
191
````

Définir le nombre de générations comme (n_cellules - 1) / 2 et convertir en entier

````julia
n_generations = Int((n_cellules - 1) / 2)
````

````
95
````

TODO

````julia
shell = zeros(Bool, n_cellules, n_generations);
````

Trouver l'index de la cellule au milieu et mettre sa valeur à true

````julia
milieu_index = div(n_cellules, 2) + 1
shell[milieu_index, 1] = true
````

````
true
````

## Effectuer la simulation

````julia
for generation in 2:n_generations

    for cellule in 2:n_cellules-1
        p = shell[cellule-1, generation-1]
        q = shell[cellule, generation-1]
        r = shell[cellule+1, generation-1]

        # Règle de transition pour la Rule 30 des automates cellulaires : p xor (q or r)
        shell[cellule, generation] = p ⊻ (q || r)
    end

end
````

## Afficher l'état final de la simulation

````julia
heatmap(
    shell,
    colormap=[:white, :black],
    axis=(; aspect=DataAspect()),
    figure=(; size=(3n_cellules, 3n_generations), figure_padding=0)
)
hidespines!(current_axis())
hidedecorations!(current_axis())
current_figure()
````
![](01_Conus_textile-66.png)

