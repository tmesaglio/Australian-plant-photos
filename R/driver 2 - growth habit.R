library(tidyverse)
library(stringr)
library(dplyr)


file1<-read_csv("data/unphotographed_FINAL.csv")
austraits<-read_csv("data/austraits_habit.csv")

austraits2<-select(austraits,taxon_name,name_resolution_and_type,plant_growth_form_recoded,plant_growth_form_simpler)
austraits3<-filter(austraits2,name_resolution_and_type == "binomial")

#check for names in file1 that are not in austraits file
check <- file1 %>% mutate(Match = case_when(APC_name %in% austraits3$taxon_name ~ "Yes", T ~ "No")) 

#only a single species is missing, Dentella arnhemensis (this is an MS name issue), so I'll manually add this after

#now to join files
austraits3<-rename(austraits3, APC_name = taxon_name)

file2 <- dplyr::inner_join(file1, austraits3, by = "APC_name")
file2<-select(file2, -name_resolution_and_type)

#add dentella
dentella<-read_csv("data/dentella_add_habit.csv")
file3<-dplyr::bind_rows(file2, dentella)


library(epiDisplay)
tab1(file3$plant_growth_form_simpler, sort.group = "decreasing")

