library(tmap) 
library(here)
library(sf)
library(rgdal)


boston <- readOGR(dsn = "This PC/Documents/GitHub/Australian-plant-photos/data", layer = "AshmoreAndCartierIslands")
