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
