library(tidyverse)
library(stringr)
library(dplyr)
library(devtools)

unphotographed <- read_csv("data/unphotographed_all_apii.csv")

devtools::install_github("nfox29/photosearcher")

library(photosearcher)

diuris <- photo_search(mindate_taken = "1960-01-01", 
                       maxdate_taken = "2022-04-11", 
                       text = "Diuris", 
                       has_geo = FALSE)

Diuris_brockmanii<-dplyr::filter(diuris,grepl("Diuris brockmanii",diuris$title,ignore.case = T)|
                                   grepl("Diuris brockmanii",diuris$tags,ignore.case = T)|
                                   grepl("Diuris brockmanii",diuris$description,ignore.case = T)|
                                   grepl("Diurisbrockmanii",diuris$title,ignore.case = T)|
                                   grepl("Diurisbrockmanii",diuris$tags,ignore.case = T)|
                                   grepl("Diurisbrockmanii",diuris$description,ignore.case = T)|
                                   grepl("Diuris_brockmanii",diuris$title,ignore.case = T)|
                                   grepl("Diuris_brockmanii",diuris$tags,ignore.case = T)|
                                   grepl("Diuris_brockmanii",diuris$description,ignore.case = T))
