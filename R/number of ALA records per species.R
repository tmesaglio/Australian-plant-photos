library(tidyverse)
library(stringr)
library(dplyr)
library(galah)
galah_config(email = "thomasmesaglio@hotmail.com")

file1<-read_csv("data/unphotographed_FINAL.csv")


unphoto1<-dplyr::slice(file1, 1:1000)
target1<-unphoto1$APC_name
m1 <- galah_call() |>
  galah_identify(target1) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()
m1_count<-dplyr::count(m1, scientificName)
m1_count$scientificName <- word(m1_count$scientificName, 1,2)
m1_sum <- aggregate(n ~ scientificName, m1_count, sum) 
m1_check <- m1_sum %>% mutate(Match = case_when(scientificName %in% unphoto1$APC_name ~ "Yes", T ~ "No"))
m1_check2 <- dplyr::filter(m1_check, Match == "Yes")
m1_check2<-rename(m1_check2, APC_name = scientificName)
joined1<-dplyr::left_join(unphoto1, m1_check2, by = "APC_name")
joined1<-select(joined1, -Match)
joined1[is.na(joined1)] <- 0
#need to manually fix a Stylidium 
joined1[440, 22] = 2

#back to others now
unphoto2<-dplyr::slice(file1, 1001:2000)
target2<-unphoto2$APC_name
m2 <- galah_call() |>
  galah_identify(target2) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()
m2_count<-dplyr::count(m2, scientificName)
m2_count$scientificName <- word(m2_count$scientificName, 1,2)
m2_sum <- aggregate(n ~ scientificName, m2_count, sum) 
m2_check <- m2_sum %>% mutate(Match = case_when(scientificName %in% unphoto2$APC_name ~ "Yes", T ~ "No"))
m2_check2 <- dplyr::filter(m2_check, Match == "Yes")
m2_check2<-rename(m2_check2, APC_name = scientificName)
joined2<-dplyr::left_join(unphoto2, m2_check2, by = "APC_name")
joined2<-select(joined2, -Match)
joined2[is.na(joined2)] <- 0


unphoto3<-dplyr::slice(file1, 2001:3000)
target3<-unphoto3$APC_name
m3 <- galah_call() |>
  galah_identify(target3) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()
m3_count<-dplyr::count(m3, scientificName)
m3_count$scientificName <- word(m3_count$scientificName, 1,2)
m3_sum <- aggregate(n ~ scientificName, m3_count, sum) 
m3_check <- m3_sum %>% mutate(Match = case_when(scientificName %in% unphoto3$APC_name ~ "Yes", T ~ "No"))
m3_check2 <- dplyr::filter(m3_check, Match == "Yes")
m3_check2<-rename(m3_check2, APC_name = scientificName)
joined3<-dplyr::left_join(unphoto3, m3_check2, by = "APC_name")
joined3<-select(joined3, -Match)
joined3[is.na(joined3)] <- 0


unphoto4<-dplyr::slice(file1, 3001:3774)
target4<-unphoto4$APC_name
m4 <- galah_call() |>
  galah_identify(target4) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()
m4_count<-dplyr::count(m4, scientificName)
m4_count$scientificName <- word(m4_count$scientificName, 1,2)
m4_sum <- aggregate(n ~ scientificName, m4_count, sum) 
m4_check <- m4_sum %>% mutate(Match = case_when(scientificName %in% unphoto4$APC_name ~ "Yes", T ~ "No"))
m4_check2 <- dplyr::filter(m4_check, Match == "Yes")
m4_check2<-rename(m4_check2, APC_name = scientificName)
joined4<-dplyr::left_join(unphoto4, m4_check2, by = "APC_name")
joined4<-select(joined4, -Match)
joined4[is.na(joined4)] <- 0


#join them all
joined_master<-dplyr::bind_rows(joined1, joined2, joined3, joined4)

#need to do some cleaning, e.g. for some bizarre reason, four seagrass species have 'absence' records getting included. 
#Also excluding Diuris calcicola which is getting incorrectly mapped due to synonymy issue, and I don't know how many records are 'true' calcicola

joined_master[1329, 22] = 514
joined_master[1324, 22] = 379
joined_master[1322, 22] = 1089
joined_master[1327, 22] = 572

joined_master <- joined_master[-c(1453),]

mean(joined_master$n)
median(joined_master$n)

#some sumnmary stats (16 April) --> mean no. records is 56.68389
# 106 zeros. Max. is 2354 (Eriachne avenacea)
# 7 have over 1000
# median is 25