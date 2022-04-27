library(tidyverse)
library(stringr)
library(dplyr)


apni <- read_csv("data/APNI-names-2022-04-27-0103.csv")
apni1 <-filter(apni, taxonomicStatus == "accepted")
apni2<- dplyr::select(apni1, canonicalName, namePublishedInYear, nameInstanceType,originalNameUsage,originalNameUsageYear)
apni2<-rename(apni2, APC_name = canonicalName)

file1 <- read_csv("data/unphotographed_FINAL.csv")

file2 <- dplyr::inner_join(file1, apni2, by = "APC_name")

#for some reason, Mapania macrocephala is missing the year, so need to manually add it

file2[1796, 22] = 1890


#now to fill in the original dates for comb. nov., nom. nov. etc

file2$Original_Year = file2$originalNameUsageYear

file2$Original_Year <- ifelse(is.na(file2$Original_Year), file2$namePublishedInYear, file2$Original_Year)


my_tab1 <- table(file2$Original_Year)
barplot(my_tab1)  














#robert brown out of interest
brown<-filter(file2, namePublishedInYear == "1810")


library(galah)
library(ozmaps)
library(tidyverse)
library(taxonlookup)
galah_config(email = "wcornwell@gmail.com")


target1<-brown$APC_name
m1 <- galah_call() |>
  galah_identify(target1) |>
  galah_select(scientificName, eventDate,basisOfRecord,typeStatus,country) |>
  atlas_occurrences()

m1 <- na.omit(m1) 

 m2<-m1 %>% filter(country == "Australia") %>%
    group_by(scientificName) %>%
    summarize(
      decimalLongitude = median(decimalLongitude),
      decimalLatitude = median(decimalLatitude)
    )


m2 %>%
  filter(decimalLatitude < 0, decimalLongitude > 100) -> sm2

sf_oz <- ozmap("states")
ggplot(data = sf_oz) + geom_sf() +
  geom_point(data = sm2,
             aes(x = decimalLongitude, y = decimalLatitude),
             alpha = 0.5) +
  theme_bw() 
