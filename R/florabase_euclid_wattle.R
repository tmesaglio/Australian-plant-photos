library(tidyverse)
library(stringr)
library(dplyr)


florabase <- read_csv("data/florabase_photos.csv")
unphotographed_inat_ala <- read_csv("data/unphotographed_inat_ala.csv")

unphotographed_inat_ala_florabase <- unphotographed_inat_ala %>% mutate(Match3 = case_when(canonicalName %in% florabase$canonical_name ~ "Yes", T ~ "No")) 
unphotographed_inat_ala_florabase <- filter(unphotographed_inat_ala_florabase, Match3=="No")

#note above that although the florabase file has 1720 species, only 1000 were removed from the unph._inat_ala df; that's because the other 720 were removed
#via the ALA query, which I had been doing simultaneously 

write_csv(unphotographed_inat_ala_florabase,"data/unphotographed_inat_ala_florabase.csv")


#as above for eucalypts and wattles
euclid_wattle <- read_csv("data/euclid_wattle.csv")
unphotographed_inat_ala_florabase <- read_csv("data/unphotographed_inat_ala_florabase.csv")

unphotographed_inat_ala_florabase_euclid_wattle <- unphotographed_inat_ala_florabase %>% mutate(Match4 = case_when(canonicalName %in% euclid_wattle$species ~ "Yes", T ~ "No")) 
unphotographed_inat_ala_florabase_euclid_wattle <- filter(unphotographed_inat_ala_florabase_euclid_wattle, Match4=="No")

write_csv(unphotographed_inat_ala_florabase_euclid_wattle,"data/unphotographed_inat_ala_florabase_euclid_wattle.csv")
