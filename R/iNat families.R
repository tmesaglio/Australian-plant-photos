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


#update after ausgrass done
apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
unphotographed <- read_csv("data/unphotographed_all_grass.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)
unphotographed<-rename(unphotographed, APC_name = canonicalName)

inat_families<- dplyr::inner_join(unphotographed, families, by = "APC_name")

library(epiDisplay)
tab1(inat_families$family, sort.group = "decreasing")

#get orchids for lucid
orchid<-filter(inat_families, family=="Orchidaceae")
orchid2<-dplyr::select(orchid, APC_name, family)

write_csv(orchid2,"data/orchid.csv")

#get a few families for last lucid keys

apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
unphotographed <- read_csv("data/unphotographed_all_nqplants.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)
unphotographed<-rename(unphotographed, APC_name = canonicalName)

inat_families<- dplyr::inner_join(unphotographed, families, by = "APC_name")

lucid_fab<-filter(inat_families, family=="Fabaceae")
lucid_rut<-filter(inat_families, family=="Rutaceae")
lucid_mal<-filter(inat_families, family=="Malvaceae")
lucid_goo<-filter(inat_families, family=="Goodeniaceae")
lucid_res<-filter(inat_families, family=="Restionaceae")
lucid_pro<-filter(inat_families, family=="Proteaceae")
lucid_lam<-filter(inat_families, family=="Lamiaceae")
lucid_hae<-filter(inat_families, family=="Haemodoraceae")

wa_lucid<-dplyr::bind_rows(lucid_fab, lucid_rut,lucid_mal,lucid_goo,lucid_res,lucid_pro,lucid_lam, lucid_hae)
wa_lucid2<-dplyr::select(wa_lucid, APC_name, family)

write_csv(wa_lucid2,"data/wa_lucid.csv")


#check after darwin page
apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
unphotographed <- read_csv("data/unphotographed_all_darwin.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)
unphotographed<-rename(unphotographed, APC_name = canonicalName)

inat_families<- dplyr::inner_join(unphotographed, families, by = "APC_name")

library(epiDisplay)
tab1(inat_families$family, sort.group = "decreasing")
