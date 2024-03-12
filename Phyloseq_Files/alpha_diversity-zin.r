library(phyloseq)
library(ape)
library(tidyverse)
library(picante)

#### Load in RData ####
load("anemia_rare.RData")
load("12M_anemia_final.RData")

#### Alpha diversity - CRP Status ######
plot_richness(anemia_rare) 

plot_richness(anemia_rare, measures = c("Shannon","Chao1")) 


gg_richness <- plot_richness(anemia_rare, x = "crp_status", measures = c("Shannon","Chao1")) +
  xlab("CRP Status") +
  geom_boxplot()
gg_richness

estimate_richness(anemia_rare)


# Need to extract information
alphadiv <- estimate_richness(anemia_rare)
samp_dat <- sample_data(anemia_rare)
samp_dat_wdiv <- data.frame(samp_dat, alphadiv)

# t.test()
t.test(samp_dat_wdiv$Shannon ~ samp_dat_wdiv$crp_status)
t.test(samp_dat_wdiv$Chao1 ~ samp_dat_wdiv$crp_status)

#### Alpha diversity - Adjusted Ferritin Status ####

plot_richness(anemia_rare) 

plot_richness(anemia_rare, measures = c("Shannon","Chao1")) 


gg_richness <- plot_richness(anemia_rare, x = "adj_ferritin_status", measures = c("Shannon","Chao1")) +
  xlab("Adjusted Ferritin Status") +
  geom_boxplot()
gg_richness

estimate_richness(anemia_rare)


# Need to extract information
alphadiv <- estimate_richness(anemia_rare)
samp_dat <- sample_data(anemia_rare)
samp_dat_wdiv <- data.frame(samp_dat, alphadiv)

# t.test()
t.test(samp_dat_wdiv$Shannon ~ samp_dat_wdiv$adj_ferritin_status)
t.test(samp_dat_wdiv$Chao1 ~ samp_dat_wdiv$adj_ferritin_status)


#### Alpha diversity - Adjusted Body Iron Storage Status ####

plot_richness(anemia_rare) 

plot_richness(anemia_rare, measures = c("Shannon","Chao1")) 


gg_richness <- plot_richness(anemia_rare, x = "adj_bis_status", measures = c("Shannon","Chao1")) +
  xlab("Adjusted Body Iron Storage Status") +
  geom_boxplot()
gg_richness

estimate_richness(anemia_rare)


# Need to extract information
alphadiv <- estimate_richness(anemia_rare)
samp_dat <- sample_data(anemia_rare)
samp_dat_wdiv <- data.frame(samp_dat, alphadiv)

# t.test()
t.test(samp_dat_wdiv$Shannon ~ samp_dat_wdiv$adj_bis_status)
t.test(samp_dat_wdiv$Chao1 ~ samp_dat_wdiv$adj_bis_status)

#### Alpha diversity - Adjusted RBP Status ####

plot_richness(anemia_rare) 

plot_richness(anemia_rare, measures = c("Shannon","Chao1")) 


gg_richness <- plot_richness(anemia_rare, x = "adj_rbp_status", measures = c("Shannon","Chao1")) +
  xlab("Adjusted RBP Status") +
  geom_boxplot()
gg_richness

estimate_richness(anemia_rare)


# Need to extract information
alphadiv <- estimate_richness(anemia_rare)
samp_dat <- sample_data(anemia_rare)
samp_dat_wdiv <- data.frame(samp_dat, alphadiv)

# t.test()
t.test(samp_dat_wdiv$Shannon ~ samp_dat_wdiv$adj_rbp_status)
t.test(samp_dat_wdiv$Chao1 ~ samp_dat_wdiv$adj_rbp_status)

#### Alpha diversity - Infection Status ####

plot_richness(anemia_rare) 

plot_richness(anemia_rare, measures = c("Shannon","Chao1")) 


gg_richness <- plot_richness(anemia_rare, x = "infection_status", measures = c("Shannon","Chao1")) +
  xlab("Infection Status") +
  geom_boxplot()
gg_richness

estimate_richness(anemia_rare)


# Need to extract information
alphadiv <- estimate_richness(anemia_rare)
samp_dat <- sample_data(anemia_rare)
samp_dat_wdiv <- data.frame(samp_dat, alphadiv)

#ANOVA shannon vs. infection_status

lm_shannon_vs_infection <- lm(Shannon ~ infection_status, data=samp_dat_wdiv)
aov_shannon_vs_infection <- aov(lm_shannon_vs_infection)
summary(aov_shannon_vs_infection)

# phylogenetic diversity

# calculate Faith's phylogenetic diversity as PD
phylo_dist <- pd(t(otu_table(anemia_rare)), phy_tree(anemia_rare),
                 include.root=F) 
# add PD to metadata table
sample_data(anemia_rare)$PD <- phylo_dist$PD

# plot any metadata category against the PD
plot.pd <- ggplot(sample_data(anemia_rare), aes(crp_status, PD)) + 
  geom_boxplot() +
  xlab("CRP Status") +
  ylab("Phylogenetic Distance")

# view plot
gg_diversity <- plot.pd

# t.test




