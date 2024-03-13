library(phyloseq)
library(ape)
library(tidyverse)
library(picante)
library(vegan)

#### Load in RData ####
load("anemia_rare.RData")


#### Phylogenetic diversity ####

# calculate Faith's phylogenetic diversity as PD
phylo_dist <- pd(t(otu_table(anemia_rare)), phy_tree(anemia_rare),
                 include.root=F) 
# add PD to metadata table
sample_data(anemia_rare)$PD <- phylo_dist$PD

#### Extracting Info for Stats ####
# Need to extract information to do stats for each category
alphadiv <- estimate_richness(anemia_rare)
samp_dat <- sample_data(anemia_rare)
samp_dat_wdiv <- data.frame(samp_dat, alphadiv)

#### Alpha diversity - CRP Status ######
gg_richness_crp <- plot_richness(anemia_rare, x = "crp_status", measures = c("Shannon","Chao1")) +
  xlab("CRP Status") +
  geom_boxplot()

gg_richness_crp

# t.test()
t.test(samp_dat_wdiv$Shannon ~ samp_dat_wdiv$crp_status)
t.test(samp_dat_wdiv$Chao1 ~ samp_dat_wdiv$crp_status)

# plot CRP Status against the PD
crp.plot.pd <- ggplot(sample_data(anemia_rare), aes(crp_status, PD)) + 
  geom_boxplot() +
  xlab("CRP Status") +
  ylab("Phylogenetic Distance")

# view plot
gg_diversity_crp <- crp.plot.pd

#### Alpha diversity - Adjusted Ferritin Status ####

gg_richness_fer <- plot_richness(anemia_rare, x = "adj_ferritin_status", measures = c("Shannon","Chao1")) +
  xlab("Adjusted Ferritin Status") +
  geom_boxplot()

gg_richness_fer

# t.test()
t.test(samp_dat_wdiv$Shannon ~ samp_dat_wdiv$adj_ferritin_status)
t.test(samp_dat_wdiv$Chao1 ~ samp_dat_wdiv$adj_ferritin_status)

# plot Ferritin Status against the PD
fer.plot.pd <- ggplot(sample_data(anemia_rare), aes(adj_ferritin_status, PD)) + 
  geom_boxplot() +
  xlab("Adjusted Ferritin Status") +
  ylab("Phylogenetic Distance")

# view plot
gg_diversity_fer <- fer.plot.pd


#### Alpha diversity - Adjusted Body Iron Storage Status ####

gg_richness_bis <- plot_richness(anemia_rare, x = "adj_bis_status", measures = c("Shannon","Chao1")) +
  xlab("Adjusted Body Iron Storage") +
  geom_boxplot()

gg_richness_bis

# t.test()
t.test(samp_dat_wdiv$Shannon ~ samp_dat_wdiv$adj_bis_status)
t.test(samp_dat_wdiv$Chao1 ~ samp_dat_wdiv$adj_bis_status)

# plot adjusted BIS against the PD
bis.plot.pd <- ggplot(sample_data(anemia_rare), aes(adj_bis_status, PD)) + 
  geom_boxplot() +
  xlab("Adjusted Body Iron Storage") +
  ylab("Phylogenetic Distance")

# view plot
gg_diversity_bis <- bis.plot.pd

#### Alpha diversity - Adjusted RBP Status ####

gg_richness_rbp <- plot_richness(anemia_rare, x = "adj_rbp_status", measures = c("Shannon","Chao1")) +
  xlab("Adjusted RBP Status") +
  geom_boxplot()

gg_richness_rbp

# t.test()
t.test(samp_dat_wdiv$Shannon ~ samp_dat_wdiv$adj_rbp_status)
t.test(samp_dat_wdiv$Chao1 ~ samp_dat_wdiv$adj_rbp_status)

# plot adjusted RBP Status against the PD
rbp.plot.pd <- ggplot(sample_data(anemia_rare), aes(adj_rbp_status, PD)) + 
  geom_boxplot() +
  xlab("Adjusted RBP Status") +
  ylab("Phylogenetic Distance")

