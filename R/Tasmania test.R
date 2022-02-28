library(tidyverse)
apc<-read_csv("data/states_islands_species_list2.csv")
tas<-filter(apc,Tas=="native")

inat_tas<-read_csv("data/test-Tasmania.csv")

#dodgy way to get an endemic list
tas_endemics<-filter(apc,Tas=="native" & Vic =="not present" & NSW =="not present"& SA =="not present")

#get species missing photos
missing<-unique(tas_endemics$canonicalName[!tas_endemics$canonicalName %in% inat_tas$scientific_name])
not_missing<-unique(tas_endemics$canonicalName[tas_endemics$canonicalName %in% inat_tas$scientific_name])

#to do:
#fix synonyms


#check this out at family level
# https://github.com/traitecoevo/taxonlookup
library(taxonlookup)
tab<-taxonlookup::lookup_table(not_missing,by_species = TRUE)
tab %>%
  group_by(family) %>%
  summarize(photographed_in_inat=n()) ->not_missing_df

all_end <- taxonlookup::lookup_table(tas_endemics$canonicalName,by_species = TRUE)
all_end %>%
  group_by(family) %>%
  summarize(endemic_species=n()) ->end_df

joined_table<-left_join(end_df,not_missing_df)
joined_table$photographed_in_inat[is.na(joined_table$photographed_in_inat)]<-0

knitr::kable(joined_table)

