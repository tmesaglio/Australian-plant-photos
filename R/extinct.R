library(tidyverse)
library(stringr)
library(dplyr)
library(galah)

post_1972 <- galah_call() |> galah_identify("plantae") |> galah_filter(year >= 1972) |> atlas_species()
pre_1972 <- galah_call() |> galah_identify("plantae") |> galah_filter(year < 1972) |> atlas_species()

library(epiDisplay)
tab1(post_1972$phylum, sort.group = "decreasing")

post_1972<-post_1972[!grepl("Bryophyta|Marchantiophyta|Rhodophyta|Anthocerotophyta|Tracheophyta", post_1972$phylum),]
pre_1972<-pre_1972[!grepl("Bryophyta|Marchantiophyta|Rhodophyta|Anthocerotophyta|Tracheophyta", pre_1972$phylum),]


lookup <- !( pre_1972$species %in% post_1972$species)
pre_1972$species[lookup]


extinct <- pre_1972 %>% mutate(Match = case_when(species %in% post_1972$species ~ "Yes", T ~ "No")) 

extinct2<-filter(extinct,Match=="No")

#remove phrase names
extinct3<-extinct2[!grepl("sp.", extinct2$species),]

#remove some non-Australia stuff
extinct4<-extinct3[!grepl("NZOR", extinct3$species_guid),]

write_csv(extinct4,"data/putative_extinct.csv")
