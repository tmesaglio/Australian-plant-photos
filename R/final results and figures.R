#note that this script was compiled on June 5th 2022

library(tidyverse)
library(stringr)
library(dplyr)

unphotographed <- read_csv("data/unphotographed_FINAL.csv")

#1. Family breakdown
library(DescTools)
t1<-Freq(unphotographed$family, ord="desc")
t1<-dplyr::rename(t1, Family = level)
t1<-dplyr::rename(t1, Number = freq)
t1$perc <- t1$perc * 100
t1<-dplyr::rename(t1, "Total %" = perc)
t1<-dplyr::select(t1, 1:3)

write_csv(t1,"data/FINAL RESULT - UNPHOTOGRAPHED FAMILY TABLE.csv")


#2. Genus breakdown
unphotographed2<-unphotographed
unphotographed2$APC_name <- word(unphotographed2$APC_name, 1)

t2<-Freq(unphotographed2$APC_name, ord="desc")
t2<-dplyr::rename(t2, Family = level)
t2<-dplyr::rename(t2, Number = freq)
t2$perc <- t2$perc * 100
t2<-dplyr::rename(t2, "Total %" = perc)
t2<-dplyr::select(t2, 1:3)

write_csv(t2,"data/FINAL RESULT - UNPHOTOGRAPHED GENUS TABLE.csv")


#note that I manually combined the above 2 CSVs (family and genus) into a single excel doc ("FINAL RESULT - UNPHOTOGRAPHED BY TAXONOMY"), 
#with each as a sheet

#3. State/territory breakdown
target<-c("native","native and naturalised")


NT<-filter(unphotographed,NT %in% target)
NT<-dplyr::select(NT, 1:2,21)
Qld<-filter(unphotographed,Qld %in% target)
Qld<-dplyr::select(Qld, 1:2,21)
WA<-filter(unphotographed,WA %in% target)
WA<-dplyr::select(WA, 1:2,21)
ChI<-filter(unphotographed,ChI %in% target)
ChI<-dplyr::select(ChI, 1:2,21)
NSW<-filter(unphotographed,NSW %in% target)
NSW<-dplyr::select(NSW, 1:2,21)
SA<-filter(unphotographed,SA %in% target)
SA<-dplyr::select(SA, 1:2,21)
Vic<-filter(unphotographed,Vic %in% target)
Vic<-dplyr::select(Vic, 1:2,21)
Tas<-filter(unphotographed,Tas %in% target)
Tas<-dplyr::select(Tas, 1:2,21)
ACT<-filter(unphotographed,ACT %in% target)
ACT<-dplyr::select(ACT, 1:2,21)
NI<-filter(unphotographed,NI %in% target)
NI<-dplyr::select(NI, 1:2,21)
LHI<-filter(unphotographed,LHI %in% target)
LHI<-dplyr::select(LHI, 1:2,21)
MI<-filter(unphotographed,MI %in% target)
MI<-dplyr::select(MI, 1:2,21)
HI<-filter(unphotographed,HI %in% target)
HI<-dplyr::select(HI, 1:2,21)
MDI<-filter(unphotographed,MDI %in% target)
MDI<-dplyr::select(MDI, 1:2,21)
CoI<-filter(unphotographed,CoI %in% target)
CoI<-dplyr::select(CoI, 1:2,21)
CSI<-filter(unphotographed,CSI %in% target)
CSI<-dplyr::select(CSI, 1:2,21)
AR<-filter(unphotographed,AR %in% target)
AR<-dplyr::select(AR, 1:2,21)
CaI<-filter(unphotographed,CaI %in% target)
CaI<-dplyr::select(CaI, 1:2,21)

write_csv(NT,"data/FINAL RESULT - NT.csv")
write_csv(Qld,"data/FINAL RESULT - QLd.csv")
write_csv(WA,"data/FINAL RESULT - WA.csv")
write_csv(ChI,"data/FINAL RESULT - ChI.csv")
write_csv(NSW,"data/FINAL RESULT - NSW.csv")
write_csv(SA,"data/FINAL RESULT - SA.csv")
write_csv(Vic,"data/FINAL RESULT - Vic.csv")
write_csv(Tas,"data/FINAL RESULT - Tas.csv")
write_csv(ACT,"data/FINAL RESULT - ACT.csv")
write_csv(NI,"data/FINAL RESULT - NI.csv")
write_csv(LHI,"data/FINAL RESULT - LHI.csv")
write_csv(MI,"data/FINAL RESULT - MI.csv")
write_csv(HI,"data/FINAL RESULT - HI.csv")
write_csv(MDI,"data/FINAL RESULT - MDI.csv")
write_csv(CoI,"data/FINAL RESULT - CoI.csv")
write_csv(CSI,"data/FINAL RESULT - CSI.csv")
write_csv(AR,"data/FINAL RESULT - AR.csv")
write_csv(CaI,"data/FINAL RESULT - CaI.csv")

