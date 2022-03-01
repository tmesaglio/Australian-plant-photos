#extract columns from the original APC file - nameType, acceptedNameUsage, taxonomicStatus, scientificName, canonicalName and taxonRank


#within taxonRank, filter to only include, species, forma, varietas, subspecies



#let's try it out

apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")
step1_apc<-dplyr::select(apc, nameType, acceptedNameUsage, taxonomicStatus, scientificName, canonicalName, taxonRank)

step3_apc <- filter(step2_apc, nameType=="scientific")
