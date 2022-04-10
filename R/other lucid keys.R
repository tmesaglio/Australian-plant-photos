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


#triodia and ptilotus

tri_pti<-read_csv("data/triodia_ptilotus.csv")

unphotographed7 <- unphotographed6 %>% mutate(Match16 = case_when(canonicalName %in% tri_pti$species ~ "Yes", T ~ "No")) 
unphotographed7 <- filter(unphotographed7, Match16=="No")

write_csv(unphotographed7,"data/unphotographed_all_wa_lucid_genera.csv")


#darwin page

darwin<-read_csv("data/darwin.csv")
unphotographed8 <- unphotographed7 %>% mutate(Match17 = case_when(canonicalName %in% darwin$species ~ "Yes", T ~ "No")) 
unphotographed8 <- filter(unphotographed8, Match17=="No")

write_csv(unphotographed8,"data/unphotographed_all_darwin.csv")

#orchid encyclopedia

orchid_encyclo<-read_csv("data/orchid_encyclo.csv")
orchid_encyclo_matched<-filter(orchid_encyclo, photo=="yes")

unphotographed8<-read_csv("data/unphotographed_all_darwin.csv")

unphotographed9 <- unphotographed8 %>% mutate(Match18 = case_when(canonicalName %in% orchid_encyclo_matched$APC_name ~ "Yes", T ~ "No")) 
unphotographed9 <- filter(unphotographed9, Match18=="No")

write_csv(unphotographed9,"data/unphotographed_all_orchid_encyclo.csv")

