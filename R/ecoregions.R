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

#remove all rows with NAs (ALA records that fall into the ocean due to entry error, GPS misreadings, etc)

coords4 <- coords3 %>% drop_na(ECO_NAME)

coords5 <- coords4 %>%
  group_by(APC_name, ECO_NAME) %>%
  summarise(number = n()) %>%
  arrange(desc(number))

coords6<-dplyr::arrange(coords5, APC_name)

coords7<- coords6 %>% group_by(APC_name) %>% summarise(Value = ECO_NAME[which.max(number)],num.obs=max(number))



