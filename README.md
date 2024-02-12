# MICB 475 Team 12: Lab Notebook and Meeting Agenda
This repository stores all the scripts and documentation related to our team's project!

## Summary
This project explores the complex effects of anemia on systemic metabolism and microbial functions, using four main metabolic indicators: Body Iron Storage, Ferritin, Retinol Binding Protein (RBP), and C Reactive Protein (CRP). These indicators provide insights into iron metabolism, vitamin A transport, protein synthesis, and metabolic syndrome.

# Table of Contents

1. [Project Aims](#Project-Aims)
2. [Agenda](#Agenda)
3. [Lab Notebook](#Lab-Notebook)



## Project Aims
- Aim 1: Microbiome Data Processing: Use Qiime2 for initial microbiome data processing to set the stage for detailed analysis.
- Aim 2: Diversity Analysis: Examine microbial diversity using Qiime or R to identify significant differences related to anemia.
- Aim 3: Targeted Analysis: Focus on interesting findings from the diversity analysis for deeper investigation, potentially expanding to differential abundance analysis.
- Aim 4: Metabolic Pathway Analysis: Use PICRUSt2 for functional analysis to identify metabolic pathways affected by anemia, using server-based and R analyses.
- Aim 5: Development of Predictive Models: Use identified metabolic markers to develop models predicting anemia

## Agenda

### February 14 2024 at 2:15 pm PST

## Lab Notebook
## Dataset Path

- **Path to dataset**: `/mnt/datasets/project_2/anemia`
- **Data storage location**: `/data/anemia`
- **Note**: All work should be saved in the `data` folder.

## Work Done

### Sequence Import and Demultiplexing

- **Task**: Imported and demultiplexed raw sequences.
- **Manifest file**: `anemia_manifest_updated.txt`
- **Output**: Generated a visualization file `demux.qzv` located in `/data/anemia`.

### ASV Generation (Attempt 1)

- **Parameters**: Truncation length set to 303 nucleotides.
- **Result**: Yielded 10 ASVs and 12 samples.
- **Action**: Moved all related files to `/data/anemia/trunc-len_303`.

### ASV Generation (Attempt 2)

- **Parameters**: Truncation length set to 253 nucleotides.
- **Result**: Successfully generated 1434 ASVs and 193 samples.
- **Storage**: All related files stored in `/data/anemia`.

## Taxonomy Analysis

- **Note**: Analysis in progress. Details will be updated upon completion.
