library(phyloseq)
library(ape)
library(tidyverse)
library(picante)

#### Load in RData ####
load("anemia_rare.RData")
load("12M_anemia_final.RData")

#### Alpha diversity ######
plot_richness(anemia_rare) 

plot_richness(anemia_rare, measures = c("Shannon","Chao1")) 


gg_richness <- plot_richness(anemia_rare, x = "adj_bis_status", measures = c("Shannon","Chao1")) +
  xlab("Adjusted Body Iron Storage") +
  geom_boxplot()
gg_richness

ggsave(filename = "plot_richness.png"
       , gg_richness
       , height=4, width=6)

estimate_richness(anemia_rare)

# phylogenetic diversity

# calculate Faith's phylogenetic diversity as PD
phylo_dist <- pd(t(otu_table(anemia_rare)), phy_tree(anemia_rare),
                 include.root=F) 
# add PD to metadata table
sample_data(anemia_rare)$PD <- phylo_dist$PD

# plot any metadata category against the PD
plot.pd <- ggplot(sample_data(anemia_rare), aes(adj_bis_status, PD)) + 
  geom_boxplot() +
  xlab("Adjusted Body Iron Storage") +
  ylab("Phylogenetic Distance")

# view plot
gg_diversity <- plot.pd

ggsave(filename = "phylogeny_plot(Faith's).png"
       , gg_diversity
       , height=4, width=6)
