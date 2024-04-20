# MICB 475 Team 12: Lab Notebook and Meeting Agenda
This repository contains files related to our project and a lab notebook showing the journey we took in reaching our conclusions. 

## [The All-Star Team](https://t.ly/wiPSh)
<img src="/team-pic.png" alt="The Team Behind the Magic" width="400" height="400">

## Summary
Iron is an essential micronutrient critical for human growth, cell function, and oxygen transport. Despite its importance, iron deficiency remains a global health issue, particularly in developing countries, leading to conditions such as iron deficiency anemia (IDA). IDA affects about 16% of the world population, especially women and young children, and results from insufficient iron intake and storage. Recent research highlights the role of ferritin, a primary iron storage protein, as an indicator of inflammation, which is influenced by gut microbiome dysbiosis. Studies have shown that gut dysbiosis can impact iron absorption and utilization, contributing to anemia. Conversely, beneficial bacteria like Lactobacillus and Bifidobacterium might enhance iron utilization, suggesting the gut microbiome's potential role in mitigating IDA. Our study focuses on the intricate relationships between anemia, systemic inflammation, and the gut microbiome. We aim to use adjusted ferritin levels to measure inflammation, providing a more accurate assessment of iron status and inflammation in patients. This project seeks to understand how inflammation in anemic infants can alter gut microbial composition and trigger cellular stress responses, offering insights into the systemic effects of anemia and identifying potential microbial targets for therapy. 

**Please note** that, **until** the entry on March 01, we were focusing on looking at four metabolic markers (**Adjusted Body Iron Storage (BIS) Status** (`adj_bis_status`), **Adjusted Ferritin Status** (`adj_ferritin_status`), **Adjusted Retinol Binding Protein (RBP) Status** (`adj_rbp_status`), and **C Reactive Protein (CRP) Status** (`crp_status`)) and how they changed in relation to infection status within the dataset. It is only from March 01 that we started focusing on using Ferritin and examining inflammation levels: 


All scripts run for QIIME processing can be found [here](QIIME_files/QIIME_data_processing_script)


# Table of Contents

