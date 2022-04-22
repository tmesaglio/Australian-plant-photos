library(tidyverse)
library(stringr)
library(dplyr)
library(galah)
galah_config(email = "thomasmesaglio@hotmail.com")

#analysis done on 22/4/22

file1<-read_csv("data/unphotographed_FINAL.csv")


unphoto1<-dplyr::slice(file1, 1:1000)
target1<-unphoto1$APC_name
m1 <- galah_call() |>
  galah_identify(target1) |>
  galah_select(scientificName, eventDate,basisOfRecord,dataResourceName,country) |>
  atlas_occurrences()
m1$scientificName <- word(m1$scientificName, 1,2)
m1_check <- m1 %>% mutate(Match = case_when(scientificName %in% unphoto1$APC_name ~ "Yes", T ~ "No"))
#quickly manually fix one species (Dentella)
m1_check[8015, 11] = "Yes"
m1_check[8016, 11] = "Yes"
m1_check[8017, 11] = "Yes"
m1_check[8018, 11] = "Yes"
m1_check[8019, 11] = "Yes"
m1_check[8020, 11] = "Yes"
m1_check[8021, 11] = "Yes"
#back to business
m1_check2 <- dplyr::filter(m1_check, Match == "Yes")
m1_check2<-rename(m1_check2, APC_name = scientificName)
#need to manually fix a Stylidium 
m_stylidium <- galah_call() |>
  galah_identify("Stylidium perizostera") |>
  galah_select(scientificName, eventDate,basisOfRecord,dataResourceName,country) |>
  atlas_occurrences()
m_stylidium[1, 1] = "Stylidium perizoster"
m_stylidium[2, 1] = "Stylidium perizoster"
m_stylidium<-rename(m_stylidium, APC_name = scientificName)
m1_final<-dplyr::bind_rows(m1_check2, m_stylidium)
#back to business
m1_final<-m1_final[ -c(10,11) ]
m1_aus<-filter(m1_final, country == "Australia")
m1_aus2<-m1_aus[!is.na(m1_aus$decimalLatitude),]




unphoto2<-dplyr::slice(file1, 1001:2000)
target2<-unphoto2$APC_name
m2 <- galah_call() |>
  galah_identify(target2) |>
  galah_select(scientificName, eventDate,basisOfRecord,dataResourceName,country) |>
  atlas_occurrences()
m2$scientificName <- word(m2$scientificName, 1,2)
m2_check <- m2 %>% mutate(Match = case_when(scientificName %in% unphoto2$APC_name ~ "Yes", T ~ "No"))
m2_check2 <- dplyr::filter(m2_check, Match == "Yes")
m2_check2<-rename(m2_check2, APC_name = scientificName)
m2_check2<-m2_check2[ -c(10) ]
m2_aus<-filter(m2_check2, country == "Australia")
m2_aus2<-m2_aus[!is.na(m2_aus$decimalLatitude),]
#clean up the 4 seagrass species with absence records
m2_aus2<-m2_aus2[!grepl("Collation of spatial seagrass data", m2_aus2$dataResourceName),]
#also remove Diuris calcicola due to incorrect mapping
m2_aus2<-m2_aus2[!grepl("Diuris calcicola", m2_aus2$APC_name),]



unphoto3<-dplyr::slice(file1, 2001:3000)
target3<-unphoto3$APC_name
m3 <- galah_call() |>
  galah_identify(target3) |>
  galah_select(scientificName, eventDate,basisOfRecord,dataResourceName,country) |>
  atlas_occurrences()
m3$scientificName <- word(m3$scientificName, 1,2)
m3_check <- m3 %>% mutate(Match = case_when(scientificName %in% unphoto3$APC_name ~ "Yes", T ~ "No"))
m3_check2 <- dplyr::filter(m3_check, Match == "Yes")
m3_check2<-rename(m3_check2, APC_name = scientificName)
m3_check2<-m3_check2[ -c(10) ]
m3_aus<-filter(m3_check2, country == "Australia")
m3_aus2<-m3_aus[!is.na(m3_aus$decimalLatitude),]




