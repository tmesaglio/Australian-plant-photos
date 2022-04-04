library(tidyverse)
library(stringr)
library(dplyr)

#some pre analysis cleaning
rainforest <- read_csv("data/rainforest.csv")

pre_rainforest2<-pre_rainforest[!grepl("aceae", pre_rainforest$species),]

#match to unphotographed

unphoto <- read_csv("data/unphotographed_inat_ala_florabase_euclid_wattle.csv")

pre_rainforest3 <- pre_rainforest2 %>% mutate(Match = case_when(species %in% unphoto$canonicalName ~ "Yes", T ~ "No"))

pre_rainforest4 <- dplyr::filter(pre_rainforest3, Match == "Yes")

write_csv(pre_rainforest4,"data/pre_rainforest.csv")

#matching
matched<- read_csv("data/pre_rainforest_matched.csv")
unphotographed_inat_ala_florabase_euclid_wattle <- read_csv("data/unphotographed_inat_ala_florabase_euclid_wattle.csv")

matched2 <- dplyr::filter(matched, photo == "yes")

unphotographed_i_a_f_e_w_rainforest <- unphotographed_inat_ala_florabase_euclid_wattle %>% mutate(Match5 = case_when(canonicalName %in% matched2$species ~ "Yes", T ~ "No")) 
unphotographed_i_a_f_e_w_rainforest <- filter(unphotographed_i_a_f_e_w_rainforest, Match5=="No")

write_csv(unphotographed_i_a_f_e_w_rainforest,"data/unphotographed_i_a_f_e_w_rainforest.csv")
