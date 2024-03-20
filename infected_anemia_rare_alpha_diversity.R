#!/usr/bin/env Rscript
library(tidyverse)
library(phyloseq)
library(ape)
library(tidyverse)
library(picante)
library(vegan)
library(dplyr)

#### Load data ####
load("anemia_rare.RData")
# Add new column to Phyloseq Object with an infection category which classifies participants as either infected or normal
# Access the sample data from phyloseq object
anemia_rare_data <- sample_data(anemia_rare)

# Apply the condition to modify/create a new column, named 'infection_category'
anemia_rare_data$infection_status_updated <- ifelse(anemia_rare_data$infection_status %in% c("Early Convalescence", "Late Convalescence", "Incubation"),
                                                    "Infected",
                                                    ifelse(anemia_rare_data$infection_status == "Reference",
                                                           "Normal", NA))

# Update the sample data in your phyloseq object
sample_data(anemia_rare) <- anemia_rare_data

# Now, filter the phyloseq object to include only samples where infection_status_updated is "Infected"
anemia_rare_infected <- subset_samples(anemia_rare, infection_status_updated == "Infected")


#### Phylogenetic diversity ####

# calculate Faith's phylogenetic diversity as PD
phylo_dist <- pd(t(otu_table(anemia_rare_infected)), phy_tree(anemia_rare_infected),
                 include.root=F) 
# add PD to metadata table
sample_data(anemia_rare_infected)$PD <- phylo_dist$PD

#### Extracting Info for Stats ####
# Need to extract information to do stats for each category
alphadiv <- estimate_richness(anemia_rare_infected)
samp_dat <- sample_data(anemia_rare_infected)
samp_dat_wdiv <- data.frame(samp_dat, alphadiv)

#### Alpha diversity - Adjusted Ferritin Status ####

gg_richness_fer <- plot_richness(anemia_rare_infected, x = "adj_ferritin_status", measures = c("Shannon","Chao1")) +
  xlab("Adjusted Ferritin Status") +
  geom_boxplot()

gg_richness_fer

# t.test()
t_test_result <- t.test(samp_dat_wdiv$Shannon ~ samp_dat_wdiv$adj_ferritin_status)
t.test(samp_dat_wdiv$Chao1 ~ samp_dat_wdiv$adj_ferritin_status)

# plot Ferritin Status against the PD
fer.plot.pd <- ggplot(sample_data(anemia_rare_infected), aes(adj_ferritin_status, PD)) + 
  geom_boxplot() +
  xlab("Adjusted Ferritin Status") +
  ylab("Phylogenetic Distance")


#### Making Plot of Alpha Diversity for Adjusted Ferritin Status ####

#### SHANNON ####
# Extract the p-value for 'infection_status'
p_value_fer <- t_test_result$p.value

# Create a significance label based on the p-value
signif_label_fer <- ifelse(p_value_fer < 0.05, "p < 0.05", "NS")

# Calculate x_pos for the plot with two categories
x_pos_fer <- 1.5  

# Since there are only two categories, adjust y_pos accordingly
y_pos_fer <- max(samp_dat_wdiv$Shannon) + 0.2

# Add a buffer on top of the maximum y-value for the y-axis limit
buffer_amount <- (max(samp_dat_wdiv$Shannon, na.rm = TRUE) - min(samp_dat_wdiv$Shannon, na.rm = TRUE)) * 0.1
y_limit <- max(samp_dat_wdiv$Shannon, na.rm = TRUE) + buffer_amount

# Plot richness for adjusted ferritin status
gg_richness_fer <- ggplot(samp_dat_wdiv, aes(x = adj_ferritin_status, y = Shannon, fill = adj_ferritin_status)) +
  expand_limits(y = c(NA, y_limit)) +
  geom_boxplot() +
  geom_point(position = position_jitter(width = 0.2), color = "black", alpha = 0.8) +
  scale_fill_hue() +  # Use ggplot's built-in color palette
  theme_minimal() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(colour = "black", fill=NA, size=0.5),
    axis.ticks = element_line(color = "black")
  ) +
  labs(
    x = "", 
    y = "Shannon Diversity Index",
    fill = "Adjusted Ferritin Status",
    title = "Alpha Diversity in Infected 12-Month-Old Anemic Patients", 
    color = "Adjusted Ferritin Status"
  ) + 
  geom_text(x = x_pos_fer, y = y_pos_fer, label = signif_label_fer, size = 3.5, vjust = 0, fontface = "plain") + 
  geom_segment(x = 1, xend = 2, y = y_pos_fer - 0.05, yend = y_pos_fer - 0.05, color = "black") +
  geom_segment(x = 1, xend = 1, y = y_pos_fer - 0.05, yend = y_pos_fer - 0.08, color = "black") +
  geom_segment(x = 2, xend = 2, y = y_pos_fer - 0.05, yend = y_pos_fer - 0.08, color = "black")

# Print the plot to view it
print(gg_richness_fer)
# view plot
gg_diversity_fer <- fer.plot.pd


#### CHAO1 ####

# Extract the p-value for 'infection_status'
p_value_fer <- t_test_result$p.value

# Create a significance label based on the p-value
signif_label_fer <- ifelse(p_value_fer < 0.05, "p < 0.05", "NS")

# Calculate x_pos for the plot with two categories
x_pos_fer <- 1.5  

# Since there are only two categories, adjust y_pos accordingly
y_pos_fer <- max(samp_dat_wdiv$Chao1) + 0.2

# Add a buffer on top of the maximum y-value for the y-axis limit
buffer_amount <- (max(samp_dat_wdiv$Chao1, na.rm = TRUE) - min(samp_dat_wdiv$Chao1, na.rm = TRUE)) * 0.1
y_limit <- max(samp_dat_wdiv$Chao1, na.rm = TRUE) + buffer_amount

# Plot richness for adjusted ferritin status
gg_richness_fer <- ggplot(samp_dat_wdiv, aes(x = adj_ferritin_status, y = Chao1, fill = adj_ferritin_status)) +
  expand_limits(y = c(NA, y_limit)) +
  geom_boxplot() +
  geom_point(position = position_jitter(width = 0.2), color = "black", alpha = 0.8) +
  scale_fill_hue() +  # Use ggplot's built-in color palette
  theme_minimal() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(colour = "black", fill=NA, size=0.5),
    axis.ticks = element_line(color = "black")
  ) +
  labs(
    x = "", 
    y = "CHAO1 Index",
    fill = "Adjusted Ferritin Status",
    title = "Alpha Diversity in Infected 12-Month-Old Anemic Patients", 
    color = "Adjusted Ferritin Status"
  ) + 
  geom_text(x = x_pos_fer, y = y_pos_fer, label = signif_label_fer, size = 3.5, vjust = 0, fontface = "plain") + 
  geom_segment(x = 1, xend = 2, y = y_pos_fer - 0.05, yend = y_pos_fer - 0.05, color = "black") +
  geom_segment(x = 1, xend = 1, y = y_pos_fer - 0.05, yend = y_pos_fer - 0.08, color = "black") +
  geom_segment(x = 2, xend = 2, y = y_pos_fer - 0.05, yend = y_pos_fer - 0.08, color = "black")

# Print the plot to view it
print(gg_richness_fer)
# view plot
gg_diversity_fer <- fer.plot.pd
