# ---
# title: Séance 1
# topic: La pigmentation de _Conus textile_
# author: Timothée Poisot
# ---

# # Concepts principaux

# ## Valeurs Booléennes

# Les valeurs Booléennes représentent les états "vrai" et "faux", et sont
# particulièrement importantes pour nous: elles vont intervenir dans la majorité
# des sénces. De manière générale, beaucoup de décisions que nous allons prendre
# seront _in fine_ des questions dont la réponse est "oui" ou "non", et les
# valeurs Booléennes sont appropriés dans ce contexte.

# La première valeur est "vrai":

true

# et la second est "faux":

false

# Nous pouvons combiner ces valeurs via différentes opérations.

# ## Opérations sur les valeurs Booléennes

# Les valeurs Booléennes ont leurs propres opérations. Ces opérations ont la
# propriété de prendre comme entrée une où plusieurs valeurs Booléenes, et de
# retourner une réponse Booléenne.

# La première est le `or`, qui renvoie vrai _ssi_ au moins une de ses entrées
# est vrai. Elle est représentée par la barre verticale:

true | true
#-
true | false
#-
false | false

# La seconde opération importante est `and`, qui renvoie vrai _ssi_ ses deux
# entrées sont vraies. Elle est représentée par le signe `&`:

true & true
#-
true & false
#-
false & false

# On peut aussi prendre la _négation_ d'une valeur Booléenne avec l'opérateur
# `not`, qui est en général représenté par `!`, mais parfois aussi par `~`:

!true
#-
!false

# Le dernier opérateur Booléen est le `xor` ("où exclusif"), qui renvoie vrai
# uniquement _ssi_ l'opération `or` appliquée à des deux entrées revnoie vrai
# _et_ que l'opération `and` renvoie faux. Il est representé par le signe `⊻`,
# qui s'écrit `\xor<Tab>`

true ⊻ false
#-
false ⊻ false
#-
true ⊻ true

# Ces opérateurs peuvent être utilisés pour prendre des décisions complexes. Par
# exemple, `⊻` est défini, pour deux entrées `x₁` et `x₂`, comme `(x₁ | x₂) &
# (!(x₁ & x₂))`.

# ## Vecteurs et indexation

# # Installer des packages

# ## Les projets

# ~~~ julia
# import Pkg
# Pkg.activate(".")
# ~~~

# ## Installer un package

# ~~~ julia
# Pkg.add("CairoMakie")
# ~~~

# ## Charger un package

# ~~~ julia
# using CairoMakie
# ~~~

# # Simulation: _Conus textile_

# ## Définir les paramètres de la simulation

n_cellules = 161

# Définir le nombre de générations comme (n_cellules - 1) / 2 et convertir en entier
n_generations = Int((n_cellules - 1) / 2)

gen_actuelle = zeros(Bool, n_cellules)
gen_suivante = zeros(Bool, n_cellules)

# Trouver l'index de la cellule au milieu et mettre sa valeur à true
milieu_index = div(length(gen_actuelle), 2) + 1
gen_actuelle[milieu_index] = true

# ## Effectuer la simulation

for generation in 1:n_generations
    # Afficher l'état actuel de gen_actuelle
    println(afficher_generation(gen_actuelle))

    for cellule in 2:n_cellules-1
        p = gen_actuelle[cellule-1]
        q = gen_actuelle[cellule]
        r = gen_actuelle[cellule+1]

        # Règle de transition pour la Rule 30 des automates cellulaires : p xor (q or r)
        gen_suivante[cellule] = p ⊻ (q || r)
    end

    for i in 1:n_cellules
        gen_actuelle[i] = gen_suivante[i]
    end
end

# ## Afficher l'état final de la simulation

println(afficher_generation(gen_actuelle))