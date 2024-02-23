# MICB 475 Team 12: Lab Notebook and Meeting Agenda
This repository stores all the scripts and documentation related to our team's project!

## The All-Star Team
<img src="/team-pic.png" alt="The Team Behind the Magic" width="400" height="400">

## Summary
This project explores the complex effects of anemia on systemic metabolism and microbial functions, using four main metabolic indicators: Body Iron Storage, Ferritin, Retinol Binding Protein (RBP), and C Reactive Protein (CRP). These indicators provide insights into iron metabolism, vitamin A transport, protein synthesis, and metabolic syndrome.


# Table of Contents

1. [Project Aims](#Project-Aims)
2. [Agenda](#Agenda)
3. [Lab Notebook](#Lab-Notebook)



# Project Aims
- Aim 1: Microbiome Data Processing: Use Qiime2 for initial microbiome data processing to set the stage for detailed analysis.
- Aim 2: Diversity Analysis: Examine microbial diversity using Qiime or R to identify significant differences related to anemia.
- Aim 3: Targeted Analysis: Focus on interesting findings from the diversity analysis for deeper investigation, potentially expanding to differential abundance analysis.
- Aim 4: Metabolic Pathway Analysis: Use PICRUSt2 for functional analysis to identify metabolic pathways affected by anemia, using server-based and R analyses.
- Aim 5: Development of Predictive Models: Use identified metabolic markers to develop models predicting anemia

# Agenda

### February 14 2024 at 2:15 pm PST
- Provide update of work done so far --> AIM 1: Microbiome Data Processing complete
- Go over relevant questons related to Aim 1 (e.g. training classifiers)
- Clarify research question for project and workflow/aims 
- Next steps: Work towards AIM 2: Diversity Analysis


# Lab Notebook

## Importing and Demultiplexing the Anemia Dataset
**Date:** Feb 9th, 2023

### Purpose

To import and demultiplex the 16S rRNA sequences from the Anemia Dataset using QIIME2.

### Procedure

- Created a dedicated directory for all related analyses related to the dataset: `/data/anemia`.
- Used manifest file (`/mnt/datasets/project_2/anemia/anemia_manifest_updated.txt`) to import and demultiplex dataset.
- Generated a visualization file `demux.qzv`, moved to local computer, and viewed using [QIIME2 View](https://view.qiime2.org/).

### Output Files

- Demultiplexed `.qza` file: `demux_seqs.qza`
  - Path in server: `/data/anemia/demux_seqs.qza`
- Demultiplexed `.qzv` file: `demux.qzv`
  - Path in server: `/data/anemia/demux.qzv`
  - Qzv file also stored in repository.

### Results

- Total number of reads: 6,017,157
- Total number of samples: 193
- Range of sequencing depth: 67-74,453
- Maximum read length (bp): 253
- The minimum sequence length identified during subsampling was 210 bases.

### Sequence Length Statistics
![Sequence Length Distribution](QIIME_files/QIIME_view_images/Demultiplexed_sequence_length_summary.png)

## ASV Generation (Attempt 1)

- **Parameters**: Truncation length set to 303 nucleotides.
- **Result**: Yielded 10 ASVs and 12 samples.
- **Action**: Moved all related files to `/data/anemia/trunc-len_303`.

## ASV Generation (Attempt 2)

- **Parameters**: Truncation length set to 253 nucleotides.
- **Result**: Successfully generated 1434 ASVs and 193 samples.
- **Storage**: All related files stored in `/data/anemia`.

## Taxonomy Analysis

- **Note**: Analysis in progress. Details will be updated upon completion.
