library(tidyverse)
library(stringr)



apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
step1_apc<-dplyr::select(apc, nameType, acceptedNameUsage, taxonomicStatus, scientificName, canonicalName, taxonRank)

step2_apc <- filter(step1_apc, nameType=="scientific")
