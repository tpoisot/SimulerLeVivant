using Random
using CairoMakie
using Printf

CairoMakie.activate!(px_per_unit = 6.0)

# Paramètres
alleles = ('a', 'A')
p = 0.5  # Fréquence de l'allèle 'A'
q = 1 - p  # Fréquence de l'allèle 'a'
generations = 2000  # Nombre de générations à simuler
population_size = 2000  # Taille de la population

# Coefficients de sélection
s_AA = -0.08  # Coefficient de sélection pour AA
s_Aa = 0.02 # Coefficient de sélection pour Aa
s_aa = 0.00  # Coefficient de sélection pour aa

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

    return (AA, Aa, aa, w_bar)
end

# Tableau pour stocker les fréquences génotypiques au fil du temps
genotype_frequencies = zeros(Float64, generations + 1, 3)
genotype_frequencies[1, :] .= hardy_weinberg_selection(p, q, s_AA, s_Aa, s_aa)[1:3]

# Simuler au fil des générations
for gen in 1:generations
    p = genotype_frequencies[gen, 1] + 0.5 * genotype_frequencies[gen, 2]
    q = 1 - p

    # Ajouter la dérive génétique
    num_A = sum(rand() < p for _ in 1:population_size)
    p = num_A / population_size
    q = 1 - p

    genotype_frequencies[gen + 1, :] .= hardy_weinberg_selection(p, q, s_AA, s_Aa, s_aa)[1:3]
end

# on this line only, write code to get the fitness over time in a vector
average_fitness = [hardy_weinberg_selection(sqrt(genotype_frequencies[gen, 1]) + 0.5 * genotype_frequencies[gen, 2], 1 - (sqrt(genotype_frequencies[gen, 1]) + 0.5 * genotype_frequencies[gen, 2]), s_AA, s_Aa, s_aa)[4] for gen in 1:generations+1]

# Tracé
fig = Figure(size = (800, 600))
ax = Axis(fig[1, 1], title = "Fréquences génotypiques au fil des générations avec sélection et dérive", xlabel = "Génération", ylabel = "Fréquence")

# Tracer les surfaces remplies pour chaque génotype
gen_range = 0:generations
AA_freq = genotype_frequencies[:, 1]
Aa_freq = genotype_frequencies[:, 2]
aa_freq = genotype_frequencies[:, 3]

# Calculate cumulative frequencies for stacked bands
Aa_cumulative = AA_freq + Aa_freq
aa_cumulative = Aa_cumulative + aa_freq

# Plot stacked bands
b1 = band!(ax, gen_range, 0, AA_freq, color = (:blue, 0.5), label = "AA")
b2 = band!(ax, gen_range, AA_freq, Aa_cumulative, color = (:orange, 0.5), label = "Aa")
b3 = band!(ax, gen_range, Aa_cumulative, aa_cumulative, color = (:purple, 0.5), label = "aa")

lines!(ax, gen_range, AA_freq, color=:black, linewidth=0.5)
lines!(ax, gen_range, Aa_cumulative, color=:black, linewidth=0.5)

# Create and position the legend
Legend(fig[1, 2], ax)

ax2 = Axis(fig[2, 1])
lines!(ax2, gen_range, average_fitness)


tightlimits!(ax)
tightlimits!(ax2)
fig

