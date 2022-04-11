library(tidyverse)
library(stringr)
library(dplyr)
library(devtools)

unphotographed <- read_csv("data/unphotographed_all_apii.csv")

devtools::install_github("nfox29/photosearcher")

library(photosearcher)

#testing the flickr api
rock_climbing <- photo_search(
  mindate_taken = "2010-01-01",
  maxdate_taken = "2018-01-01",
  text = "rock climbing",
  bbox = "-12.875977,49.210420,2.636719,59.977005",
  has_geo = TRUE
) 


#that worked, so now test for a plant species

diuris <- photo_search(mindate_taken = "1960-01-01",
                              maxdate_taken = "2022-04-11",
                              text = "Diuris",
                              has_geo = FALSE)
                              
