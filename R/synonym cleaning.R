#extract 3 columns from the original APC file - nameType, acceptedNameUsage, taxonomicStatus, scientificName and canonicalName

#reorder columns so that the scientificName column is first. This is the column from which the potential synonyms on iNat are matched

#using nameType, filter to remove phrase names etc



#let's try it out

apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
step1_apc<-dplyr::select(apc, nameType, acceptedNameUsage, taxonomicStatus, scientificName, canonicalName)

step2_apc <- step1_apc[, c(1,4,3,2,5)]

step3_apc <- filter(step2_apc, nameType=="scientific")
