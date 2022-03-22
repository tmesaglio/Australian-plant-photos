library(tidyverse)
library(stringr)
library(dplyr)

#this is to remove non-native sp that slipped into the iNat export due to the current bug with lists and subspecies

#read in files
finalmatrix <- read_csv("data/final_apc_matrix.csv")
iM4 <- read_csv("data/iM4.csv")

ssp_apc<-dplyr::select(finalmatrix, canonicalName)
ssp_iM4<-dplyr::select(iM4, APC_name)

#matching
ssp2_iM4<-ssp_iM4 %>% mutate (Match = case_when(APC_name %in% ssp_apc$canonicalName ~ "Yes", T ~ "No"))

#extract non-matches
ssp3_iM4<-dplyr::filter(ssp2_iM4, Match=="No")

write_csv(ssp3_iM4,"data/ssp3_iM4.csv")

#double check I actually did remove everything
iM5 <- read_csv("data/iM5.csv")

ssp_iM5<-dplyr::select(iM5, APC_name)
ssp2_iM5<-ssp_iM5 %>% mutate (Match = case_when(APC_name %in% ssp_apc$canonicalName ~ "Yes", T ~ "No"))
ssp3_iM5<-dplyr::filter(ssp2_iM5, Match=="No")
