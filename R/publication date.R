library(tidyverse)
library(stringr)
library(dplyr)


apni <- read_csv("data/APNI-names-2022-04-21-0323.csv")
apni1 <-filter(apni, taxonomicStatus == "accepted")
apni2<- select(apni1, canonicalName, namePublishedInYear, nameInstanceType)
apni2<-rename(apni2, APC_name = canonicalName)

file1 <- read_csv("data/unphotographed_FINAL.csv")

file2 <- dplyr::inner_join(file1, apni2, by = "APC_name")

#for some reason, Mapania macrocephala is missing the year, so need to manually add it

file2[1798, 22] = 1890

#robert brown
brown<-filter(file2, namePublishedInYear == "1810")
write_csv(brown,"data/brown.csv")
