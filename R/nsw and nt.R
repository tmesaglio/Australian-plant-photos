library(tidyverse)
library(stringr)
library(dplyr)

#NSW query (plantNET)
unphotographed <- read_csv("data/unphotographed_all_tas_vic_pea.csv")

plantnet <-read_csv("data/PlantNET.csv")
plantnet_matched<-filter(plantnet, photo=="yes")

unphotographed_plantnet <- unphotographed %>% mutate(Match9 = case_when(canonicalName %in% plantnet_matched$canonical_name ~ "Yes", T ~ "No")) 
unphotographed2 <- filter(unphotographed_plantnet, Match9=="No")

#nsw lucid key

se_nsw <- read_csv("data/se_nsw.csv")
se_nsw_match <- se_nsw %>% mutate(Match = case_when(species %in% unphotographed2$canonicalName ~ "Yes", T ~ "No")) 
se_nsw_match_yes<- filter(se_nsw_match, Match =="Yes")

write_csv(se_nsw_match_yes,"data/se_nsw_match_yes.csv")

updated_se_nsw <- read_csv("data/se_nsw_match_yes.csv")

matched <- dplyr::filter(updated_se_nsw, photo == "yes")

unphotographed_plantnet_lucid <- unphotographed2 %>% mutate(Match10 = case_when(canonicalName %in% matched$species ~ "Yes", T ~ "No")) 
unphotographed3 <- filter(unphotographed_plantnet_lucid, Match10=="No")

#NT

