library(tidyverse)
library(stringr)
library(dplyr)

apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
iM5 <- read_csv("data/iM5.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)

inat_families<- dplyr::inner_join(iM5, families, by = "APC_name")

inat_families<- inat_families %>% add_row(iNat_name = "Machaerina articulata", APC_name = "Baumea articulata", family = "Cyperaceae")
inat_families<- inat_families %>% add_row(iNat_name = "Diuris leopardina", APC_name = "Diuris leopardina", family = "Orchidaceae")



library(epiDisplay)
tab1(inat_families$family, sort.group = "decreasing")

