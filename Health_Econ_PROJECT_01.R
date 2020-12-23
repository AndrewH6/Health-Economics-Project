library(tidyverse)

########## Setup DATA
corenb <- read.csv("Corenb.csv",header = TRUE)
# nis_data <- read.csv("nis2014.csv",header = TRUE)

########## Check Variables
names(corenb)

########## Select Useful Variables
varlist <- c("TOTCHG","LOS","PAY001","RACE","RACE001","FEMALE001","DIED","DIED001",
             "RDSI","GA","BW","GAC","BWC","GABWC","ZIPINC_QRTL","HOSP_REGION",
             "NPR","NDX","NCHRONIC","HOSP_DIVISION")
nb01 <- corenb %>% dplyr::select(varlist)

########## Fix Charge and LOS and DIED
nb01$Charge <- as.numeric(as.character(nb01$TOTCHG))
nb01 <- nb01[!is.na(nb01$Charge),]
nb01$LOS <- as.numeric(as.character(nb01$LOS))
nb01 <- nb01[!is.na(nb01$LOS),]
nb01$DIED <- as.numeric(as.character(nb01$DIED))
nb01 <- nb01[!is.na(nb01$DIED),]

########## (Extremely) preterm indicator
expt_ind <- (nb01$GA %in% 
               c("01) GA < 24","02) GA = 24","03) GA25-26","04) GA27-28")) |
  (nb01$BW %in%
     c("01) < 500","02) 500 - 749","03) 750 - 999"))

nb01$ept <- 0
nb01[expt_ind,]$ept <- 1

pt_ind <- (nb01$GA %in% 
               c("01) GA < 24","02) GA = 24","03) GA25-26","04) GA27-28",
                 "05) GA29-30","06) GA31-32","07) GA33-34","08) GA35-36")) |
  (nb01$BW %in%
     c("01) < 500","02) 500 - 749","03) 750 - 999","04) 1000-1249","05) 1250-1499",
       "06) 1500-1749","07) 1750-1999","08) 2000-2499"))

nb01$pt <- 0
nb01[pt_ind,]$pt <- 1

nb01$Preterm <- ""
nb01[nb01$pt == 1,"Preterm"] <- "Yes"
nb01[nb01$pt == 0,"Preterm"] <- "No"

########## Race Filter
race_ind <- (nb01$RACE001 %in% 
               c("Asian or Pacific Islander","Black","White","Hispanic","Native American"))
nb01 <- nb01[race_ind,]
nb01$RACE001 <- factor(nb01$RACE001,
                       levels = c("Asian or Pacific Islander","Black",
                                  "White","Hispanic","Native American")) 
########## Race Indicator
nb01$IRC_W <- nb01$IRC_B <- nb01$IRC_H <- nb01$IRC_A <- nb01$IRC_NA <- 0
nb01[nb01$RACE == "1","IRC_W"] <- 1
nb01[nb01$RACE == "2","IRC_B"] <- 1
nb01[nb01$RACE == "3","IRC_H"] <- 1
nb01[nb01$RACE == "4","IRC_A"] <- 1
nb01[nb01$RACE == "5","IRC_NA"] <- 1

########## SES Filter and indicator

nb01 <- nb01 %>% filter(ZIPINC_QRTL %in% c("1","2","3","4"))
nb01$SES <- ""
nb01[nb01$ZIPINC_QRTL == "1","SES"] <- "$1 - 39,999"
nb01[nb01$ZIPINC_QRTL == "2","SES"] <- "$40,000 - 50,999"
nb01[nb01$ZIPINC_QRTL == "3","SES"] <- "$51,000 - 65,999"
nb01[nb01$ZIPINC_QRTL == "4","SES"] <- "$66,000+"

nb01$ISES <- 0
nb01[nb01$ZIPINC_QRTL == "4","ISES"] <- 1

nb01$ZIPINC_QRTL1 <- as.numeric(as.character(nb01$ZIPINC_QRTL))
########## Region Filter
nb01 <- nb01 %>% filter(HOSP_REGION %in% c("1","2","3","4"))
nb01$Region <- ""
nb01[nb01$HOSP_REGION == "1","Region"] <- "Northeast"
nb01[nb01$HOSP_REGION == "2","Region"] <- "Midwest"
nb01[nb01$HOSP_REGION == "3","Region"] <- "South"
nb01[nb01$HOSP_REGION == "4","Region"] <- "West"