#note that I manually combined the above 18 CSVs into a single excel doc ("FINAL RESULT - UNPHOTOGRAPHED BY STATE_TERRITORY), 
#with each as a sheet


#4. Original date of publication
apni<-read.csv(unz('APNI-names-2022-05-27-3243.zip','APNI-names-2022-05-27-3243.csv'), header = T)
apni1 <-filter(apni, taxonomicStatus == "accepted")
apni2<- dplyr::select(apni1, canonicalName, namePublishedInYear, nameInstanceType,originalNameUsage,originalNameUsageYear)
apni2<-rename(apni2, APC_name = canonicalName)


file2 <- dplyr::inner_join(unphotographed, apni2, by = "APC_name")

#for some reason, Mapania macrocephala is missing the year, so need to manually add it

file2[907, 22] = 1890

#now to fill in the original dates for comb. nov., nom. nov. etc

file2$Original_Year = file2$originalNameUsageYear

file2$Original_Year <- ifelse(is.na(file2$Original_Year), file2$namePublishedInYear, file2$Original_Year)


file2$Original_Year <- as.factor(file2$Original_Year)
t3<-Freq(file2$Original_Year)
t3<-dplyr::select(t3, 1:2)
write_csv(t3,"data/FINAL RESULT - YEARS OF PUBLICATION.csv")

#note I now manually edit this csv file outside R
#set working directory to the data folder here
years <- read_csv("FINAL RESULT - YEARS OF PUBLICATION.csv")
years[is.na(years)] <- 0

p<-ggplot(data=years, aes(x=level, y=freq)) +
  geom_bar(stat="identity",colour="black", size=0.2) +
  theme_classic() +
  scale_x_continuous(limits = c(1746,2020), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0,120), expand = c(0, 0)) 
p

ggsave("years.png")
#this figure was edited/cleaned in Affinity after


#4. Growth habit
#set working directory back to main folde3r
austraits<-read_csv("data/austraits_habit.csv")

austraits2<-dplyr::select(austraits,taxon_name,name_resolution_and_type,plant_growth_form_recoded,plant_growth_form_simpler)
austraits3<-filter(austraits2,name_resolution_and_type == "binomial")

#check for names in unphotographed that are not in austraits file
check <- unphotographed %>% mutate(Match = case_when(APC_name %in% austraits3$taxon_name ~ "Yes", T ~ "No")) 

#only a single species is missing, Dentella arnhemensis (this is an MS name issue), so I'll manually add this after

#now to join files
austraits3<-rename(austraits3, APC_name = taxon_name)

file3 <- dplyr::inner_join(unphotographed, austraits3, by = "APC_name")
file3<-dplyr::select(file2, -name_resolution_and_type)

#add dentella
dentella<-read_csv("data/dentella_add_habit.csv")
file4<-dplyr::bind_rows(file3, dentella)


library(epiDisplay)
tab1(file4$plant_growth_form_recoded, sort.group = "decreasing")

#note that documentation for changes to these growth habits is available in the xlsx file 'growth habits guide'

#treemap
library(treemap)
library(d3treeR)
library(treemapify)
library(ggplot2)


group <- c(rep("Shrubs"),rep("Herbs"),rep("Graminoids"),rep("Trees"),rep("Aquatic herbs and ferns"),rep("Cycads"),rep("Climbers"),rep("Terrestrial ferns"),rep("Woody climbers"),rep("Epiphytic ferns"),rep("Unknown"))
value <- c(1407,1289,597,213,89,3,34,38,32,13,1)
data <- data.frame(group,value)


ggplot(data, aes(area = value, fill = group)) +
  geom_treemap()
ggsave("habit.png")


#5. Spatial distribution
library(galah)
galah_config(email = "thomasmesaglio@hotmail.com")

#analysis done on 05/06/22
# note that if the code in this section is rerun, some lines need to be updated due to new ALA records

file1<-read_csv("data/unphotographed_FINAL.csv")


unphoto1<-dplyr::slice(file1, 1:1000)
target1<-unphoto1$APC_name
m1 <- galah_call() |>
  galah_identify(target1) |>
  galah_select(scientificName, eventDate,basisOfRecord,dataResourceName,country) |>
  atlas_occurrences()
