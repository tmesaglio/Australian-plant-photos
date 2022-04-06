library(tidyverse)
library(stringr)
library(dplyr)

apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
unphotographed <- read_csv("data/unphotographed_all_tas_vic.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)
unphotographed<-rename(unphotographed, APC_name = canonicalName)

inat_families<- dplyr::inner_join(unphotographed, families, by = "APC_name")

peas<-dplyr::filter(inat_families, family == "Fabaceae")
peas<-dplyr::select(peas, APC_name)

write_csv(peas,"data/peas.csv")

#matching
matched_peas <- read_csv("data/peas.csv")

unphotographed_all_tas_vic <- read_csv("data/unphotographed_all_tas_vic.csv")

matched2 <- dplyr::filter(matched_peas, photo == "yes")

unphotographed_all_tas_vic_pea <- unphotographed_all_tas_vic %>% mutate(Match8 = case_when(canonicalName %in% matched2$APC_name ~ "Yes", T ~ "No")) 
unphotographed_all_tas_vic_pea <- filter(unphotographed_all_tas_vic_pea, Match8=="No")

write_csv(unphotographed_all_tas_vic_pea,"data/unphotographed_all_tas_vic_pea.csv")
