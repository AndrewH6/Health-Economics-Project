########## Count Payers
payer_count <- nb01 %>% group_by(PAY001) %>% tally()
payer_count$percent <- payer_count$n/sum(payer_count$n)
payer_count
dim(nb01)
nb01_3payer <- nb01

########## Percentage of extremely preterm by Payers
ept_count <- nb01_3payer %>% group_by(PAY001,ept) %>% tally() 
ept_count_1 <- ept_count %>% filter(ept == 1)
ept_count_0 <- ept_count %>% filter(ept == 0)
ept_count_1$percentage <- paste(as.character(round(ept_count_1$n/ept_count_0$n*100,3)),"%")
ept_count_1

mean_3payer <- nb01_3payer %>%
  group_by(as.factor(PAY001),ept) %>% #as.factor(RACE001),
  summarize(Average_Charge = mean(Charge, na.rm = TRUE),
            Median_Charge = median(Charge, na.rm = TRUE),
            Average_LOS = mean(LOS, na.rm = TRUE),
            Median_LOS = median(LOS, na.rm = TRUE),
            Mortality = paste(round(mean(DIED, na.rm = TRUE)*100,2),"%")   )
print(data.frame(mean_3payer))

########## Percentage of preterm by Payers
pt_count <- nb01_3payer %>% group_by(PAY001,pt) %>% tally() 
pt_count_1 <- pt_count %>% filter(pt == 1)
pt_count_0 <- pt_count %>% filter(pt == 0)
pt_count_1$percentage <- paste(as.character(round(ept_count_1$n/ept_count_0$n*100,3)),"%")
pt_count_1

mean_3payer <- nb01_3payer %>%
  group_by(as.factor(PAY001),pt) %>% #as.factor(RACE001),
  summarize(Average_Charge = mean(Charge, na.rm = TRUE),
            Median_Charge = median(Charge, na.rm = TRUE),
            Average_LOS = mean(LOS, na.rm = TRUE),
            Median_LOS = median(LOS, na.rm = TRUE),
            Mortality = paste(round(mean(DIED, na.rm = TRUE)*100,2),"%")   )
print(data.frame(mean_3payer))


########## Percentage of preterm by Race
pt_count <- nb01_3payer %>% group_by(RACE001,pt) %>% tally() 
pt_count_1 <- pt_count %>% filter(pt == 1)
pt_count_0 <- pt_count %>% filter(pt == 0)
pt_count_1$percentage <- paste(as.character(round(ept_count_1$n/ept_count_0$n*100,3)),"%")
pt_count_1

mean_RACE <- nb01_3payer %>%
  group_by(as.factor(RACE001),pt) %>% #as.factor(RACE001),
  summarize(Average_Charge = mean(Charge, na.rm = TRUE),
            Median_Charge = median(Charge, na.rm = TRUE),
            Average_LOS = mean(LOS, na.rm = TRUE),
            Median_LOS = median(LOS, na.rm = TRUE),
            Mortality = paste(round(mean(DIED, na.rm = TRUE)*100,2),"%"))
print(data.frame(mean_RACE))

mean_RACE_NDXNPR <- nb01_3payer %>%
  group_by(as.factor(RACE001),pt) %>% #as.factor(RACE001),
  summarize(
            Average_NPR = mean(NPR, na.rm = TRUE),
            Median_NPR = median(NPR, na.rm = TRUE),
            Average_NDX = mean(NDX, na.rm = TRUE),
            Median_NDX = median(NDX, na.rm = TRUE))
print(data.frame(mean_RACE_NDXNPR))

aov_race <- aov(NPR ~ RACE001,data = nb_pt)
agricolae::scheffe.test(aov_race,"RACE001", group=TRUE,console=TRUE)

aov_test <- aov(Charge ~ RACE001,data = nb_pt)
agricolae::scheffe.test(aov_test,"RACE001", group=TRUE,console=TRUE)


mean_RACE_all <- nb01_3payer %>%
  group_by(as.factor(RACE001)) %>% #as.factor(RACE001),
  summarize(Average_Charge = mean(Charge, na.rm = TRUE),
            Median_Charge = median(Charge, na.rm = TRUE),
            Average_LOS = mean(LOS, na.rm = TRUE),
            Median_LOS = median(LOS, na.rm = TRUE),
            Mortality = paste(round(mean(DIED, na.rm = TRUE)*100,2),"%")   )
