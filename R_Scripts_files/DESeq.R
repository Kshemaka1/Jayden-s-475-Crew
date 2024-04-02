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

#### DESeq ####
anemia_deseq <- phyloseq_to_deseq2(anemia_infected, ~`adj_ferritin_status`)
DESEQ_anemia <- DESeq(anemia_deseq)
res <- results(DESEQ_anemia, tidy=TRUE, 
               #this will ensure that deficient is the reference group
               contrast = c("adj_ferritin_status","normal","deficient"))
View(res)

# Look at results 

## Volcano plot: effect size VS significance
ggplot(res) +
  geom_point(aes(x=log2FoldChange, y=-log10(padj)))

## Make variable to color by whether it is significant + large change
# Modify the res variable to exclude NA values for plotting
res_non_na <- res %>% filter(!is.na(padj))

# Recreate the volcano plot with detailed axis titles and informative legend
volcano_plot <- res_non_na %>%
  mutate(significant = padj < 0.01 & abs(log2FoldChange) > 2) %>%
  ggplot(aes(x = log2FoldChange, y = -log10(padj), color = significant)) +
  geom_point() +
  scale_color_manual(values = c("FALSE" = "red", "TRUE" = "blue"),
                     labels = c("Not Significant", "Significant (Adj P < 0.01 & |Fold Change| > 2)")) +
  labs(x = "log2 Fold Change (Normal vs Deficient)",
       y = "-Log10 Adjusted P (Significance)",
       color = "Gene Significance",
      ) +
  theme_minimal() +
  theme(axis.title.x = element_text(margin = margin(t = 10)), # Adjust top margin of x-axis title
        axis.title.y = element_text(margin = margin(r = 10))) # Adjust right margin of y-axis title

print(volcano_plot)

# To get table of results
sigASVs <- res_non_na %>% 
  filter(padj<0.01 & abs(log2FoldChange)>2) %>%
  dplyr::rename(ASV=row)
View(sigASVs)
# Get only asv names
sigASVs_vec <- sigASVs %>%
  pull(ASV)

# Prune phyloseq file
anemia_DESeq <- prune_taxa(sigASVs_vec,anemia_infected)
sigASVs <- tax_table(anemia_DESeq) %>% as.data.frame() %>%
  rownames_to_column(var="ASV") %>%
  right_join(sigASVs) %>%
  arrange(log2FoldChange) %>%
  mutate(Genus = make.unique(Genus)) %>%
  mutate(Genus = factor(Genus, levels=unique(Genus)))

# Filter out the genus labeled as "NA"
sigASVs_filtered <- sigASVs %>%
  filter(!is.na(Genus) & Genus != "NA")  # This removes rows where Genus is NA or "NA"


bar_plot <- ggplot(sigASVs_filtered) +
  geom_bar(aes(x = Genus, y = log2FoldChange, fill = ifelse(log2FoldChange < 0, "Downregulated", "Upregulated")), stat = "identity") +
  geom_errorbar(aes(x = Genus, ymin = log2FoldChange - lfcSE, ymax = log2FoldChange + lfcSE)) +
  labs(
    x = "Genus", 
    y = "Log2 Fold Change", 
    fill = "Expression Change"
  ) +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 8),
    axis.title.x = element_text(size = 10),
    axis.title.y = element_text(size = 10),
    plot.title = element_text(size = 14, hjust = 0.5),
    legend.position = "right",
    legend.text = element_text(size = 8),
    panel.grid.major = element_blank(), # Remove major grid lines
    panel.grid.minor = element_blank(),  # Remove minor grid lines
  ) +
  scale_fill_manual(values = c("Downregulated" = "red", "Upregulated" = "blue"))

bar_plot
