library(tidyverse)
library(stringr)
library(dplyr)

apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
unphotographed_inat <- read_csv("data/unphotographed_inat.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)
unphotographed_inat<-rename(unphotographed_inat, APC_name = canonicalName)

inat_families<- dplyr::inner_join(unphotographed_inat, families, by = "APC_name")


library(epiDisplay)
tab1(inat_families$family, sort.group = "decreasing")

