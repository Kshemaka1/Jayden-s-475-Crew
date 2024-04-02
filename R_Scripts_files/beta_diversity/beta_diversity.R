#!/usr/bin/env Rscript
library(tidyverse)
library(phyloseq)
library(ape)
library(tidyverse)
library(picante)
library(vegan)
library(dplyr)
library(ggforce)

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


#### Beta diversity #####


#Weighted Unifrac
wunifrac_dm <- distance(anemia_rare_infected, method="wunifrac")

pcoa_wunifrac <- ordinate(anemia_rare_infected, method="PCoA", distance=wunifrac_dm)

wunifrac_plot <- plot_ordination(anemia_rare_infected, pcoa_wunifrac, color = "adj_ferritin_status") +
  ggtitle("Weighted Unifrac PCoA") + 
  labs(x = "Principal Coordinate 1 (33.8% Variance Explained)",
       y = "Principal Coordinate 2 (12.2% Variance Explained)",
       color = "Adjusted Ferritin Status")

print(wunifrac_plot)

#PERMANOVA on Weighted Unifrac

dat <- data.frame(sample_data(anemia_rare_infected))
adonis2(wunifrac_dm ~ adj_ferritin_status, data=dat)

#re-plot with PCoA with ellipses

wunifrac_plot <- plot_ordination(anemia_rare_infected, pcoa_wunifrac, color = "adj_ferritin_status") +
  geom_mark_ellipse(aes(filter = !is.na(adj_ferritin_status), 
                        color = adj_ferritin_status, fill = adj_ferritin_status), 
                    alpha = 0.2) +
  scale_color_discrete(name = "Adjusted Ferritin Status", 
                       labels = c("Deficient levels", "Normal levels")) +
  scale_fill_discrete(name = "Adjusted Ferritin Status", 
                      labels = c("Deficient levels", "Normal levels")) +
  expand_limits(x = c(-0.6, 0.4), y = c(-0.4, 0.4))

print(wunifrac_plot)


