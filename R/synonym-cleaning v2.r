library(tidyverse)
library(stringr)

#per the steps noted in issue 7 on the github page

#step 1
apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
step1_apc<-dplyr::select(apc, nameType, acceptedNameUsage, taxonomicStatus, scientificName, canonicalName, taxonRank)

#step 2
target <- c("Species", "Forma", "Varietas", "Subspecies")
step2_apc <- filter(step1_apc, taxonRank %in% target)

#step 3
step3_apc <- filter(step2_apc, taxonomicStatus %in% c("pro parte misapplied","nomenclatural synonym","taxonomic synonym","misapplied","orthographic variant","basionym","isonym","excluded","doubtful taxonomic synonym","pro parte taxonomic synonym","doubtful pro parte taxonomic synonym","replaced synonym","doubtful misapplied","doubtful pro parte misapplied","pro parte nomenclatural synonym","alternative name","doubtful nomenclatural synonym","trade name"))

#step 4
step4_apc <- filter(step2_apc, taxonomicStatus=="accepted")

#step 5
tassie <- read_csv("data/test-Tasmania.csv")
#have to remove hybrids, as they came in with the export
tassie2 <-tassie %>%
  filter(!is.na(taxon_species_name))

tassie_names_first_run<-dplyr::select(tassie2, taxon_species_name)

tassie_names_final<-dplyr::distinct(tassie_names_first_run)

#step 5.5 --> select random small sample from tassie_names_final to test the matching script in steps 6 and 7
set.seed(123)
sample<-sample_n(tassie_names_final, 10)


#steps 6 and 7 on the small sample
test <- sample %>% mutate(Good_name = case_when(taxon_species_name %in% step4_apc$canonicalName ~taxon_species_name, T ~ "No"))# match names step 1
t2 <- test %>% filter(Good_name == "No")
t1 <- test %>% anti_join(t2) # separate good and bad matches
t2 <- t2 %>%  # do stage 2 matches
  left_join(step3_apc, by = c("taxon_species_name" = "canonicalName")) %>%
    mutate(Good_name = acceptedNameUsage) %>% select(taxon_species_name, Good_name)
test <- bind_rows(t1,t2) # bind back together


#steps 6 and 7 on the whole Tassie df
Tassie_master <- tassie_names_final %>% mutate(Good_name = case_when(taxon_species_name %in% step4_apc$canonicalName ~taxon_species_name, T ~ "No")) 
TM2 <- Tassie_master %>% filter(Good_name == "No")
TM1 <- Tassie_master %>% anti_join(TM2) # separate good and bad matches
TM2 <- TM2 %>%  # do stage 2 matches
  left_join(step3_apc, by = c("taxon_species_name" = "canonicalName")) %>%
  mutate(Good_name = acceptedNameUsage) %>% select(taxon_species_name, Good_name)
TM3 <- bind_rows(TM1,TM2) # bind back together