########## Indicator Region
nb01$IRMW <- nb01$IRNE <- nb01$IRS <- nb01$IRW <- 0
nb01[nb01$HOSP_REGION == "1","IRNE"] <- 1
nb01[nb01$HOSP_REGION == "2","IRMW"] <- 1
nb01[nb01$HOSP_REGION == "3","IRS"] <- 1
nb01[nb01$HOSP_REGION == "4","IRW"] <- 1

nb01$ID_NE <- nb01$ID_MA <- nb01$ID_ENC <- nb01$ID_WNC <- 
  nb01$ID_SA <- nb01$ID_ESC <- nb01$ID_WSC <- nb01$ID_MT <-
  nb01$ID_PC <- 0
nb01[nb01$HOSP_DIVISION == "1","ID_NE"] <- 1
nb01[nb01$HOSP_DIVISION == "2","ID_MA"] <- 1
nb01[nb01$HOSP_DIVISION == "3","ID_ENC"] <- 1
nb01[nb01$HOSP_DIVISION == "4","ID_WNC"] <- 1
nb01[nb01$HOSP_DIVISION == "5","ID_SA"] <- 1
nb01[nb01$HOSP_DIVISION == "6","ID_ESC"] <- 1
nb01[nb01$HOSP_DIVISION == "7","ID_WSC"] <- 1
nb01[nb01$HOSP_DIVISION == "8","ID_MT"] <- 1
nb01[nb01$HOSP_DIVISION == "9","ID_PC"] <- 1

nb01$DIV <- ""
nb01[nb01$HOSP_DIVISION == "1","DIV"] <- "New England"
nb01[nb01$HOSP_DIVISION == "2","DIV"] <- "Middle Atlantic"
nb01[nb01$HOSP_DIVISION == "3","DIV"] <- "East North Central"
nb01[nb01$HOSP_DIVISION == "4","DIV"] <- "West North Central"
nb01[nb01$HOSP_DIVISION == "5","DIV"] <- "South Atlantic"
nb01[nb01$HOSP_DIVISION == "6","DIV"] <- "East South Central"
nb01[nb01$HOSP_DIVISION == "7","DIV"] <- "West South Central"
nb01[nb01$HOSP_DIVISION == "8","DIV"] <- "Mountain"
nb01[nb01$HOSP_DIVISION == "9","DIV"] <- "Pacific"

nb01$HOSP_DIV <- ""
nb01[nb01$HOSP_DIVISION == "1","HOSP_DIV"] <- "NE"
nb01[nb01$HOSP_DIVISION == "2","HOSP_DIV"] <- "MA"
nb01[nb01$HOSP_DIVISION == "3","HOSP_DIV"] <- "ENC"
nb01[nb01$HOSP_DIVISION == "4","HOSP_DIV"] <- "WNC"
nb01[nb01$HOSP_DIVISION == "5","HOSP_DIV"] <- "SA"
nb01[nb01$HOSP_DIVISION == "6","HOSP_DIV"] <- "ESC"
nb01[nb01$HOSP_DIVISION == "7","HOSP_DIV"] <- "WSC"
nb01[nb01$HOSP_DIVISION == "8","HOSP_DIV"] <- "MT"
nb01[nb01$HOSP_DIVISION == "9","HOSP_DIV"] <- "PC"

# "ID_NE","ID_MA","ID_ENC","ID_WNC","ID_SA","ID_ESC","ID_WSC","ID_MT","ID_PC"

########## Payer Filter
nb01 <- nb01 %>% filter(PAY001 %in% c("Medicaid","Private insurance","Self-pay"))
nb01$PYM <- nb01$PYP <- 0
nb01[nb01$PAY001 == "Medicaid","PYM"] <- 1
nb01[nb01$PAY001 == "Private insurance","PYP"] <- 1

nb01$PAY002 <- ""
nb01[nb01$PAY001 == "Medicaid","PAY002"] <- "Medicaid"
nb01[nb01$PAY001 == "Private insurance","PAY002"] <- "Private insurance"
nb01[nb01$PAY001 == "Self-pay","PAY002"] <- "Self-pay"
####################
nb_npt <- nb01 %>% filter(pt == 0)
nb_pt <- nb01 %>% filter(pt == 1)
dim(nb01)






