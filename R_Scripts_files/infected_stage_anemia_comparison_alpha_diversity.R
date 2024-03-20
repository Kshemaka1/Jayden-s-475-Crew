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


#### Alpha diversity - Infection Status ####

# Set the infection_status variable as a factor and re-order the the levels
infection_status_ordered <- factor(sample_data(anemia_rare_infected)$infection_status,
                                   levels = c("Early Convalescence", "Late Convalescence", "Incubation"))

# Replace the infection_status column in the phyloseq object with this ordered factor
sample_data(anemia_rare_infected)$infection_status <- infection_status_ordered

# Calculate Shannon diversity
otu_table <- otu_table(anemia_rare_infected)
shannon_diversity <- diversity(t(otu_table), index = "shannon")

# Create a data frame for plotting
df <- data.frame(
  infection_status = sample_data(anemia_rare_infected)$infection_status,
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

x_pos_inf <- 2  
y_pos_inf <- max(samp_dat_wdiv$Shannon + 0.2)

# Add a buffer on top of the maximum y-value
buffer_amount <- (max(samp_dat_wdiv$Shannon, na.rm = TRUE) - min(samp_dat_wdiv$Shannon, na.rm = TRUE)) * 0.1
y_limit <- max(samp_dat_wdiv$Shannon, na.rm = TRUE) + buffer_amount

# Set colours
color_blind_friendly_colors <- c("Early Convalescence" = "#E69F00", 
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
  geom_text(x = x_pos_inf, y = y_pos_inf, label = signif_label, size = 3.5, vjust = 0, fontface = "plain") +
  geom_segment(x = 1, xend = 3, y = y_pos_inf - 0.05, yend = y_pos_inf - 0.05, color = "black") + # Horizontal line
  geom_segment(x = 1, xend = 1, y = y_pos_inf - 0.05, yend = y_pos_inf - 0.08, color = "black") + # Left vertical line
  geom_segment(x = 4, xend = 4, y = y_pos_inf - 0.05, yend = y_pos_inf - 0.08, color = "black") # Right vertical line

# Print the plot to view it
gg_richness_inf


