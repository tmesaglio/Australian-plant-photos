library(tidyverse)
library(stringr)
library(dplyr)

extinct <- read_csv("data/humphreys_extinct.csv")

extinct<-dplyr::select(extinct, Accepted.binomial, Accepted.Rank, Locality, List, Source.Rediscovered.or.Synonymised)

extinct2 <- filter(extinct, Accepted.Rank == "species",List=="Rediscovered")

target<-c("WAU","QLD","NSW","SOA","TAS","VIC","NTA")
extinct3<-filter(extinct2,Locality %in% target)
