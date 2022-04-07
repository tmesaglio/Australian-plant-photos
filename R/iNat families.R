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


#let's do an update after having queried ala, florabase etc


apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
unphotographed <- read_csv("data/unphotographed_all_tas_vic.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)
unphotographed<-rename(unphotographed, APC_name = canonicalName)

inat_families<- dplyr::inner_join(unphotographed, families, by = "APC_name")


library(epiDisplay)
tab1(inat_families$family, sort.group = "decreasing")


#another update (ntflora most recent query)

apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
unphotographed <- read_csv("data/unphotographed_plantnet__lucid_ntflora.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)
unphotographed<-rename(unphotographed, APC_name = canonicalName)

inat_families<- dplyr::inner_join(unphotographed, families, by = "APC_name")


library(epiDisplay)
tab1(inat_families$family, sort.group = "decreasing")

#get grasses list for ausgrass2
grass<-filter(inat_families, family=="Poaceae")
grass2<-dplyr::select(grass, APC_name, family)

write_csv(grass2,"data/grass.csv")
