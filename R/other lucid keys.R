library(tidyverse)
library(stringr)
library(dplyr)

unphotographed <- read_csv("data/unphotographed_all_grass.csv")

#orchids
orchid <- read_csv("data/orchid.csv")

orchid_matched<-filter(orchid, photo=="yes")

unphotographed2 <- unphotographed %>% mutate(Match12 = case_when(canonicalName %in% orchid_matched$APC_name ~ "Yes", T ~ "No")) 
unphotographed2 <- filter(unphotographed2, Match12=="No")


#ferns and lycophytes
fern <- read_csv("data/fern.csv")
fern2 <- fern %>% mutate(Match = case_when(species %in% unphotographed$canonicalName ~ "Yes", T ~ "No")) 
fern3 <- filter(fern2, Match=="Yes")
write_csv(fern3,"data/ferns.csv")

ferns<- read_csv("data/ferns.csv")

ferns_matched<-filter(ferns, photo=="yes")

unphotographed3 <- unphotographed2 %>% mutate(Match13 = case_when(canonicalName %in% ferns_matched$species ~ "Yes", T ~ "No")) 
unphotographed3 <- filter(unphotographed3, Match13=="No")


#nqplants

nqplants <- read_csv("data/nqplants.csv")

unphotographed4 <- unphotographed3 %>% mutate(Match14 = case_when(canonicalName %in% nqplants$species ~ "Yes", T ~ "No")) 
unphotographed4 <- filter(unphotographed4, Match14=="No")

write_csv(unphotographed4,"data/unphotographed_all_nqplants.csv")


#wa lucid keys

wa_lucid <- read_csv("data/wa_lucid.csv")
unphotographed5 <- read_csv("data/unphotographed_all_nqplants.csv")

wa_lucid_matched<-filter(wa_lucid, photo=="yes")

unphotographed6 <- unphotographed5 %>% mutate(Match15 = case_when(canonicalName %in% wa_lucid_matched$APC_name ~ "Yes", T ~ "No")) 
unphotographed6 <- filter(unphotographed6, Match15=="No")

write_csv(unphotographed6,"data/unphotographed_all_wa_lucid.csv")
