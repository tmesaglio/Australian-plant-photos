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

#note that I manually combined the above 18 CSVs into a single excel doc, with each as a sheet


#4. Original date of publication
apni<-read.csv(unz('APNI-names-2022-05-27-3243.zip','APNI-names-2022-05-27-3243.csv'), header = T)
apni1 <-filter(apni, taxonomicStatus == "accepted")
apni2<- dplyr::select(apni1, canonicalName, namePublishedInYear, nameInstanceType,originalNameUsage,originalNameUsageYear)
apni2<-rename(apni2, APC_name = canonicalName)


file2 <- dplyr::inner_join(unphotographed, apni2, by = "APC_name")

#for some reason, Mapania macrocephala is missing the year, so need to manually add it

file2[1796, 22] = 1890

#now to fill in the original dates for comb. nov., nom. nov. etc

file2$Original_Year = file2$originalNameUsageYear

file2$Original_Year <- ifelse(is.na(file2$Original_Year), file2$namePublishedInYear, file2$Original_Year)


file2$Original_Year <- as.factor(file2$Original_Year)
t3<-Freq(file2$Original_Year)
t3<-dplyr::select(t3, 1:2)
write_csv(t3,"data/FINAL RESULT - YEARS OF PUBLICATION.csv")
              