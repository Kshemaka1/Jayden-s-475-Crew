library(phyloseq)
library(ape)
library(tidyverse)
library(picante)
library(vegan)
library(dplyr)

#### Load in RData ####
load("R_Scripts_files/anemia_rare.RData")

infected_patients <- subset_samples(anemia_rare, infection_status %in% c("Incubation", "Early Convalescence", "Late Convalescence"))

sample_data(infected_patients)
