#!/usr/bin/env Rscript
library(tidyverse)
library(phyloseq)
library(DESeq2)
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

#### DESeq ####
anemia_deseq <- phyloseq_to_deseq2(anemia_rare_infected, ~`adj_ferritin_status`)
DESEQ_anemia <- DESeq(anemia_deseq)
res <- results(DESEQ_anemia, tidy=TRUE, 
               #this will ensure that normal is the reference group
               contrast = c("adj_ferritin_status","deficient","normal"))
View(res)

# Look at results 

## Volcano plot: effect size VS significance
ggplot(res) +
  geom_point(aes(x=log2FoldChange, y=-log10(padj)))

## Make variable to color by whether it is significant + large change
vol_plot <- res %>%
  mutate(significant = padj<0.05 & abs(log2FoldChange)>2) %>%
  ggplot() +
  geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant))

vol_plot

# To get table of results
sigASVs <- res %>% 
  filter(padj<0.05 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
View(sigASVs)
# Get only asv names
sigASVs_vec <- sigASVs %>%
  pull(ASV)

# Prune phyloseq file
anemia_DESeq <- prune_taxa(sigASVs_vec,anemia_rare_infected)
sigASVs <- tax_table(anemia_DESeq) %>% as.data.frame() %>%
  rownames_to_column(var="ASV") %>%
  right_join(sigASVs) %>%
  arrange(log2FoldChange) %>%
  mutate(Genus = make.unique(Genus)) %>%
  mutate(Genus = factor(Genus, levels=unique(Genus)))

ggplot(sigASVs) +
  geom_bar(aes(x=Genus, y=log2FoldChange), stat="identity")+
  geom_errorbar(aes(x=Genus, ymin=log2FoldChange-lfcSE, ymax=log2FoldChange+lfcSE)) +
  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5))
