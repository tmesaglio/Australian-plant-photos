library(tidyverse)
library(stringr)
library(dplyr)

#flickr
unphotographed <- read_csv("data/unphotographed_all_apii.csv")

flickr1<-dplyr::select(unphotographed, canonicalName)

write_csv(flickr1,"data/flickr1.csv")

flickr_matched <- read_csv("data/flickr1.csv")

flickr_matched2<-filter(flickr_matched, photo=="yes")

unphotographed2 <- unphotographed %>% mutate(Match21 = case_when(canonicalName %in% flickr_matched2$canonicalName ~ "Yes", T ~ "No")) 
unphotographed2 <- filter(unphotographed2, Match21=="No")


#and two final queries. 1. Solanaceae

solanaceae <- read_csv("data/solanaceae.csv")

unphotographed3 <- unphotographed2 %>% mutate(Match22 = case_when(canonicalName %in% solanaceae$canonicalName ~ "Yes", T ~ "No")) 
unphotographed3 <- filter(unphotographed3, Match22=="No")

write_csv(unphotographed3,"data/unphotographed_all_flickr_solanaceae.csv")

#2. one last sweep of iNat via ALA

library(galah)

unphotoA<-dplyr::slice(unphotographed3, 1:1000)
targetA<-unphotoA$canonicalName
m <- galah_call() |>
  galah_identify(targetA) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphotoB<-dplyr::slice(unphotographed3, 1001:2000)
targetB<-unphotoB$canonicalName
n <- galah_call() |>
  galah_identify(targetB) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphotoC<-dplyr::slice(unphotographed3, 2001:3000)
targetC<-unphotoC$canonicalName
o <- galah_call() |>
  galah_identify(targetC) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphotoD<-dplyr::slice(unphotographed3, 3001:3776)
targetD<-unphotoD$canonicalName
p <- galah_call() |>
  galah_identify(targetD) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

ala_query<-dplyr::bind_rows(m, n, o, p)
ala_query<-dplyr::select(ala_query, scientificName, dataResourceName, basisOfRecord)

preserved<-c("OBSERVATION","HUMAN_OBSERVATION","UNKNOWN")
ala_query2<-filter(ala_query,basisOfRecord %in% preserved)

iNat_ala<-dplyr::filter(ala_query2, dataResourceName =="iNaturalist Australia")

#bizarrely the ala query has pulled in all kinds of random crap from iNat that does not match what I told it to do. Have to remove those.

iNat_ala2 <- iNat_ala %>% mutate(Match = case_when(scientificName %in% unphotographed3$canonicalName ~ "Yes", T ~ "No")) 
iNat_ala3 <- filter(iNat_ala2, Match=="Yes")
#remove Diuris calcicola which is incorrectly mapping due to a synonym issue
iNat_ala4<-iNat_ala3[!grepl("Diuris calcicola", iNat_ala3$scientificName),]
#also manually add Lepidium peregrinum, as not in ALA yet (https://www.inaturalist.org/observations/111387787)
iNat_ala5<-iNat_ala4 %>% add_row(scientificName = "Lepidium peregrinum", dataResourceName = "iNaturalist Australia", basisOfRecord = "HUMAN_OBSERVATION", Match = "Yes")

#final sorting
unphotographed4 <- unphotographed3 %>% mutate(Match23 = case_when(canonicalName %in% iNat_ala5$scientificName ~ "Yes", T ~ "No")) 
unphotographed4 <- filter(unphotographed4, Match23=="No")

write_csv(unphotographed3,"data/unphotographed_all_DONE.csv")
