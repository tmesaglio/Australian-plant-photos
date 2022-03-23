library(tidyverse)
library(stringr)
library(dplyr)

#read in files
final_matrix <- read_csv("data/final_apc_matrix.csv")
iM5 <- read_csv("data/iM5.csv")

target<-c("native","native and naturalised")

#match for each state/territory
NT<-filter(final_matrix,NT %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% NT$canonicalName ~ "Yes", T ~ "No"))
NTyes<-filter(match1,Match=="Yes")

Qld<-filter(final_matrix,Qld %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% Qld$canonicalName ~ "Yes", T ~ "No"))
Qldyes<-filter(match1,Match=="Yes")

WA<-filter(final_matrix,WA %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% WA$canonicalName ~ "Yes", T ~ "No"))
WAyes<-filter(match1,Match=="Yes")

ChI<-filter(final_matrix,ChI %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% ChI$canonicalName ~ "Yes", T ~ "No"))
ChIyes<-filter(match1,Match=="Yes")

NSW<-filter(final_matrix,NSW %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% NSW$canonicalName ~ "Yes", T ~ "No"))
NSWyes<-filter(match1,Match=="Yes")

SA<-filter(final_matrix,SA %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% SA$canonicalName ~ "Yes", T ~ "No"))
SAyes<-filter(match1,Match=="Yes")

Vic<-filter(final_matrix,Vic %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% Vic$canonicalName ~ "Yes", T ~ "No"))
Vicyes<-filter(match1,Match=="Yes")

Tas<-filter(final_matrix,Tas %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% Tas$canonicalName ~ "Yes", T ~ "No"))
Tasyes<-filter(match1,Match=="Yes")

ACT<-filter(final_matrix,ACT %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% ACT$canonicalName ~ "Yes", T ~ "No"))
ACTyes<-filter(match1,Match=="Yes")

NI<-filter(final_matrix,NI %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% NI$canonicalName ~ "Yes", T ~ "No"))
NIyes<-filter(match1,Match=="Yes")

LHI<-filter(final_matrix,LHI %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% LHI$canonicalName ~ "Yes", T ~ "No"))
LHIyes<-filter(match1,Match=="Yes")

MI<-filter(final_matrix,MI %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% MI$canonicalName ~ "Yes", T ~ "No"))
MIyes<-filter(match1,Match=="Yes")

HI<-filter(final_matrix,HI %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% HI$canonicalName ~ "Yes", T ~ "No"))
HIyes<-filter(match1,Match=="Yes")

MDI<-filter(final_matrix,MDI %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% MDI$canonicalName ~ "Yes", T ~ "No"))
MDIyes<-filter(match1,Match=="Yes")

CoI<-filter(final_matrix,CoI %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% CoI$canonicalName ~ "Yes", T ~ "No"))
CoIyes<-filter(match1,Match=="Yes")

CSI<-filter(final_matrix,CSI %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% CSI$canonicalName ~ "Yes", T ~ "No"))
CSIyes<-filter(match1,Match=="Yes")

AR<-filter(final_matrix,AR %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% AR$canonicalName ~ "Yes", T ~ "No"))
ARyes<-filter(match1,Match=="Yes")

CaI<-filter(final_matrix,CaI %in% target)
match1<-iM5 %>% mutate (Match = case_when(APC_name %in% CaI$canonicalName ~ "Yes", T ~ "No"))
CaIyes<-filter(match1,Match=="Yes")
