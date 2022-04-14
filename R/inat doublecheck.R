library(tidyverse)
library(stringr)
library(dplyr)
library(galah)

#just a final check of how many species were actually on iNat (since I did the original iNat export early compared to all other sites)

unphotographed <- read_csv("data/unphotographed_inat.csv")

#so 21,079 - 9059 = 12,020 initially

#now the ALA stuff (note I'm doing this on April 14th 2022, numbers will change constantly after this)
unphoto1<-dplyr::slice(unphotographed, 1:1000)
target1<-unphoto1$canonicalName
m1 <- galah_call() |>
  galah_identify(target1) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto2<-dplyr::slice(unphotographed, 1001:2000)
target2<-unphoto2$canonicalName
m2 <- galah_call() |>
  galah_identify(target2) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto3<-dplyr::slice(unphotographed, 2001:3000)
target3<-unphoto3$canonicalName
m3 <- galah_call() |>
  galah_identify(target3) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto4<-dplyr::slice(unphotographed, 3001:4000)
target4<-unphoto4$canonicalName
m4 <- galah_call() |>
  galah_identify(target4) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto5<-dplyr::slice(unphotographed, 4001:5000)
target5<-unphoto5$canonicalName
m5 <- galah_call() |>
  galah_identify(target5) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto6<-dplyr::slice(unphotographed, 5001:6000)
target6<-unphoto6$canonicalName
m6 <- galah_call() |>
  galah_identify(target6) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto7<-dplyr::slice(unphotographed, 6001:7000)
target7<-unphoto7$canonicalName
m7 <- galah_call() |>
  galah_identify(target7) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto8<-dplyr::slice(unphotographed, 7001:8000)
target8<-unphoto8$canonicalName
m8 <- galah_call() |>
  galah_identify(target8) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto9<-dplyr::slice(unphotographed, 8001:9000)
target9<-unphoto9$canonicalName
m9 <- galah_call() |>
  galah_identify(target9) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto10<-dplyr::slice(unphotographed, 9001:9111)
target10<-unphoto10$canonicalName
m10 <- galah_call() |>
  galah_identify(target9) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

ala_query<-dplyr::bind_rows(m1, m2, m3, m4, m5, m6, m7, m8, m9, m10)
ala_query<-dplyr::select(ala_query, scientificName, dataResourceName, basisOfRecord)

preserved<-c("OBSERVATION","HUMAN_OBSERVATION","UNKNOWN")
ala_query2<-filter(ala_query,basisOfRecord %in% preserved)

iNat_ala<-dplyr::filter(ala_query2, dataResourceName =="iNaturalist Australia")
iNat_ala2 <- iNat_ala %>% mutate(Match = case_when(scientificName %in% unphotographed$canonicalName ~ "Yes", T ~ "No")) 
iNat_ala3 <- filter(iNat_ala2, Match=="Yes")
iNat_ala4<-iNat_ala3[!grepl("Diuris calcicola", iNat_ala3$scientificName),]
iNat_ala5<-iNat_ala4[!grepl("Corybas dentatus", iNat_ala4$scientificName),]
iNat_ala6<-iNat_ala5[!grepl("Thelymitra jonesii", iNat_ala5$scientificName),]

iNat_ala7 <- iNat_ala6 %>% distinct(scientificName, .keep_all = TRUE)

#so those 70, plus the extra Lepidium = 71 + 12,020 = 12,091 = 57.36 of all Aus species (also noting that in 36 days, 71 new species got added to iNat! [March 9 to April 14])