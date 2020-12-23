###### 2 Payers 
###### nb01_2payer
nb01_2payer <- nb01 %>% filter(PAY001 %in% c("Medicaid", "Private insurance"))

ept_count2 <- nb01_2payer %>% group_by(RACE001,ept) %>% tally() 

ept_count2_1 <- ept_count2 %>% filter(ept == 1)
ept_count2_0 <- ept_count2 %>% filter(ept == 0)
ept_count2_1$percentage <- paste(as.character(round(ept_count2_1$n/ept_count2_0$n*100,3)),"%")
ept_count2_1

##########

payer_count2 <- nb01_2payer %>% group_by(PAY001,RACE001) %>% tally() 
payer_count2_p <- payer_count2 %>% filter(PAY001 == "Private insurance")
payer_count2_m <- payer_count2 %>% filter(PAY001 == "Medicaid")
payer_count2_n <- c(payer_count2_p$n + payer_count2_m$n, payer_count2_p$n + payer_count2_m$n)
payer_count2$percentage <- paste(as.character(round(payer_count2$n/payer_count2_n*100,3)),"%")
payer_count2

##########
count2_race <- nb01_2payer %>% group_by(RACE001) %>% tally() 
count2_race_n <- c(rep(count2_race$n[1],4),
                   rep(count2_race$n[2],4),
                   rep(count2_race$n[3],4),
                   rep(count2_race$n[4],4),
                   rep(count2_race$n[5],4))
ses_count2 <- nb01_2payer %>% group_by(RACE001,SES) %>% tally() 
ses_count2$percentage <- paste(as.character(round(ses_count2$n/count2_race_n*100,3)),"%")
ses_count2

##########
region_count2 <- nb01_2payer %>% group_by(RACE001,Region) %>% tally()
region_count2$percentage <- paste(as.character(round(region_count2$n/count2_race_n*100,3)),"%")
region_count2

##########
ept_region_count2 <- nb01_2payer %>% group_by(ept,Region) %>% tally()
region_n <- nb01_2payer %>% group_by(Region) %>% tally()
region_n <- c(region_n$n, region_n$n)
ept_region_count2$percentage <- paste(as.character(round(ept_region_count2$n/region_n*100,3)),"%")
