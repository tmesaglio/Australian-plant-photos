library(tidyverse)
library(stringr)
library(dplyr)

aus <- read_csv("data/MOST UP-TO DATE NATIVE MATRIX.csv")
aus<-rename(aus, APC_name = canonicalName)

#add genus
aus$Genus <- word(aus$APC_name, 1)


#add family
apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)
aus2<- dplyr::inner_join(aus, families, by = "APC_name")
aus2<-rename(aus2, Family = family)

#just need to fill na cells (which are all Vincetoxicum for some reason)
aus2$Family<-aus2$Family %>% replace_na('Apocynaceae')

#add the two species again that were missing from the original APC download (Baumea articulata, Diuris leopardina)
additions <- read_csv("data/apc_additions.csv")
aus3 <-dplyr::bind_rows(aus2, additions)

aus3<-arrange(aus3, Family, APC_name)


#add publication date
apni<-read.csv(unz('APNI-names-2022-05-27-3243.zip','APNI-names-2022-05-27-3243.csv'), header = T)
apni1 <-filter(apni, taxonomicStatus == "accepted")
apni2<- dplyr::select(apni1, canonicalName, namePublishedInYear, nameInstanceType,originalNameUsage,originalNameUsageYear)
apni2<-rename(apni2, APC_name = canonicalName)


aus4 <- dplyr::inner_join(aus3, apni2, by = "APC_name")

#for some reason, Mapania macrocephala is missing the year, so need to manually add it

aus4[4174, 23] = 1890

#now to fill in the original dates for comb. nov., nom. nov. etc

aus4$Original_Year = aus4$originalNameUsageYear

aus4$Original_Year <- ifelse(is.na(aus4$Original_Year), aus4$namePublishedInYear, aus4$Original_Year)

aus5<-dplyr::select(aus4, 1:22,27)

#now add the 8 species that disappeared during the above steps (due to taxonomic changes in the brief period between my APC and APNI downloads)
additions2 <- read_csv("data/apc_additions2.csv")
aus6 <-dplyr::bind_rows(aus5, additions2)

aus6<-arrange(aus6, Family, APC_name)



#add growth habit
austraits<-read_csv("data/austraits_habit.csv")

austraits2<-dplyr::select(austraits,taxon_name,name_resolution_and_type,plant_growth_form_recoded,plant_growth_form_simpler)
austraits3<-filter(austraits2,name_resolution_and_type == "binomial")

check <- aus6 %>% mutate(Match = case_when(APC_name %in% austraits3$taxon_name ~ "Yes", T ~ "No")) 

#four species missing (Diuris I added, and MS species), so I'll manually add these after

#now to join files
austraits3<-rename(austraits3, APC_name = taxon_name)

file3 <- dplyr::inner_join(aus6, austraits3, by = "APC_name")
file3<-dplyr::select(file3, -name_resolution_and_type)

#add those 4 species
additions3<-read_csv("data/apc_additions3.csv")
file4<-dplyr::bind_rows(file3, additions3)

#remove three odd duplicate rows
file5<-dplyr::distinct(file4)

file5<-arrange(file5, Family, APC_name)

library(epiDisplay)
tab1(file5$plant_growth_form_recoded, sort.group = "decreasing")


#this will now be the final file, with edits outside R for growth habit
#with documentation for changes to growth habit available in the xlsx file 'growth habits guide'

write_csv(file5,"data/MOST UP-TO DATE NATIVE MATRIX V2.csv")
