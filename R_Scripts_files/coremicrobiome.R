#!/usr/bin/env Rscript
library(tidyverse)
library(phyloseq)
library(microbiome)
library(ggVennDiagram)

#### Load data ####
load("12M_anemia_final.RData")
# Add new column to Phyloseq Object with an infection category which classifies participants as either infected or normal
# Access the sample data from phyloseq object
anemia_data <- sample_data(TwelveM_anemia)

# Apply the condition to modify/create a new column, named 'infection_category'
anemia_data$infection_status_updated <- ifelse(anemia_data$infection_status %in% c("Early Convalescence", "Late Convalescence", "Incubation"),
                                               "Infected",
                                               ifelse(anemia_data$infection_status == "Reference",
                                                      "Normal", NA))

# Update the sample data in your phyloseq object
sample_data(TwelveM_anemia) <- anemia_data

# Now, filter the phyloseq object to include only samples where infection_status_updated is "Infected"
anemia_infected <- subset_samples(TwelveM_anemia, infection_status_updated == "Infected")


#### "core" microbiome ####

# Convert to relative abundance
anemia_RA <- transform_sample_counts(anemia_infected, fun=function(x) x/sum(x))

# Filter dataset by adj ferritin status
anemia_norm <- subset_samples(anemia_RA, `adj_ferritin_status`=="normal")
anemia_def <- subset_samples(anemia_RA, `adj_ferritin_status`=="deficient")

# Set a prevalence threshold and abundance threshold. 
# Using a detection threshold of zero (presence/absence) and a prevalence threshold of 0.7 (70% of samples should contain each ASV)
norm_ASVs <- core_members(anemia_norm, detection=0, prevalence = 0.7)
def_ASVs <- core_members(anemia_def, detection=0, prevalence = 0.7)

# ASVs
prune_taxa(norm_ASVs,anemia_infected) %>%
tax_table()

tax_table(prune_taxa(def_ASVs,anemia_infected))

# ASVs' relative abundance
bar_plot <- prune_taxa(def_ASVs,anemia_RA) %>% 
  plot_bar(fill="Genus") + 
  facet_wrap(.~`adj_ferritin_status`, scales ="free")

### Venn diagram of all the ASVs that showed up in each treatment
norm_list <- core_members(anemia_norm, detection=0, prevalence = 0.7)
def_list <- core_members(anemia_def, detection=0, prevalence = 0.7)

list_full <- list(Normal = norm_list, Deficient = def_list)

# Create a Venn diagram using all the ASVs shared and unique to normal and deficient ferritin status
stat_venn <- ggVennDiagram(x = list_full)
# expand axis to show long set labels
stat_venn_f <-  stat_venn + scale_x_continuous(expand = expansion(mult = .2))
