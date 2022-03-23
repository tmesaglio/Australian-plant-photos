library(tidyverse)
library(stringr)
library(dplyr)

#load in the original apc file but with irrelevant columns trimmed. This gives us 111,666 rows. We can equate rows to species.
nsw_test <- read_csv("data/nswtest.csv")

#now subset this to only include rows where the string 'NSW' appears (this is effectively searching the column 'taxonDistribution')
#now we only have entities for which their distribution is in NSW, which gives us 11,033 rows (=species)
nsw_test2 <- nsw_test %>%  filter_all(any_vars(str_detect(., pattern = "NSW")))

#now we cull all rows that are a taxonomic rank of genus or coarser, so that we only have species, hybrids etc. This now gives us 9037 species.
target<-c("Species","Subspecies","Varietas","Forma","Sectio","[unranked]","[infraspecies]","Nothovarietas")
nsw_test3 <- filter(nsw_test2,taxonRank %in% target)

#however that includes junk like infraspecies, variety, etc, so let's filter all those out too, and only subset rank = species. We now have 7801 species.
nsw_test4 <- filter(nsw_test3,taxonRank=="Species")

#now we filter the 'nameType' column to remove 'phrase name', 'named hybrid' and 'hybrid formula parents known', leaving us only with
#rows where rank = 'scientific'. We're now down to 7485 species.
nsw_test5 <-filter(nsw_test4,nameType=="scientific")

#the final step is to find the rows that equate to non-native species (='naturalised')
#I'll do very crudely using a proxy, i.e. filtering for the string 'NSW[space]'; this string only appears when the NSW is followed by
#'(naturalised)', '(doubtfully naturalised)' or '(native and naturalised)' (hence why it's a crude proxy, as I'm also losing some legit things
#such as Acacia baileyana). This filter returns 1693 species. Subtract that from our 7485 to give 5792. Then doing assorted cleaning and small fixes of errors
#we get the true number of 5824.
nsw_test_naturalised <- nsw_test5 %>%  filter_all(any_vars(str_detect(., pattern = "NSW ")))

                                                  