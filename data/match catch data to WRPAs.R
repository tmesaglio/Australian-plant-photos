# Match Biodata and Catch data to Water Resource Areas
# BPEOM Data Round 1

library(tidyverse)
library(sf)
library(spatialEco)

# load data
catch_data <- read_csv("../../BPEOM round 1/BPEOM Catch.csv") 
WRAs <-st_read("WRA Shapefile/Surface Water Water Resource Plan Areas.shp") %>%
  dplyr::select(SWWRPANAME) %>% st_make_valid() # select variable wanted and make it valid

# make to spatial data and set projection
catch_data2 <- sf::st_as_sf(catch_data, coords = c("SampleLongitude", "SampleLatitude"), crs = 4283)

# match data to shapefile
xx <- point.in.poly(catch_data2, WRAs, sp = TRUE, duplicate = TRUE)
# back to dataframe and save
catch_data3 <- as.data.frame(xx)
write_csv(catch_data3, "../../BPEOM round 1/BPEOM Catch with WRPA.csv")


# All boat electrofishing
mydata <- read.csv("Full Boat Electrofishing Catch.csv") %>%
  mutate(EffortData = str_replace_all(EffortData, pattern = "\"\"", replacement = "\"")) %>%
  mutate(boat = str_extract(EffortData, pattern="\"ElectrofishingDuration\"......"),
         ESecs = parse_number(boat),
         boat = NULL) %>% drop_na(SampleLatitude)


catch_data2 <- sf::st_as_sf(mydata, coords = c("SampleLongitude", "SampleLatitude"), crs = 4283)

xx <- point.in.poly(catch_data2, WRAs, sp = TRUE, duplicate = TRUE)

catch_data3 <- as.data.frame(xx)
write_csv(catch_data3, "Full Boat Electrofishing Catch with WRPA.csv")

### Now Bio data

catch_data <- read_csv("../BPEOM round 1/BPEOM Bio data.csv") %>% drop_na(SampleLatitude)
WRAs <-st_read("../database exploration/WRA Shapefile/Surface Water Water Resource Plan Areas.shp") %>%
  dplyr::select(SWWRPANAME) %>% st_make_valid() # select variable wanted and make it valid

catch_data2 <- sf::st_as_sf(catch_data, coords = c("SampleLongitude", "SampleLatitude"), crs = 4283)

xx <- point.in.poly(catch_data2, WRAs, sp = TRUE, duplicate = TRUE)

catch_data3 <- as.data.frame(xx)
write_csv(catch_data3, "../BPEOM round 1/BPEOM Bio data with WRPA.csv")

### Now water quality data

catch_data <- read_csv("../../BPEOM round 1/BPEOM Water Quality.csv") %>% drop_na(SampleLatitude)
WRAs <-st_read("../../database exploration/WRA Shapefile/Surface Water Water Resource Plan Areas.shp") %>%
  dplyr::select(SWWRPANAME) %>% st_make_valid() # select variable wanted and make it valid

catch_data2 <- sf::st_as_sf(catch_data, coords = c("SampleLongitude", "SampleLatitude"), crs = 4283)

xx <- point.in.poly(catch_data2, WRAs, sp = TRUE, duplicate = TRUE)

catch_data3 <- as.data.frame(xx)
write_csv(catch_data3, "../../BPEOM round 1/BPEOM Water Quality with WRPA.csv")

### MDB Fish survey data now

catch_data <- read_csv("../BPEOM round 1/MDBFS Catch.csv") %>% drop_na(SampleLatitude)
WRAs <-st_read("../database exploration/WRA Shapefile/Surface Water Water Resource Plan Areas.shp") %>%
  dplyr::select(SWWRPANAME) %>% st_make_valid() # select variable wanted and make it valid

catch_data2 <- sf::st_as_sf(catch_data, coords = c("SampleLongitude", "SampleLatitude"), crs = 4283)

xx <- point.in.poly(catch_data2, WRAs, sp = TRUE, duplicate = TRUE)

catch_data3 <- as.data.frame(xx)
write_csv(catch_data3, "../BPEOM round 1/MDBFS Catch with WRPA.csv")


### Now Bio data

catch_data <- read_csv("../BPEOM round 1/MDBFS Bio.csv") %>% drop_na(SampleLatitude)
WRAs <-st_read("../database exploration/WRA Shapefile/Surface Water Water Resource Plan Areas.shp") %>%
  dplyr::select(SWWRPANAME) %>% st_make_valid() # select variable wanted and make it valid

# make the datafile into spatial data
catch_data2 <- sf::st_as_sf(catch_data, coords = c("SampleLongitude", "SampleLatitude"), crs = 4283)

# match spatial data to the shapefile
xx <- point.in.poly(catch_data2, WRAs, sp = TRUE, duplicate = TRUE)

# back to dataframe and save
catch_data3 <- as.data.frame(xx)
write_csv(catch_data3, "../BPEOM round 1/MDBFS Bio data with WRPA.csv")

## MERGE BPEOM AND MDBFS
BCatch <- read_csv("../BPEOM round 1/BPEOM Catch with WRPA.csv")
MCatch <- read_csv("../BPEOM round 1/MDBFS Catch with WRPA.csv")
all_catch <- bind_rows(BCatch, MCatch)
all2 <- all_catch %>% distinct()
write_csv(all2, "../BPEOM round 1/All catch with WRPA.csv")


BCatch <- read_csv("../BPEOM round 1/BPEOM Bio data with WRPA.csv")
MCatch <- read_csv("../BPEOM round 1/MDBFS Bio data with WRPA.csv")
all_catch <- bind_rows(BCatch, MCatch)
all2 <- all_catch %>% distinct()
write_csv(all2, "../BPEOM round 1/All bio with WRPA.csv")
