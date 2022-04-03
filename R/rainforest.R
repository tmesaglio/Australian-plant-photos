library(tidyverse)
library(stringr)
library(dplyr)

#some pre analysis cleaning
pre_rainforest <- read_csv("data/rainforest.csv")

pre_rainforest2<-pre_rainforest[!grepl("aceae", pre_rainforest$species),]
