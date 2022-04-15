library(tidyverse)
library(stringr)
library(dplyr)
library(remotes)

remotes::install_github("traitecoevo/austraits", build_vignettes = FALSE)

library(austraits)
get_versions(path = "data/austraits")
austraits <- load_austraits(version = "3.0.2", path = "data/austraits")

habit <- extract_trait(austraits, "plant_growth_form")
habit2<-habit[["traits"]]

habit2<-select(habit2, taxon_name, value)
habit2<-rename(habit2, APC_name = taxon_name)

file1<-read_csv("data/unphotographed_FINAL.csv")

file2 <- dplyr::inner_join(file1, habit2, by = "APC_name")

file3<-distinct(file2)