print(data.frame(mean_RACE_all))

aov_race <- aov(LOS ~ RACE001,data = nb_pt)
agricolae::scheffe.test(aov_race,"RACE001", group=TRUE,console=TRUE)

aov_race <- aov(Charge ~ RACE001,data = nb01_3payer)
agricolae::scheffe.test(aov_race,"RACE001", group=TRUE,console=TRUE)

aov_race_LOS <- aov(LOS ~ RACE001,data = nb01_3payer)
agricolae::scheffe.test(aov_race_LOS,"RACE001", group=TRUE,console=TRUE)

ct_rd <- table(nb01_3payer$DIED,nb01_3payer$RACE001)
ct_rd_1 <- ct_rd[,c(2,4)]

chisq.test(ct_rd)
chisq.test(ct_rd_1)
fisher.test(ct_rd_1)
########## Percentage of preterm by DIV
pt_count <- nb01_3payer %>% group_by(DIV,pt) %>% tally() 
pt_count_1 <- pt_count %>% filter(pt == 1)
pt_count_0 <- pt_count %>% filter(pt == 0)
pt_count_1$percentage <- paste(as.character(round(ept_count_1$n/ept_count_0$n*100,3)),"%")
pt_count_1

mean_DIV <- nb01_3payer %>%
  group_by(as.factor(DIV),pt) %>% #as.factor(RACE001),
  summarize(Average_Charge = mean(Charge, na.rm = TRUE),
            Median_Charge = median(Charge, na.rm = TRUE),
            Average_LOS = mean(LOS, na.rm = TRUE),
            Median_LOS = median(LOS, na.rm = TRUE),
            Mortality = paste(round(mean(DIED, na.rm = TRUE)*100,2),"%")   )
print(data.frame(mean_DIV))


########## nb_npt non-preterm

nb_npt <- nb01 %>% filter(pt == 0)
nb_pt <- nb01 %>% filter(pt == 1)

nb_npt_count <- nb01 %>% group_by(PAY001) %>% tally()
nb_npt_count$percent <- nb_npt_count$n/sum(nb_npt_count$n)
nb_npt_count

aov_npt_charge <- aov(Charge ~ PAY001,data = nb_npt)
agricolae::scheffe.test(aov_npt_charge,"PAY001", group=TRUE,console=TRUE)

aov_pt_charge <- aov(Charge ~ PAY001,data = nb_pt)
agricolae::scheffe.test(aov_pt_charge,"PAY001", group=TRUE,console=TRUE)

kruskal.test(Charge ~ PAY001, data = nb_pt) 

nb_pt_2p <- nb_pt %>% filter(PAY001 %in% c("Medicaid","Private insurance"))
wilcox.test(Charge ~ PAY001, data=nb_pt_2p) 

aov_npt_race <- aov(Charge ~ RACE001,data = nb_npt)
agricolae::scheffe.test(aov_npt_race,"RACE001", group=TRUE,console=TRUE)

aov_npt_ses <- aov(Charge ~ SES,data = nb_npt)
agricolae::scheffe.test(aov_npt_ses,"SES", group=TRUE,console=TRUE)

aov_npt_div <- aov(Charge ~ DIV,data = nb_npt)
agricolae::scheffe.test(aov_npt_div,"DIV", group=TRUE,console=TRUE)

kruskal.test(Charge ~ PAY001, data = nb_npt) 
kruskal.test(Charge ~ RACE001, data = nb_npt) 
kruskal.test(Charge ~ SES, data = nb_npt) 
kruskal.test(Charge ~ DIV, data = nb_npt) 


aov_race <- aov(Charge ~ RACE001,data = nb01)
agricolae::scheffe.test(aov_race,"RACE001", group=TRUE,console=TRUE)

aov_payer <- aov(Charge ~ PAY001,data = nb01)
agricolae::scheffe.test(aov_payer,"PAY001", group=TRUE,console=TRUE)

aov_ses <- aov(Charge ~ SES,data = nb01)
agricolae::scheffe.test(aov_ses,"SES", group=TRUE,console=TRUE)

aov_div <- aov(Charge ~ DIV,data = nb01)
agricolae::scheffe.test(aov_div,"DIV", group=TRUE,console=TRUE)