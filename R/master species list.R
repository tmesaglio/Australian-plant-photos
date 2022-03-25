#NOTE: UP TO LINE 49 IN THIS SCRIPT IS NOW DEPRECATED DUE TO AN ISSUE WITH LHI AND HI (DOCUMENTED ON THE GITHUB PAGE). THE NEW SCRIPT COMES AFTER IT, BUT
#I'M RETAINING THE OLD SCRIPT JUST IN CASE SOMETHING GOES WRONG

library(tidyverse)
library(stringr)
library(dplyr)

apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
apc_species <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")


#separate the states
sep_state_data <-
  str_split(unique(apc_species$taxonDistribution), ",")

#get unique places
all_codes <- unique(str_trim(unlist(sep_state_data)))
apc_places <- unique(word(all_codes[!is.na(all_codes)], 1, 1))

#make a table to fill in
data.frame(col.names = apc_places)
species_df <- tibble(species = apc_species$scientificName)
for (i in 1:length(apc_places)) {
  species_df <- bind_cols(species_df, NA)
}
names(species_df) <- c("species", apc_places)

#look for all possible entries after each state
state_parse_and_add_column <- function(species_df, state, apc_species){
  print(all_codes[grepl(state,all_codes)]) # checking for weird ones
  species_df[,state] <- case_when(
    grepl(paste0(state," \\(uncertain origin\\)"), apc_species$taxonDistribution) ~ "uncertain origin",
    grepl(paste0(state," \\(naturalised\\)"), apc_species$taxonDistribution) ~ "naturalised",
    grepl(paste0(state," \\(doubtfully naturalised\\)"), apc_species$taxonDistribution) ~ "doubtfully naturalised",
    grepl(paste0(state," \\(native and naturalised\\)"), apc_species$taxonDistribution) ~ "native and naturalised",
    grepl(paste0(state," \\(formerly naturalised\\)"), apc_species$taxonDistribution) ~ "formerly naturalised",
    grepl(paste0(state," \\(presumed extinct\\)"), apc_species$taxonDistribution) ~ "presumed extinct",
    grepl(paste0(state," \\(native and doubtfully naturalised\\)"), apc_species$taxonDistribution) ~ "native and doubtfully naturalised",
    grepl(paste0(state," \\(native and uncertain origin\\)"), apc_species$taxonDistribution) ~ "native and uncertain origin",
    grepl(state, apc_species$taxonDistribution) ~ "native", #no entry = native, it's important this is last in the list
    TRUE ~ "not present"
  )
  return(species_df)
}

#go through the states one by one
for (i in 1:length(apc_places)){
  species_df <- state_parse_and_add_column(species_df,apc_places[i],apc_species)
}




#new script
apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
apc_species <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")

#seperate the states
sep_state_data <-
  str_split(unique(apc_species$taxonDistribution), ",")

#get unique places
all_codes <- unique(str_trim(unlist(sep_state_data)))
apc_places <- unique(word(all_codes[!is.na(all_codes)], 1, 1))

#make a table to fill in
data.frame(col.names = apc_places)
species_df <- tibble(species = apc_species$scientificName)
for (i in 1:length(apc_places)) {
  species_df <- bind_cols(species_df, NA)
}
names(species_df) <- c("species", apc_places)

#look for all possible entries after each state
state_parse_and_add_column <- function(species_df, state, apc_species){
  print(all_codes[grepl(state,all_codes)]) # checking for weird ones
  species_df[,state] <- case_when(
    grepl(paste0("\\b",state," \\(uncertain origin\\)"), apc_species$taxonDistribution) ~ "uncertain origin",
    grepl(paste0("\\b",state," \\(naturalised\\)"), apc_species$taxonDistribution) ~ "naturalised",
    grepl(paste0("\\b",state," \\(doubtfully naturalised\\)"), apc_species$taxonDistribution) ~ "doubtfully naturalised",
    grepl(paste0("\\b",state," \\(native and naturalised\\)"), apc_species$taxonDistribution) ~ "native and naturalised",
    grepl(paste0("\\b",state," \\(formerly naturalised\\)"), apc_species$taxonDistribution) ~ "formerly naturalised",
    grepl(paste0("\\b",state," \\(presumed extinct\\)"), apc_species$taxonDistribution) ~ "presumed extinct",
    grepl(paste0("\\b",state," \\(native and doubtfully naturalised\\)"), apc_species$taxonDistribution) ~ "native and doubtfully naturalised",
    grepl(paste0("\\b",state," \\(native and uncertain origin\\)"), apc_species$taxonDistribution) ~ "native and uncertain origin",
    grepl(paste0("\\b",state), apc_species$taxonDistribution) ~ "native", #no entry = native, it's important this is last in the list
    TRUE ~ "not present"
  )
  return(species_df)
}

#bug checking
#species_df<-state_parse_and_add_column(species_df,"LHI",apc_species)
#species_df<-state_parse_and_add_column(species_df,"HI",apc_species)

#go through the states one by one
for (i in 1:length(apc_places)){
  species_df <- state_parse_and_add_column(species_df,apc_places[i],apc_species)
}



#add column for species name without author name, and merge with species_df (from this point on this is the same script as the original)

x<-dplyr::select(apc_species, scientificName, canonicalName)

new_x<-x %>% 
  rename(
    species = scientificName
  )

big_species_df<-dplyr::left_join(species_df,new_x,by="species")

big_species_df2 <- big_species_df[, c(1, 20, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)]
big_species_df2

#now to eliminate the non-native species from this matrix 
final_matrix<-big_species_df2 %>%  filter_all(any_vars(str_detect(., pattern = "native")))

#append a few extras that escaped the export
append <- read_csv("data/apc_additions.csv")

final_matrix<-dplyr::bind_rows(append, final_matrix)

write_csv(final_matrix,"data/final_apc_matrix.csv")
