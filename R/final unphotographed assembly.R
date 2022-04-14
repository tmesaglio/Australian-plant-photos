library(tidyverse)
library(stringr)
library(dplyr)

unphotographed <- read_csv("data/unphotographed_all_DONE.csv")

#remove unneeded match columns
file1 <-select(unphotographed, species:CaI)

#family stuff
apc <- read_csv("data/APC-taxon-2022-02-14-5132.csv")

apc2 <- filter(apc, taxonRank == "Species",taxonomicStatus=="accepted",nameType=="scientific")
families<-dplyr::select(apc2, canonicalName, family)

families<-rename(families, APC_name = canonicalName)
file1<-rename(file1, APC_name = canonicalName)

file2<- dplyr::inner_join(file1, families, by = "APC_name")

library(epiDisplay)
tab1(file2$family, sort.group = "decreasing")

#% by state

target<-c("native","native and naturalised")


NT<-filter(file2,NT %in% target)

Qld<-filter(file2,Qld %in% target)

WA<-filter(file2,WA %in% target)

ChI<-filter(file2,ChI %in% target)

NSW<-filter(file2,NSW %in% target)

SA<-filter(file2,SA %in% target)

Vic<-filter(file2,Vic %in% target)

Tas<-filter(file2,Tas %in% target)

ACT<-filter(file2,ACT %in% target)

NI<-filter(file2,NI %in% target)

LHI<-filter(file2,LHI %in% target)

MI<-filter(file2,MI %in% target)

HI<-filter(file2,HI %in% target)

MDI<-filter(file2,MDI %in% target)

CoI<-filter(file2,CoI %in% target)

CSI<-filter(file2,CSI %in% target)

AR<-filter(file2,AR %in% target)

CaI<-filter(file2,CaI %in% target)

#write the final file!

write_csv(file2,"data/unphotographed_FINAL.csv")
