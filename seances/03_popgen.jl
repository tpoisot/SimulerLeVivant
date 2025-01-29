using Random
using CairoMakie

# Paramètres
alleles = ('a', 'A')
p = 0.6  # Fréquence de l'allèle 'A'
q = 1 - p  # Fréquence de l'allèle 'a'
generations = 300  # Nombre de générations à simuler
population_size = 1000  # Taille de la population

# Coefficients de sélection
s_AA = 0.01  # Coefficient de sélection pour AA
s_Aa = 0.04  # Coefficient de sélection pour Aa
s_aa = 0.0  # Coefficient de sélection pour aa

# Fonction pour simuler une génération sous sélection
function hardy_weinberg_selection(p, q, s_AA, s_Aa, s_aa)
    # Fréquences génotypiques sans sélection
    AA = p^2
    Aa = 2 * p * q
    aa = q^2

    # Appliquer la sélection
    w_AA = 1 + s_AA
    w_Aa = 1 + s_Aa
    w_aa = 1 + s_aa

    # Fitness moyenne
    w_bar = AA * w_AA + Aa * w_Aa + aa * w_aa

    # Fréquences génotypiques ajustées
    AA = (AA * w_AA) / w_bar
    Aa = (Aa * w_Aa) / w_bar
    aa = (aa * w_aa) / w_bar

    return (AA, Aa, aa)
end

# Tableau pour stocker les fréquences génotypiques au fil du temps
genotype_frequencies = zeros(Float64, generations + 1, 3)
genotype_frequencies[1, :] .= hardy_weinberg_selection(p, q, s_AA, s_Aa, s_aa)

# Simuler au fil des générations
for gen in 1:generations
    p = genotype_frequencies[gen, 1] + 0.5 * genotype_frequencies[gen, 2]
    q = 1 - p

    # Ajouter la dérive génétique
    num_A = sum(rand() < p for _ in 1:population_size)
    p = num_A / population_size
    q = 1 - p

    genotype_frequencies[gen + 1, :] .= hardy_weinberg_selection(p, q, s_AA, s_Aa, s_aa)
end

# Afficher les résultats
println("Génération\tAA\t\tAa\t\taa")
for gen in 0:generations
    println("$gen\t\t$(genotype_frequencies[gen + 1, 1])\t$(genotype_frequencies[gen + 1, 2])\t$(genotype_frequencies[gen + 1, 3])")
end

# Tracé
fig = Figure(size = (800, 600))
ax = Axis(fig[1, 1], title = "Fréquences génotypiques au fil des générations avec sélection et dérive", xlabel = "Génération", ylabel = "Fréquence")

# Tracer les surfaces remplies pour chaque génotype
gen_range = 0:generations
AA_freq = genotype_frequencies[:, 1]
Aa_freq = genotype_frequencies[:, 2]
aa_freq = genotype_frequencies[:, 3]

lines!(ax, gen_range, AA_freq, color = :blue, label = "AA")
lines!(ax, gen_range, Aa_freq, color = :green, label = "Aa")
lines!(ax, gen_range, aa_freq, color = :red, label = "aa")

axislegend(ax)
fig

