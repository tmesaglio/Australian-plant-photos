library(tidyverse)
library(stringr)
library(dplyr)


#lets just slip in the cycads first before apii

unphotographed <- read_csv("data/unphotographed_all_orchid_encyclo.csv")
cycads <- read_csv("data/cycads.csv")
cycads_matched<-filter(cycads, photo=="yes")

unphotographed2 <- unphotographed %>% mutate(Match19 = case_when(canonicalName %in% cycads_matched$species ~ "Yes", T ~ "No")) 
unphotographed2 <- filter(unphotographed2, Match19=="No")

write_csv(unphotographed2,"data/unphotographed_all_cycads.csv")

#now apii

apii<- read_csv("data/apii.csv")

apii2 <- apii %>% mutate(Match = case_when(SCIENTIFICNAME %in% unphotographed2$canonicalName ~ "Yes", T ~ "No")) 
apii3 <- filter(apii2, Match=="Yes")


distinct_apii = apii3 %>% distinct(SCIENTIFICNAME)


write_csv(distinct_apii,"data/distinct_apii.csv")

#now read back in
apii_matched <- read_csv("data/distinct_apii.csv")

apii_matched2 <- filter(apii_matched, photo=="yes")

unphotographed3 <- unphotographed2 %>% mutate(Match20 = case_when(canonicalName %in% apii_matched2$SCIENTIFICNAME ~ "Yes", T ~ "No")) 
unphotographed3 <- filter(unphotographed3, Match20=="No")

write_csv(unphotographed2,"data/unphotographed_all_apii.csv")
