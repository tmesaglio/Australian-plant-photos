library(tidyverse)
library(stringr)
library(dplyr)


#tassie
unphotographed_i_a_f_e_w_rainforest<- read_csv("data/unphotographed_i_a_f_e_w_rainforest.csv")

tassie_left<-unphotographed_i_a_f_e_w_rainforest %>% filter(grepl('native', Tas))

tassie_left2<-select(tassie_left,canonicalName)

write_csv(tassie_left2,"data/tassie_left.csv")

tassie_updated<- read_csv("data/tassie_left.csv")

matched <- dplyr::filter(tassie_updated, photo == "yes")

unphotographed_all_tas <- unphotographed_i_a_f_e_w_rainforest %>% mutate(Match6 = case_when(canonicalName %in% matched$canonicalName ~ "Yes", T ~ "No")) 
unphotographed_all_tas <- filter(unphotographed_all_tas, Match6=="No")

write_csv(unphotographed_all_tas,"data/unphotographed_all_tas.csv")

#victoria

vic_left<-unphotographed_all_tas %>% filter(grepl('native', Vic))

vic_left2<-select(vic_left,canonicalName)

write_csv(vic_left2,"data/vic_left.csv")

vic_updated<- read_csv("data/vic_left.csv")

matched <- dplyr::filter(vic_updated, photo == "yes")

unphotographed_all_tas_vic <- unphotographed_all_tas %>% mutate(Match7 = case_when(canonicalName %in% matched$canonicalName ~ "Yes", T ~ "No")) 
unphotographed_all_tas_vic <- filter(unphotographed_all_tas_vic, Match7=="No")

write_csv(unphotographed_all_tas_vic,"data/unphotographed_all_tas_vic.csv")
          