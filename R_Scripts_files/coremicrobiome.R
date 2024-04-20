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
  facet_wrap(~factor(`adj_ferritin_status`, levels = c("normal", "deficient")), scales = "free_x", ncol = 2) + 
  labs(y = "Relative Abundance", x = "") + # Rename Y-axis and remove X-axis title
  theme_minimal() + # Use a minimal theme
  theme(
    axis.text.x = element_blank(), # Remove X-axis labels
    axis.ticks.x = element_blank(), # Remove X-axis ticks
    strip.text.x = element_text(size = 12, face = "bold"), # Capitalize and bold the facet label text
    axis.title.x = element_blank(), # Remove the x-axis title
    panel.grid.major = element_blank(), # Remove major grid lines
    panel.grid.minor = element_blank(), # Remove minor grid lines
    panel.border = element_rect(colour = "black", fill=NA, size= 0.5) # Add border around each panel
  )

# Manually adjust the case of the facet labels
bar_plot <- bar_plot + scale_x_discrete(labels = function(x) stringr::str_to_title(x))

# Print the plot
print(bar_plot)


### Venn diagram of all the ASVs that showed up in each treatment
norm_list <- core_members(anemia_norm, detection=0.0, prevalence = 0.7)
def_list <- core_members(anemia_def, detection=0.0, prevalence = 0.7)

list_full <- list("Normal     "= norm_list, "Deficient     " = def_list)

# Create a Venn diagram using all the ASVs shared and unique to normal and deficient ferritin status
stat_venn <- ggVennDiagram(x = list_full)
# expand axis to show long set labels
stat_venn_f <-  stat_venn + scale_x_continuous(expand = expansion(mult = .2))

stat_venn_f

####Get the taxa that are unique to the normal group####
# Get the ASVs that are unique to the normal group
unique_norm_ASVs <- setdiff(norm_list, def_list)
# Get the taxonomic names for these unique ASVs
unique_norm_taxa <- tax_table(prune_taxa(unique_norm_ASVs, anemia_infected))

####Get the taxa that are unique to the deficient group####
# Get the ASVs that are unique to the deficient group
unique_def_ASVs <- setdiff(def_list, norm_list)
# Get the taxonomic names for these unique ASVs
unique_def_taxa <- tax_table(prune_taxa(unique_def_ASVs, anemia_infected))

####Get the taxa that are overlapping between the normal and deficient groups####
# Get the ASVs that are in both normal and deficient groups
common_ASVs <- intersect(norm_list, def_list)
# Get the taxonomic names for these overlapping ASVs
common_taxa <- tax_table(prune_taxa(common_ASVs, anemia_infected))

# Convert the tax_table to a data frame for easier manipulation and visualization
unique_norm_df <- as.data.frame(unique_norm_taxa)
unique_def_df <- as.data.frame(unique_def_taxa)
common_taxa_df <- as.data.frame(common_taxa)

# Add a column to indicate the group each taxon belongs to
unique_norm_df$Group <- "Unique High Inflammation"
unique_def_df$Group <- "Unique Low Inflammation"
common_taxa_df$Group <- "Common"

# Combine all the data into one data frame
all_taxa_df <- rbind(unique_def_df, common_taxa_df, unique_norm_df)

all_taxa_df
