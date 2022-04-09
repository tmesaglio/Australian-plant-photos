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