1. [Project Aims](#Project-Aims)
2. [Agenda](#Agenda)
3. [Lab Notebook](#Lab-Notebook)
   - [P001: Importing and Demultiplexing the Anemia Dataset](#P001-Importing-and-Demultiplexing-the-Anemia-Dataset)
   - [P002: Generating ASVs](#P002-Generating-ASVs)
   - [P003: Taxonomic Analysis](#P003-Taxonomic-Analysis)
   - [P006: Creating a Phyloseq Object](#P006-Creating-a-Phyloseq-Object)
   - [P007: Alpha Diversity Analyses in R](#P007-Alpha-Diversity-Analyses-in-R)


# Project Aims
- Aim 1: Microbiome Data Processing: Use Qiime2 for initial microbiome data processing to set the stage for detailed analysis.
- Aim 2: Diversity Analysis: Use R to carry out alpha/beta diversity analyses to examine the association between selected metabolic markers (Adjusted Body Iron Storage, Adjusted Ferritin Status, Adjusted Retinol Binding Protein Status, and C Reactive Protein Status) and microbial diversity within 12-month old anemic children
- Aim 3: Infection Status Diversity Metrics: Investigate microbiome differences in anemic children by categorizing each sample as either infected or uninfected, informed by prior evidence suggesting minimal variation across infection stages.
- Aim 4: Targeted Analysis: Focus on the relationship between metabolic markers and microbial abundance/diversity specifically in infected anemic children, expanding to differential abundance analysis afterwards.
- Aim 5: Metabolic Pathway Analysis: Use PICRUSt2 for functional analysis to determine metabolic pathways in anemic children with infection that are influenced by microbiome composition
- Aim 6: Development of Predictive Models: Use identified metabolic markers from anemic children, segmented by infection status, to create predictive models for microbial richness/abundance and potential inflammatory species presence.

# Agenda
### April 10 2024 at 2:15 pm
- Feedback on findings we have? Is there anything we should change?
- Link to PowerPoint presented yesterday: [click here](https://docs.google.com/presentation/d/1Q_2NYI6iRwREKwRISHyYghypWVwosHUD0IXKSO5o_mE/edit?usp=sharing) 
- Link to PowerPoint for figure legends: [click here](https://docs.google.com/presentation/d/1pByYQWFRNFOrJn38CuKmhb83aN2tUKvIWd6hFwwidwE/edit?usp=sharing)   
- Our brains are tired

### April 3 2024 at 2:15 pm
- Review edited figures and figure descriptions [click here](https://docs.google.com/presentation/d/1pByYQWFRNFOrJn38CuKmhb83aN2tUKvIWd6hFwwidwE/edit#slide=id.g2c8ec61cf98_0_172)
- Presentation slides in progress [click here](https://docs.google.com/presentation/d/1Q_2NYI6iRwREKwRISHyYghypWVwosHUD0IXKSO5o_mE/edit#slide=id.g2a14c4a5fd3_0_37) 

### March 27 2024 at 2:15 pm
- Review rough figures + figure legends generated so far [click here](https://docs.google.com/presentation/d/1HTzz5hGxkBD0mtDByJz26Lrisve5_Q5a4xSPshElX1I/edit?usp=sharing)

#### To-Do List

- [x] **Figure 1:**
    - [ ] 2 panels, both alpha diversities
    - [x] Kruskal-Wallis test for infection status

- [x] **Figure 2:**
    - [x] Change deficient and normal to deficient levels and normal levels
    - [x] Nonparametric PERMANOVA
    - [x] Beta diversity
    - [x] Insert actual axis line

- [x] **Figure 3:**
    - [x] DSeq - flip the plot

- [x] **Figure 4:**
    - [x] Inflammation vs no inflammation - flip the plot
    - [x] Core microbiome - remove deficient and normal title spacing, expand it width-wise
    - [x] Make relative abundance plot
    - [x] Make it less stringent? (I made it more stringent :) )

- [x] **Figure 5:**
    - [x] PICRUSt, run a p-adjusted and flip it

- [x] **Figure 6:**
    - [x] Flip it so that it's normal vs deficient

- [ ] **General Tasks:**
    - [x] Simplify research question
    - [ ] Define convalescence in the paper
    - [x] Name of figure should reflect the message of the figure - don't include the methodology
    - [ ] Define the use of ferritin 
    - [x] Perform enzyme analysis

### March 20 2024 at 10:15 am
- Go over rough figures generated so far, based on last week's to-do list: [click here](https://docs.google.com/presentation/d/1HTzz5hGxkBD0mtDByJz26Lrisve5_Q5a4xSPshElX1I/edit?usp=sharing)
  
### March 13 2024 at 10:00 am 
- Picrust analysis was done - go over results
- Alpha diversity box plot for adj_ferritin_status (which had significance) was cleaned up for paper
- alpha diversity + anova was conducted on infection status --> resulting box plots were also cleaned up for paper
#### To Do for Next Week:
Figures to do:
1. infected (with 3 stages) do alpha diversity and beta diversity within the 3 stages in anemic patients
2. alpha and beta diversity in just infected anemic patients comparing adj_ferritin_status --> see if there is difference b/w high vs low inflammation
3. do differential abundance 
4. do core microbiome analysis
5. picrust pathway analysis
6. may add in enzymes


### March 06 2024 at 10:00 am 
#### Introduction
- Recap of progress:
  - Conversion of anemia data into a phyloseq object in R.
  - Filtering out missing/NA samples and generating a rarefaction curve.
  - Filtering samples to include only anemic samples, specifically those who are 12 months old.

#### Objective
- Proposal to examine the relationship between metabolic markers and infection status in anemic children.
- Focus on 12-month-old anemic children.
- Investigating whether infected anemic children with markers signaling worse metabolism exhibit higher richness/abundance of inflammatory microbial species compared to those with better metabolism.
- Exploring similar patterns among uninfected anemic children.

#### Proposed Methodology
- Analyzing each metabolic marker individually within anemic children to determine significant differences in alpha/beta diversity.
- Metabolic markers include Adjusted Body Iron Storage (BIS) Status, Adjusted Ferritin Status, Adjusted Retinol Binding Protein (RBP) Status, and C Reactive Protein (CRP) Status.
- Conducting diversity metrics on infection status among anemic children, possibly bypassing this step due to previous findings.
- Grouping all infection statuses together as infected or uninfected.
- Assessing variations in microbial species abundance/diversity across different markers among infected and uninfected anemic children.

#### Data Analysis
- Considering the use of t-tests to evaluate significance for alpha diversity plots.
- Alpha diversity analysis conducted on anemic 12-month-old patients found significance with Shannon diversity for adjusted ferritin status.
- Discussion on parametric vs. non-parametric tests, considering normal distribution.
- Considering non-parametric tests for later analysis.
- Uncertainty regarding performing a t-test on the phylogenetic Faith PD data.

### February 27 2024 at 2:15 pm PST
- Provide update of work done so far --> AIM 1/2: Diversity analysis complete
- Go over relevant questons related to Aim 2 (interpreting p-values)
- Next steps: Work towards AIM 3: Differential Abundance Analysis

### February 14 2024 at 2:15 pm PST
- Provide update of work done so far --> AIM 1: Microbiome Data Processing complete
- Go over relevant questons related to Aim 1 (e.g. training classifiers)
- Clarify research question for project and workflow/aims 
- Next steps: Work towards AIM 2: Diversity Analysis


# Lab Notebook

## P001: Importing and Demultiplexing the Anemia Dataset
**Date:** Feb 9th, 2024

### Purpose

To import and demultiplex the 16S rRNA sequences from the [Anemia Dataset](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6290362/) using QIIME2.

### Procedure

- Created a dedicated directory for all related analyses related to the dataset: `/data/anemia`.
- Used manifest file (`/mnt/datasets/project_2/anemia/anemia_manifest_updated.txt`) to import and demultiplex dataset.
- Generated a visualization file `demux.qzv`, moved to local computer, and viewed using [QIIME2 View](https://view.qiime2.org/).

### Output Files

- Demultiplexed `.qza` file: `demux_seqs.qza`
  - Path in server: `/data/anemia/demux_seqs.qza`
- Demultiplexed `.qzv` file: `demux.qzv`
  - Path in server: `/data/anemia/demux.qzv`
  - Qzv file also stored in [repository](QIIME_files/demux.qzv)

### Results

- Total number of reads: 6,017,157
- Total number of samples: 193
- Range of sequencing depth: 67-74,453
- Maximum read length (bp): 253
- The minimum sequence length identified during subsampling was 210 bases.

### Sequence Length Statistics
![Sequence Length Distribution](QIIME_files/QIIME_view_images/Demultiplexed_sequence_length_summary.png)

## P002: Generating ASVs 
**Date**: February 11, 2024

### Purpose
To denoise the demux file and group the sequences into amplicon sequence variants (ASVs).

### Procedure
Used the quality score graph visualized using the `demux.qzv` file (generated in P001) to determine an appropriate truncation length for denoising + ASV clustering:
![Quality Score Graph](QIIME_files/sequence_quality_score.png)

#### ASV Generation (Attempt 1)
We first set the truncation length to 303 nucleotides, as the reads at this length appeared to have a high quality score. However, this resulted in only 10 ASVs and 12 samples. ![image of frequency/feature detail](QIIME_files/QIIME_view_images/trunc_Length-303_Frequency_per_feature_detail.png)

#### ASV Generation (Attempt 2)
As a result, we reattempted the denoising using a truncation length of 253 nucleotides since this was the length of ~98% of reads.

**Result**: Successfully generated 1434 ASVs and 193 samples.
![image of ASV Stats](QIIME_files/QIIME_view_images/trunc_Length-253_ASV_stats.png)
![image of frequency/feature detail](QIIME_files/QIIME_view_images/trunc_Length-253_Frequency_per_feature_detail.png)

### Storage 
#### ASV Generation (Attempt 1: Truncation Length of 303 nt)
- On server, located in `/data/anemia/trunc-len_303`.
- On the repository, the `rep-seqs.qzv` and `table.qzv` files are located in: `QIIME_files/Trunc-length_303`

#### ASV Generation (Attempt 2: Truncation Length of 253 nt)
- On the server, the following files were generated: `rep-seqs.qza`, `rep-seqs.qzv`, `stats.qza`, `stats.qzv`, `table.qza`, `table.qzv` - all stored in `/data/anemia/`.
- On the repository, the `rep-seqs.qzv` and `table.qzv` files are located in: `QIIME_files/Trunc-length_253`

## P003: Taxonomic Analysis
**Date:** Feb 15th, 2024

### Purpose:
To train a classifier to do taxonomic analysis and generate a taxa bar graph

### Procedure:

#### Training our classifier 
1. Extract our amplicon of interest from the reference database `silva-138-99-515-806-nb-classifier.qza` with our desired truncation length of 253.
2. Input sequences from `rep-seqs.qza` generated from P002.
3. Output a trimmed file `ref-seqs-trimmed.qza` which can be found on server `/data/anemia/`.
4. Train classifier with this new `ref-seq-trimmed` file.
5. Input `ref-seqs-trimmed.qza` and compare it to the reference database `silva-138-99-515-806-nb-classifier.qza`.
6. Output trained classifier `classifier.qza` which can be found on server `/data/anemia/`.
7. Use this trained classifier to assign taxonomy to our reads (`rep-seqs.qza`).
8. Input `classifier.qza` along with our reads `rep-seqs.qza`.
9. Output our taxonomy file `taxonomy.qza`.

#### Taxonomic Analysis
1. Convert `taxonomy.qza` to `taxonomy.qzv` for visualization on QIIME2 View.
2. Generate taxonomy bar plot by inputting `table.qza`, `taxonomy.qza`, and `anemia_metadata.txt` files.
3. Visualize the output file `taxa-bar-plots-truncated.qzv` using QIIME2 View which can be found on our server.
   - Server path: `/data/anemia/taxonomy_truncated/taxa-bar-plots-truncated.qzv`
   
*taxa-bar-plots-truncated.qzv - Taxonomy Level 3*
![image of taxonomy bar plot](QIIME_files/QIIME_view_images/taxabarplot.png)

## P003: Generating an Alpha Rarefaction Curve
**Date:** Feb 17th, 2024

### Purpose: 
To filter out mitochondria and chloroplast features and generate an alpha rarefaction curve

### Procedure:

1. Filter out mitochondria and chloroplast from our `table.qza` (from P002) to generate a filtered `table-no-mitochondria-no-chloroplast.qza` table.
2. Convert this file to `table-no-mitochondria-no-chloroplast.qzv` for visualization on QIIME2 view.
3. Generate a tree for phylogenetic diversity analyses using the `rep-seqs.qza` (from P002). Output files `aligned-rep-seqs.qza`, `masked-aligned-rep-seqs.qza`, `unrooted-tree.qza`, and `rooted-tree.qza` can be found on server `/data/anemia/`.
4. Rarefy data to a depth of 50,000 using `table.qza`, the `rooted-tree.qza` that was generated, and `anemia_metadata.txt` metadata file.
   - This depth was chosen because this value lies close to the max frequency per sample (58,297) observed in the table summary (from P002). This will allow us to clearly identify where the curve plateaus.
5. The generated alpha rarefaction curve file `alpha-rarefaction.qzv` can be found in our server: `/data/anemia`.

*alpha_rarefaction.qzv*
![image of alpha_rarefaction_curve](QIIME_files/QIIME_view_images/alpha_rarefaction_curve.png)

## P006: Creating a Phyloseq Object
**Date:** Feb 28th, 2024

### Purpose: 
To create a Phyloseq object from our dataset to carry out alpha/beta diversity analysis in R and for future downstream analysis (such as differential abundance).

### Procedure:

**Loaded Data:**
1. Metadata, OTU table, taxonomy, and phylogenetic tree data were read from their respective files.

**Formatting Loaded Data:**
1. The OTU table was transformed into a matrix format: OTU IDs were set as row names and were converted into phyloseq class using the `otu_table` function.
2. Sample Metadata was converted into a data frame. Sample IDs were set as row names and the data was converted into phyloseq class using the `sample_data` function.
3. Taxonomic strings in the taxonomy file were parsed to separate taxonomic ranks into individual columns, and converted into a matrix format, and feature IDs (OTU IDs) were set as row names.
4. A taxonomy class object suitable for use in phyloseq was created using the `tax_table` function.

**Created Phyloseq Object:**
1. The formatted OTU table, sample metadata, taxonomy table, and phylogenetic tree were combined into a single phyloseq object using the `phyloseq` function.
2. This phyloseq object contains all the necessary data for downstream analysis.

**Analyzed Data:**
1. Mitochondrial and chloroplast sequences were filtered out from the dataset.
2. OTUs with low total counts across all samples (less than 5 counts) were removed.
3. Samples with less than 100 reads were excluded.
4. Samples where data was missing or NA in metadata fields were filtered out.
5. The dataset was subsetted to include **only samples from individuals with anemia**.
6. Further subsetted the dataset to include only samples from 12-month-old infants.
7. Rarefied the 12-month samples to a uniform depth of 10,000 reads per sample, based on previous qzv analysis (P002).

**Saved Results:**
- All R files are stored under `Phyloseq_Files`.
- The **R Script** is here: `Phyloseq_Files/phyloseq_object.R`
- The filtered and processed data were saved as RData files for future use.
- The 12-month-old anemic data before rarefication are stored under: `Phyloseq_Files/12M_anemia_final.RData`.
- The rarefied RData is stored under: `Phyloseq_Files/anemia_rare.RData`.
  
## P007: Alpha Diversity Analyses in R
**Date:** Feb 28th, 2024
### Purpose: 
To conduct richness and diversity analyses on the various indicators for metabolism using the anemia_rare.RData file from P006.

### Load in RData
- Loaded previously saved RData files containing processed data:
  - "12M_anemia_final.RData", containing filtered and processed data specific to 12-month-old infants **with anemia**.
  - "anemia_rare.RData", containing the rarefied "12M_anemia_final.RData" for analysis
                 - this is the file we'll be focusing on

### Alpha Diversity Analysis
1. **Performed Alpha Diversity Analysis:**
  - Calculated and visualized alpha diversity metrics using the 12M_anemia_final.RData.
  - Visualized richness of microbial communities using a richness plot generated with the `plot_richness()` function.
  - Generated richness plot with additional alpha diversity metrics, including Shannon diversity and Chao1 estimator.
  - Customized a richness plot to include the adjusted body iron storage as a factor, using the `adj_bis_status` variable.
  - Saved the customized richness plot as an image file named "plot_richness.png" in: `R_Scripts_files/Alpha_Diversity_Plots/adj_bis_status/plot_richness.png`.
    
![image of plot_richness](R_Scripts_files/Alpha_Diversity_Plots/adj_bis_status/plot_richness.png)
 - **Estimated Richness:**
  - Estimated the richness of microbial communities using the rarefied data.
  - This estimation provides insights into the total number of different microbial taxa present in the samples.

### Phylogenetic Diversity Analysis
2. **Calculated Phylogenetic Diversity:**
  - Computed Faith's phylogenetic diversity (PD) using the rarefied data and the associated phylogenetic tree.
  - Calculated phylogenetic distances among samples using the `pd()` function.
  - Added PD values to the sample metadata table under the column named "PD".
- **Plotted Phylogenetic Diversity Against Metadata:**
  - Plotted phylogenetic diversity (PD) against the adjusted body iron storage status to explore its relationship.
  - Generated a boxplot to visualize the distribution of PD across different levels of adjusted body iron storage.
  - Customized the plot with appropriate axis labels.
  - Saved the customized plot of phylogenetic diversity against adjusted body iron storage as an image file named "phylogeny_plot(Faith's).png" in : `R_Scripts_files/Alpha_Diversity_Plots/adj_bis_status/phylogeny_plot(Faith's).png`.
    ![image of phylogeny_plot](R_Scripts_files/Alpha_Diversity_Plots/adj_bis_status/phylogeny_plot(Faith's).png)
3. Repeated the same process (steps 1 and 2) for `adj_bis_status`, `adj_ferritin_status`, `adj_rbp_status`, `infection_status` , and `crp_status` --> plots can be found in: `R_Scripts_files/Alpha_Diversity_Plots`

**R-Script for diversity is here**: `R_Scripts_files/alpha_diversity_Rscript.r`
**R-Script for Infection Status is here**: `R_Scripts_files/infected_stage_anemia_comparison_alpha_diversity.R`
### Results:
- No significant difference in alpha diversity found within any of the metabolic indicators and in infection status **EXCEPT** for `adj_ferritin_status` (p value = 0.03724) - found [here](R_Scripts_files/Alpha_Diversity_Plots/adj_ferritin_status/adj_ferritin_status_t_test_richness.png)
  ![image of Ferritin Status Alpha Diversity Plot ](R_Scripts_files/Alpha_Diversity_Plots/adj_ferritin_status/Shannon_Diversity.png)
- No significant difference between different stages of infection:
  ![infection_plot](R_Scripts_files/Alpha_Diversity_Plots/Infection_status/Infection_Status_Kruskal-Wallis.png)

### Moving forward:
- Due to the lack of alpha diversity between each infection status (Incubation, early convalescence, and late convalescence), we can group all infection stages into one “Infected” category for the beta diversity analysis.
- Since adj_ferritin status had a significant difference, perhaps we can focus on it instead, and now, instead of looking at metabolic markers, we can look at inflammation with ferritin as a marker of this. To do this, ferritin levels (adj_ferritin_status) can be reclassified, with normal levels classified as high inflammation and deficient levels classified as low inflammation. 

## P008: Alpha and Beta Diversity Analyses for Infected Students
**Date: March 1st**
### Purpose: 
To group anemic samples into those who are only infected and redo Shannon alpha diversity analysis (and conduct beta diversity analysis) on adjusted ferritin status. 

### Procedure
- Script for parts A-C found [here](R_Scripts_files/infected_anemia_rare_alpha_diversity.R)

**A. Loading and Preparing Data**
1. **Load Data**: Begin by loading the dataset from "anemia_rare.RData".
2. **Modify Sample Data**:
   - Access the sample data from the phyloseq object.
   - Create a new column `infection_status_updated` to classify participants as "Infected" or "Normal" based on their existing infection status.
   - Update the phyloseq object with the new sample data.
   - Filter the dataset to include only samples classified as "Infected".

**B. Phylogenetic Diversity Analysis**
1. **Calculate Faith's Phylogenetic Diversity**:
   - Compute Faith's PD and add it to the metadata table for further analysis.

**C. Statistical Analysis of Alpha Diversity**
1. **Extract Data for Analysis**:
   - Estimate richness using Shannon and Chao1 indices and combine this with sample data.
2. **Visualize Alpha Diversity**:
   - Generate box plots to visualize alpha diversity measures (Shannon and Chao1) by adjusted ferritin status.
   - Perform Wilcoxon Rank Sum tests to compare alpha diversity indices between groups with different ferritin statuses.
3. **Enhanced Plotting**:
   - Enhance the alpha diversity plots by adding significance labels, adjusting axis properties, and incorporating error bars for visual clarity.

**D. Beta Diversity Analysis** (script found [here](R_Scripts_files/beta_diversity/beta_diversity.R))
1. **Compute Distance Matrices**:
   - Calculate Bray-Curtis and Weighted Unifrac distance matrices.
2. **Principal Coordinates Analysis (PCoA)**:
   - Perform PCoA for both Bray-Curtis and Weighted Unifrac distances.
3. **Visualization**:
   - Plot the ordination results to visualize the beta diversity, and coloring points by adjusted ferritin status to examine patterns.
   - Utilize titles and labels to delineate different analyses and results.
4. **Statistical Testing**:
   - Conduct Wilcoxon tests on the distance matrices to assess differences in microbial community composition related to ferritin status.

**Results:**

- Alpha Diversity
  Surprisingly, adjusted ferritin status showed no significant difference in Alpha diversity in only Infected Patients.
  ![image of Shannon Diversity Adj Ferritin_Infected](R_Scripts_files/Alpha_Diversity_Plots/adj_ferritin_status/Infected_Anemic_Shannon_Ferritin_plot.png) 
  
- Beta Diversity - all plots can be found [here](R_Scripts_files/Beta_Diversity_Plots):
  Weighted Unifrac analysis and a resulting PCoA plot demonstrated that there was no significant difference between low and high inflammation anemic infants (no significance detected)
  - Weighted Unifrac PCoA Plot:
![image of PcOA Plot](R_Scripts_files/Beta_Diversity_Plots/Weighted_Unifrac_PCoA.png)

With special collaboration from Hochschule Osnabrück

**Discussion**
- The absence of a significant difference, which contradicts results from P007, that demonstrated an association between inflammation and alterations in the gut microbiota, is intriguing. This discrepancy could be due to the gut microbiome's functional redundancy, where various microbes might perform similar functions to preserve stability amid pathophysiological changes. Another factor could be the lack of detailed information on the type of infection affecting anemic infants, as this is not clearly specified in the metadata, limiting the conclusions that can be drawn from the non-significant results. Moreover, the small number of anemic infants in the incubation stage of infection (n = 2) restricts the generalizability and representativeness of the findings.
