#extract 3 columns from the original APC file - nameType, acceptedNameUsage, taxonomicStatus, scientificName, canonicalName and taxonRank

#reorder columns so that the scientificName column is first. This is the column from which the potential synonyms on iNat are matched

#within taxonRank, filter to only include, species, forma, varietas, subspecies



#let's try it out

apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
step1_apc<-dplyr::select(apc, nameType, acceptedNameUsage, taxonomicStatus, scientificName, canonicalName, taxonRank)

step2_apc <- step1_apc[, c(1,6,4,3,2,5)]

step3_apc <- filter(step2_apc, nameType=="scientific")
