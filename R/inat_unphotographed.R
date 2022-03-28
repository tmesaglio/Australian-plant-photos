library(tidyverse)
library(stringr)
library(dplyr)

#read files
final_matrix <- read_csv("data/final_apc_matrix.csv")
iM5 <- read_csv("data/iM5.csv")

#find matches between iM5 and final_matrix
new_final_matrix <- final_matrix %>% mutate(Match = case_when(canonicalName %in% iM5$APC_name ~canonicalName, T ~ "No")) 
unphotographed_inat <- filter(new_final_matrix, Match=="No")

write_csv(unphotographed_inat,"data/unphotographed_inat.csv")

