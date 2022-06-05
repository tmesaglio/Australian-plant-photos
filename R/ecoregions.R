#this analysis uses the shape file downloadable from https://www.gislounge.com/terrestrial-ecoregions-gis-data/

library(tidyverse)
library(sf)
library(spatialEco)

# load data
coords <- read_csv("data/spatial_analysis_FINAL.csv") 

biomes <-st_read("biomes2/Ecoregions2017.shp") %>%
  dplyr::select(ECO_NAME) %>% st_make_valid() # select variable wanted and make it valid

# make to spatial data and set projection

coords2 <- sf::st_as_sf(coords, coords = c("decimallongitude", "decimallatitude"), crs = 4326)

# match data to shapefile
xx <- point.in.poly(coords2, biomes, sp = TRUE, duplicate = TRUE)
# back to dataframe and save
coords3 <- as.data.frame(xx)

write_csv(coords3, "data/ecoregions.csv")

#note that in the ~200,000 row csv produced here, ~9600 rows have NA values for ecoregion. These are records where either the coordinates
#are close to the edge of land/sea or slightly in the ocean; the shape file I used is terrestrial only, and clearly seems to not have 
#ultra high resolution around the boundaries, so these values get missed out. I filled them in manually outside R (filename = 'ecoregions_updated')

#also note: whilst I could have filled in many/most of these NAs programatically in R based on neighbour values in the df, there are also
#a number of NAs right on the boundary of two ecoregion, with cases where rows keep swapping back and forth between them, so I was more 
#comfortable doing it manually for accuracy.

#third note: I removed a number of rows from the ecoregion csv due to them being wildly erroneous points in the middle of the ocean
#(the points that I had previously cleaned manually in an earlier figure, as noted above in lines 391-392)

#fourth note: for some rows, I added my own new 'ecoregion': "Offshore sand and reef flats and islands". This is to address records from 
#Ashmore Reef, Coral Sea Islands, etc., which for some reason have no designated ecoregion under the current global classification.

#I SCRAPPED THIS