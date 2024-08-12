library(tidyverse)
library(readxl)

# load the data
load("data/TDvsPTD_nomising_withMIRFIR.RData")

myf0=function(x){ifelse(length(x[!is.na(x)])==0,NA,sum(abs(x[!is.na(x)])))}
ano$Main_Index<- as.character(ano$Main_Index)


ano$ChronicChorioamnionitis_old=ifelse(apply(ano[, c("G1_ST11x","G2_ST12x",
                                                  "G3_ST21x","G4_ST22x","G5_CPIx")],1,myf0)>=1,1,0) 


# Confirm with the data base
pdata<- read_xlsx("data/Cross-sectional.xlsx")
pdata<- pdata %>% 
  mutate(EN_Main_Index=as.character(EN_Main_Index)) %>% 
  filter(EN_Main_Index %in% ano$Main_Index) %>% 
  select("EN_Main_Index","PH_G1_ST11","PH_G2_ST12",
          "PH_G3_ST21","PH_G4_ST22","PH_G5_CPI")
pdata$ChronicChorioamnionitis=ifelse(apply(pdata[, c("PH_G1_ST11","PH_G2_ST12",
                                                          "PH_G3_ST21","PH_G4_ST22","PH_G5_CPI")],1,myf0)>=1,1,0) 



ano<- ano %>% 
  left_join(pdata,
            join_by(Main_Index==EN_Main_Index))


table(ano$ChronicChorioamnionitis_old,ano$ChronicChorioamnionitis)


save(ano,file="results/TDvsPTD_nomising_withMIRFIR_withcca.RData")



# ano %>% 
#   filter(!duplicated(Main_Index)) %>% 
#   select("Main_Index","G1_ST11x","G2_ST12x",
#                       "G3_ST21x","G4_ST22x","G5_CPIx") %>% 
#   filter(Main_Index %in% c("21522","24749","25915"))
#   
# pdata %>% 
#   filter(!duplicated(EN_Main_Index)) %>% 
#   select("EN_Main_Index","PH_G1_ST11","PH_G2_ST12",
#                        "PH_G3_ST21","PH_G4_ST22","PH_G5_CPI") %>% 
#   filter(EN_Main_Index %in% c("21522","24749","25915"))

