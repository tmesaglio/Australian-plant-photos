library(galah)

#
# the galah_select thing is the key to get out the right fields
# galah_filter can also filter by those field (I think)
# 

m <- galah_call() |>
  galah_identify("Persoonia gunnii") |>
  galah_filter(multimedia == c("Image")) |>
  galah_select(scientificName, eventDate,dataResourceName,basisOfRecord,typeStatus) |>
  atlas_occurrences()