m1$scientificName <- word(m1$scientificName, 1,2)
m1_check <- m1 %>% mutate(Match = case_when(scientificName %in% unphoto1$APC_name ~ "Yes", T ~ "No"))
m1_check2 <- dplyr::filter(m1_check, Match == "Yes")
m1_check2<-rename(m1_check2, APC_name = scientificName)
m1_check2<-m1_check2[ -c(10) ]
m1_aus<-filter(m1_check2, country == "Australia")
m1_aus2<-m1_aus[!is.na(m1_aus$decimalLatitude),]
#clean up the 2 seagrass species with absence records
m1_aus2<-m1_aus2[!grepl("Collation of spatial seagrass data", m1_aus2$dataResourceName),]



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
#clean up the 2 seagrass species with absence records
m2_aus2<-m2_aus2[!grepl("Collation of spatial seagrass data", m2_aus2$dataResourceName),]



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
#remove Diuris calcicola due to incorrect mapping
m3_aus2<-m3_aus2[!grepl("Diuris calcicola", m3_aus2$APC_name),]



unphoto4<-dplyr::slice(file1, 3001:3716)
target4<-unphoto4$APC_name
m4 <- galah_call() |>
  galah_identify(target4) |>
  galah_select(scientificName, eventDate,basisOfRecord,dataResourceName,country) |>
  atlas_occurrences()
m4$scientificName <- word(m4$scientificName, 1,2)
m4_check <- m4 %>% mutate(Match = case_when(scientificName %in% unphoto4$APC_name ~ "Yes", T ~ "No"))
#quickly manually fix one species (Dentella)
m4_check[6632, 11] = "Yes"
m4_check[6633, 11] = "Yes"
m4_check[6634, 11] = "Yes"
m4_check[6635, 11] = "Yes"
m4_check[6636, 11] = "Yes"
m4_check[6637, 11] = "Yes"
m4_check[6638, 11] = "Yes"
#back to business
m4_check2 <- dplyr::filter(m4_check, Match == "Yes")
m4_check2<-rename(m4_check2, APC_name = scientificName)
#need to manually fix a Stylidium 
m_stylidium <- galah_call() |>
  galah_identify("Stylidium perizostera") |>
  galah_select(scientificName, eventDate,basisOfRecord,dataResourceName,country) |>
  atlas_occurrences()
m_stylidium[1, 1] = "Stylidium perizoster"
m_stylidium[2, 1] = "Stylidium perizoster"
m_stylidium<-rename(m_stylidium, APC_name = scientificName)
m4_final<-dplyr::bind_rows(m4_check2, m_stylidium)
#back to business
m4_check2<-m4_final[ -c(10,11) ]
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
joined_cleaned3 <- joined_cleaned2[-c(1:9), ]

joined_cleaned4<-dplyr::arrange(joined_cleaned3, decimallatitude)


write_csv(joined_cleaned4,"data/spatial_analysis_FINAL.csv")

#now to map these using Sophie's code
library(raster)
library(viridis)
library(maps)

joined_cleaned5<-read_csv("data/spatial_analysis_FINAL.csv")

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

#turn the 7 NAs in middle of Aus to zeros
heat_map_df[6130, 3] = 0
heat_map_df[6132, 3] = 0
heat_map_df[6134, 3] = 0
heat_map_df[6322, 3] = 0
heat_map_df[6416, 3] = 0
heat_map_df[6524, 3] = 0
heat_map_df[6705, 3] = 0

map_australia <- 
  map_data("world") %>% 
  filter(region == "Australia") %>% 
  filter(lat > -45 | long < 155) # Check that this includes all the islands you want

heat_map_df <- heat_map_df %>% 
  mutate(species_num_binned = case_when(species_num == 0 ~ "0",
                                        species_num == 1 ~ "1",
                                        (species_num >= 2 & species_num <= 5) ~ "2 - 5",
                                        (species_num >= 6 & species_num <= 10) ~ "6 - 10",
                                        (species_num >= 11 & species_num <= 20) ~ "11 - 20",
                                        (species_num >= 21 & species_num <= 50) ~ "21 - 50",
                                        (species_num >= 51 & species_num <= 100) ~ "51 - 100",
                                        (species_num >= 101 & species_num <= 200) ~ "101 - 200",
                                        (species_num >= 201 & species_num <= 400) ~ "201 - 400",
                                        T ~ "NA"))

heat_map_df[ heat_map_df == "NA" ] <- NA

unique(heat_map_df$species_num_binned)
heat_map_df$species_num_binned<-factor(heat_map_df$species_num_binned,levels = rev(c("0","1","2 - 5","6 - 10","11 - 20",
                                                                                     "21 - 50","51 - 100","101 - 200",
                                                                                     "201 - 400")))

