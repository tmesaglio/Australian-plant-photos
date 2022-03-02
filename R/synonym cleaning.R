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
sample<-sample_n(tassie_names_final, 10)


#step 6
test <- sample %>% mutate(Good_name = case_when(taxon_species_name %in% step4_apc$canonicalName ~"Yes", T ~ "No")) %>%
  mutate(Good_name = case_when((Good_name =="No" & taxon_species_name %in% step3_apc$canonicalName)~ "Yes2", Good_name =="Yes"~"Yes", T ~ "No"))
