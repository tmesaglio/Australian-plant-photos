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
#read in
iNat_sixth <- read_csv("data/iNat_sixth.csv")
apc_accepted <- read_csv("data/apc_accepted.csv")
apc_synonyms <- read_csv("data/apc_synonyms.csv")

iNat_Master <- iNat_sixth %>% mutate(Good_name = case_when(iNat_name %in% apc_accepted$canonicalName ~iNat_name, T ~ "No")) 
iM2 <- iNat_Master %>% filter(Good_name == "No")
iM1 <- iNat_Master %>% anti_join(iM2) # separate good and bad matches
iM2 <- iM2 %>%  # do stage 2 matches
  left_join(apc_synonyms, by = c("iNat_name" = "canonicalName")) %>%
  mutate(Good_name = acceptedNameUsage) %>% select(iNat_name, Good_name)
iM3 <- bind_rows(iM1,iM2) # bind back together

#tidying up final TM3 file
iM3<-iM3 %>% rename(APC_name = "Good_name")
iM3[is.na(iM3)] <- "no match"

iM3$APC_name <- word(iM3$APC_name, 1,2)

write_csv(iM3,"data/iM3.csv")
