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

