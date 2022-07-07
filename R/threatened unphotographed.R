library(tidyverse)
library(stringr)
library(dplyr)

un <- read_csv("data/master_unphotographed_file.csv")
th <- read_csv("data/threatened.csv")

th$Species <- word(th$Species, 1,2)
check <- th %>% mutate(Match = case_when(Species %in% un$APC_name ~ "Yes", T ~ "No"))

write_csv(check,"data/threatened_unphotographed.csv")
