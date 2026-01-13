# ---
# title: La pigmentation de _Conus textile_
# author: Timothée Poisot
# ---

# # Introduction

n_cellules = 161

# Définir le nombre de générations comme (n_cellules - 1) / 2 et convertir en entier
n_generations = Int((n_cellules - 1) / 2)

gen_actuelle = zeros(Bool, n_cellules)
gen_suivante = zeros(Bool, n_cellules)

# Trouver l'index de la cellule au milieu et mettre sa valeur à true
milieu_index = div(length(gen_actuelle), 2) + 1
gen_actuelle[milieu_index] = true

# Fonction pour convertir les valeurs booléennes en carrés pleins / espaces
function afficher_generation(generation)
    return join([cellule ? '█' : ' ' for cellule in generation], "")
end

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

# Afficher l'état final de gen_actuelle
println(afficher_generation(gen_actuelle))