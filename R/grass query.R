library(tidyverse)
library(stringr)
library(dplyr)


unphotographed <- read_csv("data/unphotographed_plantnet_lucid_ntflora.csv")

grass<-read_csv("data/grass.csv")
grass_matched<-filter(grass, photo=="yes")

unphotographed_all_grass <- unphotographed %>% mutate(Match11 = case_when(canonicalName %in% grass_matched$APC_name ~ "Yes", T ~ "No")) 
unphotographed_all_grass <- filter(unphotographed_all_grass, Match11=="No")

write_csv(unphotographed_all_grass,"data/unphotographed_all_grass.csv")