unphoto4<-dplyr::slice(file1, 3001:3773)
target4<-unphoto4$APC_name
m4 <- galah_call() |>
  galah_identify(target4) |>
  galah_select(scientificName, eventDate,basisOfRecord,dataResourceName,country) |>
  atlas_occurrences()
m4$scientificName <- word(m4$scientificName, 1,2)
m4_check <- m4 %>% mutate(Match = case_when(scientificName %in% unphoto4$APC_name ~ "Yes", T ~ "No"))
m4_check2 <- dplyr::filter(m4_check, Match == "Yes")
m4_check2<-rename(m4_check2, APC_name = scientificName)
m4_check2<-m4_check2[ -c(10) ]
m4_aus<-filter(m4_check2, country == "Australia")
m4_aus2<-m4_aus[!is.na(m4_aus$decimalLatitude),]



#join them all
joined<-dplyr::bind_rows(m1_aus2, m2_aus2, m3_aus2, m4_aus2)


#coordinate cleaner to remove possible erroneous records (coordinates = the herbarium)
library(CoordinateCleaner)
joined<-rename(joined, decimallongitude = decimalLongitude)
joined<-rename(joined, decimallatitude = decimalLatitude)
joined_cleaned<-cc_inst(joined, value = "clean", buffer = 500, geod = TRUE)

#so more cleaning of weird location errors (eg points in Africa or middle of ocean)
joined_cleaned2<-dplyr::arrange(joined_cleaned, decimallongitude)
joined_cleaned3 <- joined_cleaned2[-c(1:13), ]

joined_cleaned4<-dplyr::arrange(joined_cleaned3, decimallatitude)
joined_cleaned5 <- joined_cleaned4[-c(198849:198855), ]
joined_cleaned5 <- joined_cleaned5[-c(36260), ]
joined_cleaned5 <- joined_cleaned5[-c(5302:5311), ]
joined_cleaned5 <- joined_cleaned5[-c(91219,147606), ]



#now to map these using Sophie's code
library(raster)
library(viridis)
library(maps)


calc_num_species <- function(data, na.rm = TRUE) {
  
  num_species <- data %>% unique() %>% length()
  return(num_species)
  
}

make_species_heat_map <- function(df, pixel_size = 1) {
  # Make SpatialPointsDataFrame and base raster
  occurrence_data <- df
  coordinates(occurrence_data) <- c("decimallongitude", "decimallatitude")
  base_raster <- occurrence_data %>% extent() %>% raster(resolution = pixel_size)
  
  # Calculate RasterLayer for each value in variable  
  heat_map <- 
    rasterize(occurrence_data, 
              base_raster, 
              occurrence_data$APC_name, # Feed scientificName column into the following function
              fun = calc_num_species)
  return(heat_map)
}

heat_map <- make_species_heat_map(joined_cleaned5, pixel_size = 1) # Change pixel_size here

heat_map_df <- 
  heat_map %>% 
  as.data.frame(xy = TRUE) %>% 
  rename(species_num = layer)

map_australia <- 
  map_data("world") %>% 
  filter(region == "Australia") %>% 
  filter(lat > -45 | long < 155) # Check that this includes all the islands you want

heat_map_df %>% 
  ggplot(aes(x = x, y = y)) +
  geom_raster(aes(fill = species_num), 
              interpolate = FALSE) + # Change interpolate argument to true for smoothing
  geom_polygon(data = map_australia, # Plot Australia polygon
               mapping = aes(x = long, y = lat, group = group), 
               fill = NA, 
               colour = "#1a1a1a",
               size = 0.4) +
  coord_fixed() +
  scale_fill_viridis(na.value = "white") +
  # My code for customising legend, very unnecessary though
  guides(fill = guide_colourbar(ticks.colour = "black", 
                                ticks.linewidth = 1,
                                frame.colour = "black",
                                frame.linewidth = 1,
                                direction = "vertical",
                                title.position = "top",
                                barwidth = 0.7,
                                barheight = 6)) +
  theme_classic() +
  theme(axis.line = element_blank(),
        panel.background = element_rect(fill = NA, size = 0.5, colour = "black"),
        axis.text = element_text(colour = "black", size = 9),
        axis.title = element_blank(),
        panel.spacing = unit(0.2, "cm"),
        legend.position = "right",
        legend.title = element_blank())

