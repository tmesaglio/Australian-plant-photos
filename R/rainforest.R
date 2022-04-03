library(tidyverse)
library(stringr)
library(dplyr)

#some pre analysis cleaning
pre_rainforest <- read_csv("data/rainforest.csv")

pre_rainforest2<-pre_rainforest[!grepl("aceae", pre_rainforest$species),]

#match to unphotographed

unphoto <- read_csv("data/unphotographed_inat_ala_florabase_euclid_wattle.csv")

pre_rainforest3 <- pre_rainforest2 %>% mutate(Match = case_when(species %in% unphoto$canonicalName ~ "Yes", T ~ "No"))

pre_rainforest4 <- dplyr::filter(pre_rainforest3, Match == "Yes")
