library(tidyverse)
library(stringr)
library(dplyr)


apni <- read_csv("data/APNI-names-2022-04-15-4017.csv")
apni1 <-filter(apni, taxonomicStatus == "accepted")
apni2<- select(apni1, canonicalName, namePublishedInYear)
apni2<-rename(apni2, APC_name = canonicalName)

file1 <- read_csv("data/unphotographed_FINAL.csv")

file2 <- dplyr::inner_join(file1, apni2, by = "APC_name")

file3 <- na.omit(file2) 

