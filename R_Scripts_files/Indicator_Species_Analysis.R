#!/usr/bin/env Rscript
library(tidyverse)
library(phyloseq)
library(indicspecies)

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

#### Indicator Species/Taxa Analysis ####
# glom to Genus
anemia_genus <- tax_glom(anemia_infected, "Genus", NArm = FALSE)
anemia_genus_RA <- transform_sample_counts(anemia_genus, fun=function(x) x/sum(x))

#ISA
isa_anemia <- multipatt(t(otu_table(anemia_genus_RA)), cluster = sample_data(anemia_genus_RA)$`adj_ferritin_status`)
summary(isa_anemia)
taxtable <- tax_table(anemia_infected) %>% as.data.frame() %>% rownames_to_column(var="ASV")

# table is only going to be resolved up to the genus level
isa_anemia$sign %>%
  rownames_to_column(var="ASV") %>%
  left_join(taxtable) %>%
  filter(p.value<0.05) %>% View()

