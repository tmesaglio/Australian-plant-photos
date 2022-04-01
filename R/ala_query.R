#NOTE: SEE LINES 106 ONWARDS FOR THE ACTUAL CODE
library(galah)
library(tidyverse)
library(stringr)
library(dplyr)

#
# the galah_select thing is the key to get out the right fields
# galah_filter can also filter by those field (I think)
# 

m <- galah_call() |>
  galah_identify("Persoonia gunnii", "Eucalyptus robusta", "Cirsium vulgare", "Acacia longifolia") |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()


table(m$basisOfRecord)
#seems like the ones we want are human_observation, observation, and unknown; only 'preserved_specimen' seems to be photos of things not in situ or alive


unphotographed <- read_csv("data/unphotographed_inat.csv")


acacia<-unphotographed %>% filter(grepl('Acacia', canonicalName))
target2<-acacia$canonicalName

m <- galah_call() |>
  galah_identify(target2) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus,eventRemarks) |>
  atlas_occurrences()

#when I tried to define the entire unphotographed species column as a vector (as I did for Acacia above), it couldn't match 4 entities, and failed
#I'll test removing these now and see if they were what caused it to fail

new_unphotographed<-unphotographed[-c(967, 2119, 3250, 3377), ]
target3<-new_unphotographed$canonicalName

m <- galah_call() |>
  galah_identify(target3) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

#ok that's not the problem, it obviously can't handle that many queries at once. But the Acacia request worked, so that means the max. limit is somewhere
#between 524 rows and 9112 rows. I'll try halving the dataset first

unphoto1<-dplyr::slice(unphotographed, 1:4556)
unphoto2<-dplyr::slice(unphotographed, 4557:9112)

target4<-unphoto1$canonicalName
target5<-unphoto2$canonicalName

m <- galah_call() |>
  galah_identify(target5) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

#failed to work for 4556 rows, will try quarters now

unphoto3<-dplyr::slice(unphotographed, 1:2278)
unphoto4<-dplyr::slice(unphotographed, 2279:4556)
unphoto5<-dplyr::slice(unphotographed, 4557:6834)
unphoto6<-dplyr::slice(unphotographed, 6835:9112)

target6<-unphoto3$canonicalName
target7<-unphoto6$canonicalName

m <- galah_call() |>
  galah_identify(target7) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

#seems like 2278 rows also fails; fairly disappointing code/package

unphoto7<-dplyr::slice(unphotographed, 8113:9112)
target8<-unphoto7$canonicalName
m <- galah_call() |>
  galah_identify(target8) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

#1000 works! Now to test if those non-matches stuff things or not

unphoto8<-dplyr::slice(unphotographed, 1:1000)
target9<-unphoto8$canonicalName
m <- galah_call() |>
  galah_identify(target9) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

#ok it does. By the way, here are the four non-matches, which I'll have to do manually (for some reason, even though ALA uses APC names, the ALA has orthographic
#variants of these (two) or doesn't list them at all (two)...)
#Stylidium perizoster
#Eremophila annosicaulis
#Corybas longitubus
#x Phelodia tutelata
#I have removed that hybrid, so there are only 3 now I need to actually check

#proper code:
library(galah)
library(tidyverse)
library(stringr)
library(dplyr)

galah_config(email = "your-email@email.com")


unphotographed <- read_csv("data/unphotographed_inat.csv")

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

#Fixing erroneous matches, erroneous non-native listings by APC, general cleaning, etc. 

ala_query2$scientificName <- word(ala_query2$scientificName, 1,2)

ala_query3<-ala_query2 %>% mutate (Match = case_when(scientificName %in% unphotographed$canonicalName ~ "Yes", T ~ "No"))
ala_query4<-filter(ala_query3,Match=="Yes")

#delete some rows from ala_query4 due to erroneous matching between APC and ALA
ala_query5<-ala_query4[!grepl("Corybas dentatus", ala_query4$scientificName),]
ala_query5<-ala_query5[!grepl("Diuris calcicola", ala_query5$scientificName),]
ala_query5<-ala_query5[!grepl("Thelymitra jonesii", ala_query5$scientificName),]
ala_query5<-ala_query5[!grepl("Agrostis parviflora", ala_query5$scientificName),]
ala_query5 <- ala_query5[-c(10688:10695), ]
ala_query5 <- ala_query5[-c(10689:10703), ]

#count unique values in ala_query5
length(unique(ala_query5$scientificName))
#this added 3082, so now we have 15101/21094 = 71.59%

#create new unphotographed file
unphotographed_inat_ala <- unphotographed %>% mutate(Match = case_when(canonicalName %in% ala_query5$scientificName ~ "Yes", T ~ "No")) 
unphotographed_inat <- filter(new_final_matrix, Match=="No")