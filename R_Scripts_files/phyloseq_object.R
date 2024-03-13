#!/usr/bin/env Rscript
library(phyloseq)
library(ape) # importing trees
library(tidyverse)
library(vegan)

#### Load data ####
# Change file paths as necessary
metafp <- "anemia_metadata.txt"
meta <- read_delim(metafp, delim="\t")

otufp <- "feature-table.txt"
otu <- read_delim(file = otufp, delim="\t", skip=1)

taxfp <- "taxonomy.tsv"
tax <- read_delim(taxfp, delim="\t")

phylotreefp <- "tree.nwk"
phylotree <- read.tree(phylotreefp)
class(phylotree)

#### Format OTU table ####
# OTU tables should be a matrix
# with rownames and colnames as OTUs and sampleIDs, respectively

# save everything except first column (OTU ID) into a matrix
otu_mat <- as.matrix(otu[,-1])
# Make first column (#OTU ID) the rownames of the new matrix
rownames(otu_mat) <- otu$`#OTU ID`
# Use the "otu_table" function to make an OTU table
OTU <- otu_table(otu_mat, taxa_are_rows = TRUE) 
class(OTU)

#### Format sample metadata ####
# Save everything except sampleid as new data frame
samp_df <- as.data.frame(meta[,-1])
# Make sampleids the rownames
rownames(samp_df)<- meta$'#SampleID'
# Make phyloseq sample data with sample_data() function
SAMP <- sample_data(samp_df)
class(SAMP)

#### Formatting taxonomy ####
# Convert taxon strings to a table with separate taxa rank columns
tax_mat <- tax %>% select(-Confidence)%>%
  separate(col=Taxon, sep="; "
           , into = c("Domain","Phylum","Class","Order","Family","Genus","Species")) %>%
  as.matrix() # Saving as a matrix
# Save everything except feature IDs 
tax_mat <- tax_mat[,-1]
# Make sampleids the rownames
rownames(tax_mat) <- tax$`Feature ID`
# Make taxa table
TAX <- tax_table(tax_mat)
class(TAX)


#### Create phyloseq object ####
# Merge all into a phyloseq object
anemia <- phyloseq(OTU, SAMP, TAX, phylotree)

######### ANALYZE ##########
# Remove mitochondrial and chloroplast sequences, if any
anemia_filt <- subset_taxa(anemia,  Class!="c__Chloroplast" & Family !="f__Mitochondria")
# Remove ASVs that have less than 5 counts total
anemia_filt_nolow <- filter_taxa(anemia_filt, function(x) sum(x)>5, prune = TRUE)
# Remove samples with less than 100 reads
anemia_filt_nolow_samps <- prune_samples(sample_sums(anemia_filt_nolow)>100, anemia_filt_nolow)
# Remove samples where data is missing or NA
# Get the sample names
sample_names <- sample_names(anemia_filt_nolow_samps)
# Check if any of the metadata fields contain the specified values: "Missing: Not collected" or "Not applicable"
indices_to_keep <- !apply(sample_data(anemia_filt_nolow_samps), 1, function(row) {
  any(grepl("Missing: Not collected|Not applicable", row))
})
# Filter samples based on the indices to keep
anemia_filt_nolow_samps_NA_filtered <- prune_samples(indices_to_keep, anemia_filt_nolow_samps)
#Filter samples for only individuals with anemia
anemia_filt_nolow_samps_anemic_NA_filtered <- subset_samples(anemia_filt_nolow_samps_NA_filtered, anemia == "anemic")
#Create new column with Infected and Normal status only; Defined Early Convalescence, Late Convalescence, and Incubation into Infected status and Reference into Normal status
sample_data_df <- data.frame(sample_data(anemia_filt_nolow_samps_anemic_NA_filtered))
sample_data_df$infection_status_updated <- ifelse(sample_data_df$infection_status == "Reference", "Normal", "Infected")
sample_data(anemia_filt_nolow_samps_anemic_NA_filtered) <- sample_data_df
anemia_filt_infection_updated <- anemia_filt_nolow_samps_anemic_NA_filtered
#Filter samples for only 12-month-old infants
TwelveM_anemia <- subset_samples(anemia_filt_infection_updated, age_months == 12)
#Filter samples for only 6-month-old infants
SixM_anemia <- subset_samples(anemia_filt_infection_updated, age_months == 6)

#Proceeding with only 12-month samples, rarefy samples
rarecurve(t(as.data.frame(otu_table(TwelveM_anemia))), cex=0.1)
anemia_rare <- rarefy_even_depth(TwelveM_anemia, rngseed = 1, sample.size = 10000)

##### Saving #####
save(TwelveM_anemia, file="12M_anemia_final.RData")
save(anemia_rare, file="anemia_rare.RData")

