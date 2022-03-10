library(tidyverse)
library(stringr)
library(dplyr)

#read in files
aus1 <- read_csv("data/masteriNat_Aus_part1.csv")
aus2 <- read_csv("data/masteriNat_Aus_part2.csv")
aus3 <- read_csv("data/masteriNat_Aus_part3.csv")
aus4 <- read_csv("data/masteriNat_Aus_part4.csv")
chi <- read_csv("data/masteriNat_ChI.csv")
coi <- read_csv("data/masteriNat_CoI.csv")
ni <- read_csv("data/masteriNat_NI.csv")
casual <- read_csv("data/masteriNat_casual.csv")

#bind all
iNat_first <- rbind(aus1, aus2, aus3, aus4, chi, coi, ni, casual)

#extract names column
iNat_second<-dplyr::select(iNat_first, scientific_name)

#remove duplicate rows, hybrids and subsp.
iNat_third<-dplyr::distinct(iNat_second)

iNat_fourth<-iNat_third[!grepl(" × ", iNat_third$scientific_name),]
iNat_fourth2<-iNat_fourth[!grepl("Chiloglottis ×pescottiana", iNat_fourth$scientific_name),]

iNat_fourth2$scientific_name <- word(iNat_fourth2$scientific_name, 1,2)

iNat_fifth<-dplyr::distinct(iNat_fourth2)

#iNat_sixth is now the final iNat list of names pre-synonym cleaning etc
iNat_sixth<-iNat_fifth %>% 
  rename(
    iNat_name = scientific_name
  )


write_csv(iNat_sixth,"data/iNat_sixth.csv")

#now for the cleaning and matching to APC names


Tassie_master <- tassie_names_final %>% mutate(Good_name = case_when(taxon_species_name %in% step4_apc$canonicalName ~taxon_species_name, T ~ "No")) 
TM2 <- Tassie_master %>% filter(Good_name == "No")
TM1 <- Tassie_master %>% anti_join(TM2) # separate good and bad matches
TM2 <- TM2 %>%  # do stage 2 matches
  left_join(step3_apc, by = c("taxon_species_name" = "canonicalName")) %>%
  mutate(Good_name = acceptedNameUsage) %>% select(taxon_species_name, Good_name)
TM3 <- bind_rows(TM1,TM2) # bind back together

#tidying up final TM3 file
TM3<-TM3 %>% rename(iNaturalist_name = "taxon_species_name", APC_names = "Good_name")
TM3[is.na(TM3)] <- "no match"

TM3$APC_name <- word(TM3$APC_names, 1,2)
TM3$APC_names <- NULL