# view plot
gg_diversity_rbp <- rbp.plot.pd


#### Alpha diversity - Infection Status ####

# Set the infection_status variable as a factor and re-order the the levels
infection_status_ordered <- factor(sample_data(anemia_rare)$infection_status,
                                   levels = c("Reference", "Early Convalescence", "Late Convalescence", "Incubation"))

# Replace the infection_status column in the phyloseq object with this ordered factor
sample_data(anemia_rare)$infection_status <- infection_status_ordered

# Calculate Shannon diversity
otu_table <- otu_table(anemia_rare)
shannon_diversity <- diversity(t(otu_table), index = "shannon")

# Create a data frame for plotting
df <- data.frame(
  infection_status = sample_data(anemia_rare)$infection_status,
  shannon = shannon_diversity
)

#ANOVA shannon vs. infection_status

lm_shannon_vs_infection <- lm(Shannon ~ infection_status, data=samp_dat_wdiv)
aov_shannon_vs_infection <- aov(lm_shannon_vs_infection)
summary(aov_shannon_vs_infection)

# Access the ANOVA summary
anova_summary <- summary(aov_shannon_vs_infection)

#### Making Plot of Alpha Diversity for Infection Status ####
# Extract the p-value for 'infection_status'
p_value <- anova_summary[[1]]$"Pr(>F)"[1]

# Create a significance label based on the p-value
signif_label <- ifelse(p_value < 0.05, "p < 0.05", "NS")

x_pos <- 2.5  
y_pos <- max(samp_dat_wdiv$Shannon + 0.2)

# Add a buffer on top of the maximum y-value
buffer_amount <- (max(samp_dat_wdiv$Shannon, na.rm = TRUE) - min(samp_dat_wdiv$Shannon, na.rm = TRUE)) * 0.1
y_limit <- max(samp_dat_wdiv$Shannon, na.rm = TRUE) + buffer_amount

# Set colours
color_blind_friendly_colors <- c("Reference" = "#D55E00",
                                 "Early Convalescence" = "#E69F00", 
                                 "Late Convalescence" = "#009E73",
                                 "Incubation" = "#56B4E9")

# Plot
gg_richness_inf <- ggplot(df, aes(x = infection_status, y = shannon, fill = infection_status)) +
  expand_limits(y = c(NA, y_limit)) +
  geom_boxplot() +
  geom_point(position = position_jitter(width = 0.2), color = "black", alpha = 0.8) +
  scale_fill_manual(values = color_blind_friendly_colors) + 
  theme_minimal() +
  theme(
    legend.position = "right",
    legend.background = element_blank(),
    legend.box.background = element_rect(color="black"),
    axis.text.x = element_blank(), # This will remove the x-axis labels
    axis.ticks.x = element_blank(), # This will remove the x-axis ticks
    panel.grid.major = element_blank(), # Remove major grid lines
    panel.grid.minor = element_blank(),  # Remove minor grid lines
    panel.border = element_rect(colour = "black", fill=NA, size=0.5), # Add border around the plot
    axis.ticks = element_line(color = "black"), # Add ticks on y-axis
    legend.key.size = unit(1.5, "lines") # Adjust the size of legend keys
  ) +
  guides(fill = guide_legend(override.aes = list(color = NA))) + # Remove color guide from legend
  labs(
    x = "", 
    y = "Shannon Diversity Index", 
    fill = "Infection Status", 
    title = "", 
    color = NULL # Remove color label from legend
  ) + 
  geom_text(x = x_pos, y = y_pos, label = signif_label, size = 3.5, vjust = 0, fontface = "plain") +
  geom_segment(x = 1, xend = 4, y = y_pos - 0.05, yend = y_pos - 0.05, color = "black") + # Horizontal line
  geom_segment(x = 1, xend = 1, y = y_pos - 0.05, yend = y_pos - 0.08, color = "black") + # Left vertical line
  geom_segment(x = 4, xend = 4, y = y_pos - 0.05, yend = y_pos - 0.08, color = "black") # Right vertical line

# Print the plot to view it
gg_richness_inf


