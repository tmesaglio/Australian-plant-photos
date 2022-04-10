library(tidyverse)
library(stringr)
library(dplyr)

#after the initial iNat run
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


#now check unphotographed numbers after doing iNat, ALA, Florabase, EUCLID and WATTLE (and finding what's missing vs what has been done)

unphotographed<- read_csv("data/unphotographed_inat_ala_florabase_euclid_wattle.csv")
target<-c("native","native and naturalised")


NT<-filter(unphotographed,NT %in% target)

Qld<-filter(unphotographed,Qld %in% target)

WA<-filter(unphotographed,WA %in% target)

ChI<-filter(unphotographed,ChI %in% target)

NSW<-filter(unphotographed,NSW %in% target)

SA<-filter(unphotographed,SA %in% target)

Vic<-filter(unphotographed,Vic %in% target)

Tas<-filter(unphotographed,Tas %in% target)

ACT<-filter(unphotographed,ACT %in% target)

NI<-filter(unphotographed,NI %in% target)

LHI<-filter(unphotographed,LHI %in% target)

MI<-filter(unphotographed,MI %in% target)

HI<-filter(unphotographed,HI %in% target)

MDI<-filter(unphotographed,MDI %in% target)

CoI<-filter(unphotographed,CoI %in% target)

CSI<-filter(unphotographed,CSI %in% target)

AR<-filter(unphotographed,AR %in% target)

CaI<-filter(unphotographed,CaI %in% target)


#now check unphotographed numbers after having also queried the rainforest lucid, tas key, vicflora

unphotographed2<- read_csv("data/unphotographed_all_tas_vic.csv")
target<-c("native","native and naturalised")


NT<-filter(unphotographed2,NT %in% target)

Qld<-filter(unphotographed2,Qld %in% target)

WA<-filter(unphotographed2,WA %in% target)

ChI<-filter(unphotographed2,ChI %in% target)

NSW<-filter(unphotographed2,NSW %in% target)

SA<-filter(unphotographed2,SA %in% target)

Vic<-filter(unphotographed2,Vic %in% target)

Tas<-filter(unphotographed2,Tas %in% target)

ACT<-filter(unphotographed2,ACT %in% target)

NI<-filter(unphotographed2,NI %in% target)

LHI<-filter(unphotographed2,LHI %in% target)

MI<-filter(unphotographed2,MI %in% target)

HI<-filter(unphotographed2,HI %in% target)

MDI<-filter(unphotographed2,MDI %in% target)

CoI<-filter(unphotographed2,CoI %in% target)

CSI<-filter(unphotographed2,CSI %in% target)

AR<-filter(unphotographed2,AR %in% target)

CaI<-filter(unphotographed2,CaI %in% target)


#now check unphotographed numbers after having queried up to ausgrass2


unphotographed3<- read_csv("data/unphotographed_all_grass.csv")
target<-c("native","native and naturalised")


NT<-filter(unphotographed3,NT %in% target)

Qld<-filter(unphotographed3,Qld %in% target)

WA<-filter(unphotographed3,WA %in% target)

ChI<-filter(unphotographed3,ChI %in% target)

NSW<-filter(unphotographed3,NSW %in% target)

SA<-filter(unphotographed3,SA %in% target)

Vic<-filter(unphotographed3,Vic %in% target)

Tas<-filter(unphotographed3,Tas %in% target)

ACT<-filter(unphotographed3,ACT %in% target)

NI<-filter(unphotographed3,NI %in% target)

LHI<-filter(unphotographed3,LHI %in% target)

MI<-filter(unphotographed3,MI %in% target)

HI<-filter(unphotographed3,HI %in% target)

MDI<-filter(unphotographed3,MDI %in% target)

CoI<-filter(unphotographed3,CoI %in% target)

CSI<-filter(unphotographed3,CSI %in% target)

AR<-filter(unphotographed3,AR %in% target)

CaI<-filter(unphotographed3,CaI %in% target)

#check after darwin page

unphotographed4<- read_csv("data/unphotographed_all_darwin.csv")
target<-c("native","native and naturalised")


NT<-filter(unphotographed4,NT %in% target)

Qld<-filter(unphotographed4,Qld %in% target)

WA<-filter(unphotographed4,WA %in% target)

ChI<-filter(unphotographed4,ChI %in% target)

NSW<-filter(unphotographed4,NSW %in% target)

SA<-filter(unphotographed4,SA %in% target)

Vic<-filter(unphotographed4,Vic %in% target)

Tas<-filter(unphotographed4,Tas %in% target)

ACT<-filter(unphotographed4,ACT %in% target)

NI<-filter(unphotographed4,NI %in% target)

LHI<-filter(unphotographed4,LHI %in% target)

MI<-filter(unphotographed4,MI %in% target)

HI<-filter(unphotographed4,HI %in% target)

MDI<-filter(unphotographed4,MDI %in% target)

CoI<-filter(unphotographed4,CoI %in% target)

CSI<-filter(unphotographed4,CSI %in% target)

AR<-filter(unphotographed4,AR %in% target)

CaI<-filter(unphotographed4,CaI %in% target)

#check after orchi encyclopedia

unphotographed5<- read_csv("data/unphotographed_all_orchid_encyclo.csv")
target<-c("native","native and naturalised")


NT<-filter(unphotographed5,NT %in% target)

Qld<-filter(unphotographed5,Qld %in% target)

WA<-filter(unphotographed5,WA %in% target)

ChI<-filter(unphotographed5,ChI %in% target)

NSW<-filter(unphotographed5,NSW %in% target)

SA<-filter(unphotographed5,SA %in% target)

Vic<-filter(unphotographed5,Vic %in% target)

Tas<-filter(unphotographed5,Tas %in% target)

ACT<-filter(unphotographed5,ACT %in% target)

NI<-filter(unphotographed5,NI %in% target)

LHI<-filter(unphotographed5,LHI %in% target)

MI<-filter(unphotographed5,MI %in% target)

HI<-filter(unphotographed5,HI %in% target)

MDI<-filter(unphotographed5,MDI %in% target)

CoI<-filter(unphotographed5,CoI %in% target)

CSI<-filter(unphotographed5,CSI %in% target)

AR<-filter(unphotographed5,AR %in% target)

CaI<-filter(unphotographed5,CaI %in% target)


