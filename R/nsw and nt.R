library(tidyverse)
library(stringr)
library(dplyr)

#NSW query (plantNET)
unphotographed <- read_csv("data/unphotographed_all_tas_vic_pea.csv")

plantnet <-read_csv("data/PlantNET.csv")
plantnet_matched<-filter(plantnet, photo=="yes")

unphotographed_plantnet <- unphotographed %>% mutate(Match9 = case_when(canonicalName %in% plantnet_matched$canonical_name ~ "Yes", T ~ "No")) 
unphotographed2 <- filter(unphotographed_plantnet, Match9=="No")