heat_map_df %>% 
  filter(!is.na(species_num_binned)) %>%
  ggplot(aes(x = x, y = y)) +
  geom_raster(aes(fill = species_num_binned), 
              interpolate = FALSE) + # Change interpolate argument to true for smoothing
  geom_polygon(data = map_australia, # Plot Australia polygon
               mapping = aes(x = long, y = lat, group = group), 
               fill = NA, 
               colour = "#1a1a1a",
               size = 0.4) +
  coord_fixed() +
  scale_fill_viridis_d(na.value = "white",direction = -1) +
  theme_classic() +
  theme(axis.line = element_blank(),
        panel.background = element_rect(fill = NA, size = 0.5, colour = "black"),
        axis.text = element_text(colour = "black", size = 9),
        axis.title = element_blank(),
        panel.spacing = unit(0.2, "cm"),
        legend.position = "right",
        legend.title = element_blank())

ggsave("spatial_dist.png")

#note that this figure was lightly manually cleaned outside R to remove grid cells stemming from datapoints in the middle of the ocean
#(easier to do rather than trawl through several hundred thousand rows in the joined_cleaned5 file)


#6. Check on iNat progress since original iNat filter (13 April 2022)

library(tidyverse)
library(stringr)
library(dplyr)
library(galah)

#just a final check of how many species were actually on iNat (since I did the original iNat export early compared to all other sites)

inatu <- read_csv("data/unphotographed_inat.csv")

#so 21,079 - 9059 [actually 21,077 - 9057] = 12,020 initially

#now the ALA stuff (note I'm doing this on May 31st 2022, numbers will change constantly after this if code is rerun)
unphoto1<-dplyr::slice(inatu, 1:1000)
target1<-unphoto1$canonicalName
m1 <- galah_call() |>
  galah_identify(target1) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto2<-dplyr::slice(inatu, 1001:2000)
target2<-unphoto2$canonicalName
m2 <- galah_call() |>
  galah_identify(target2) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto3<-dplyr::slice(inatu, 2001:3000)
target3<-unphoto3$canonicalName
m3 <- galah_call() |>
  galah_identify(target3) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto4<-dplyr::slice(inatu, 3001:4000)
target4<-unphoto4$canonicalName
m4 <- galah_call() |>
  galah_identify(target4) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto5<-dplyr::slice(inatu, 4001:5000)
target5<-unphoto5$canonicalName
m5 <- galah_call() |>
  galah_identify(target5) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto6<-dplyr::slice(inatu, 5001:6000)
target6<-unphoto6$canonicalName
m6 <- galah_call() |>
  galah_identify(target6) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto7<-dplyr::slice(inatu, 6001:7000)
target7<-unphoto7$canonicalName
m7 <- galah_call() |>
  galah_identify(target7) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto8<-dplyr::slice(inatu, 7001:8000)
target8<-unphoto8$canonicalName
m8 <- galah_call() |>
  galah_identify(target8) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto9<-dplyr::slice(inatu, 8001:9000)
target9<-unphoto9$canonicalName
m9 <- galah_call() |>
  galah_identify(target9) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

unphoto10<-dplyr::slice(inatu, 9001:9059)
target10<-unphoto10$canonicalName
m10 <- galah_call() |>
  galah_identify(target9) |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()

ala_query<-dplyr::bind_rows(m1, m2, m3, m4, m5, m6, m7, m8, m9, m10)
ala_query<-dplyr::select(ala_query, scientificName, dataResourceName, basisOfRecord)

preserved<-c("OBSERVATION","HUMAN_OBSERVATION","UNKNOWN")
ala_query2<-filter(ala_query,basisOfRecord %in% preserved)

iNat_ala<-dplyr::filter(ala_query2, dataResourceName =="iNaturalist Australia")
iNat_ala2 <- iNat_ala %>% mutate(Match = case_when(scientificName %in% inatu$canonicalName ~ "Yes", T ~ "No")) 
iNat_ala3 <- filter(iNat_ala2, Match=="Yes")
iNat_ala4<-iNat_ala3[!grepl("Diuris calcicola", iNat_ala3$scientificName),]
iNat_ala5<-iNat_ala4[!grepl("Corybas dentatus", iNat_ala4$scientificName),]
iNat_ala6<-iNat_ala5[!grepl("Thelymitra jonesii", iNat_ala5$scientificName),]

iNat_ala7 <- iNat_ala6 %>% distinct(scientificName, .keep_all = TRUE)

#189 additional species in just 48 days! Almost 4 per day.

big_un <- read_csv("data/unphotographed_FINAL.csv")
big_un2 <- iNat_ala7 %>% mutate(Match = case_when(scientificName %in% big_un$APC_name ~ "Yes", T ~ "No"))
write_csv(big_un2, "data/inat_after_analysis.csv")

#27 species that are still on the unphotographed list! [ie they got uploaded to iNat after I finished my analyses on April 15th 2022]


