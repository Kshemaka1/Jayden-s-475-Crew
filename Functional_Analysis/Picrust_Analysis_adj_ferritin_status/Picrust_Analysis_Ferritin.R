
#### Load packages ####
# Load all necessary libraries
library(readr)
library(ggpicrust2)
library(tibble)
library(tidyverse)
library(ggprism)
library(patchwork)
library(DESeq2)
library(ggh4x)

#Import your metadata file, no need to filter yet
metadata <- read_delim("anemia_metadata.txt")
metadata <- subset(metadata, anemia == "anemic")
metadata$infection_status_updated <- ifelse(metadata$infection_status %in% c("Early Convalescence", "Late Convalescence", "Incubation"), "Infected", ifelse(metadata$infection_status == "Reference", "Normal", NA))
metadata <- subset(metadata, infection_status_updated == "Infected")

#### Import files and preparing tables ####
#Importing the pathway PICrsut2
abundance_file <- "pathway_abundance.tsv"
abundance_data <- read_delim(abundance_file, delim = "\t", col_names = TRUE, trim_ws = TRUE)
abundance_data  =as.data.frame(abundance_data)

#Example Looking at subject number
#If you have multiple variants, filter your metadata to include only 2 at a time

#Remove NAs for your column of interest in this case subject
metadata = metadata[!is.na(metadata$adj_ferritin_status),]

#Filtering the abundance table to only include samples that are in the filtered metadata

first_column_name <- colnames(abundance_data)[1]
sample_names <- metadata$'#SampleID'
sample_names <- c(first_column_name, sample_names)
abundance_data_filtered <- abundance_data[, colnames(abundance_data) %in% sample_names]


#Removing individuals with no data that caused a problem for pathways_daa()
abundance_data_filtered =  abundance_data_filtered[, colSums(abundance_data_filtered != 0) > 0]

#Ensuring the rownames for the abundance_data_filtered is empty. This is required for their functions to run.
rownames(abundance_data_filtered) = NULL

#verify samples in metadata match samples in abundance_data
abun_samples = rownames(t(abundance_data_filtered[,-1])) #Getting a list of the sample names in the newly filtered abundance data
metadata = metadata[metadata$`#SampleID` %in% abun_samples,] #making sure the filtered metadata only includes these samples

#### DESEq ####

#Set 'Normal group as the reference

metadata$adj_ferritin_status <- factor(metadata$adj_ferritin_status)
metadata$adj_ferritin_status <- relevel(metadata$adj_ferritin_status, ref = "normal")
levels(metadata$adj_ferritin_status)

#Perform pathway DAA using DESEQ2 method
abundance_daa_results_df <- pathway_daa(abundance = abundance_data_filtered %>% column_to_rownames("#OTU ID"), 
                                        metadata = metadata, group = "adj_ferritin_status", daa_method = "DESeq2")

# Annotate MetaCyc pathway so they are more descriptive
metacyc_daa_annotated_results_df <- pathway_annotation(pathway = "MetaCyc", 
                                                       daa_results_df = abundance_daa_results_df, ko_to_kegg = FALSE)

# Filter p-values to only significant ones
feature_with_p_0.05 <- abundance_daa_results_df %>% filter(p_values < 0.05)

#Changing the pathway column to description for the results 
feature_desc = inner_join(feature_with_p_0.05,metacyc_daa_annotated_results_df, by = "feature")
feature_desc$feature = feature_desc$description
feature_desc = feature_desc[,c(1:7)]
colnames(feature_desc) = colnames(feature_with_p_0.05)

#Changing the pathway column to description for the abundance table
colnames(abundance_data_filtered)[1] = "pathway"
abundance = abundance_data_filtered %>% filter(pathway %in% feature_with_p_0.05$feature)
colnames(abundance)[1] = "feature"
abundance_desc = inner_join(abundance,metacyc_daa_annotated_results_df, by = "feature")
abundance_desc$feature = abundance_desc$description
#this line will change for each dataset. 41 represents the number of samples in the filtered abundance table
abundance_desc = abundance_desc[,-c(41:ncol(abundance_desc))] 

# Generate a heatmap
pathway_heatmap(abundance = abundance_desc %>% column_to_rownames("feature"), metadata = metadata, group = "adj_ferritin_status")

# Generate pathway PCA plot
pathway_pca(abundance = abundance_data_filtered %>% column_to_rownames("pathway"), metadata = metadata, group = "adj_ferritin_status")

# Generating a bar plot representing log2FC from the custom deseq2 function

# Go to the Deseq2 function script and update the metadata category of interest

# Lead the function in
source("DESeq2_function (1).R")

# Run the function on your own data
res =  DEseq2_function(abundance_data_filtered, metadata, "adj_ferritin_status")
res$feature =rownames(res)
res_desc = inner_join(res,metacyc_daa_annotated_results_df, by = "feature")
res_desc = res_desc[, -c(8:13)]
View(res_desc)

# Filter to only include significant pathways
sig_res = res_desc %>%
  filter(pvalue < 0.05)
# You can also filter by Log2fold change

sig_res <- sig_res[order(sig_res$log2FoldChange),]
ggplot(data = sig_res, aes(y = reorder(description, sort(as.numeric(log2FoldChange))), x= log2FoldChange, fill = pvalue))+
  geom_bar(stat = "identity")+ 
  theme_bw()+
  labs(x = "Log2FoldChange", y="Pathways")



