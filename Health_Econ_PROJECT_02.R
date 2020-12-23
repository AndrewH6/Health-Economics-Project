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

##########

mean_SES <- nb01_3payer %>%
  group_by(as.factor(SES), pt) %>% #as.factor(RACE001),
  summarize(Average_Charge = mean(Charge, na.rm = TRUE),
            Median_Charge = median(Charge, na.rm = TRUE),
            Average_LOS = mean(LOS, na.rm = TRUE),
            Median_LOS = median(LOS, na.rm = TRUE),
            Mortality = paste(round(mean(DIED, na.rm = TRUE)*100,2),"%"),
            Average_NPR = mean(NPR, na.rm = TRUE),
            Median_NPR = median(NPR, na.rm = TRUE),
            Average_NDX = mean(NDX, na.rm = TRUE),
            Median_NDX = median(NDX, na.rm = TRUE))
print(data.frame(mean_SES))

aov_npt_SES_NDX <- aov(NDX ~ SES ,data = nb_npt)
agricolae::scheffe.test(aov_npt_SES_NDX,"SES", group=TRUE,console=TRUE)

aov_pt_SES_NDX <- aov(NDX ~ SES ,data = nb_pt)
agricolae::scheffe.test(aov_pt_SES_NDX,"SES", group=TRUE,console=TRUE)

aov_pt_SES_Charge <- aov(Charge ~ SES ,data = nb_pt)
agricolae::scheffe.test(aov_pt_SES_Charge,"SES", group=TRUE,console=TRUE)

aov_npt_SES_NPR <- aov(NPR ~ SES ,data = nb_npt)
agricolae::scheffe.test(aov_npt_SES_NPR,"SES", group=TRUE,console=TRUE)

aov_pt_SES_NPR <- aov(NPR ~ SES ,data = nb_pt)
agricolae::scheffe.test(aov_pt_SES_NPR,"SES", group=TRUE,console=TRUE)

aov_npt_SES_LOS <- aov(LOS ~ SES ,data = nb_npt)
agricolae::scheffe.test(aov_npt_SES_LOS,"SES", group=TRUE,console=TRUE)

aov_pt_SES_LOS <- aov(LOS ~ SES ,data = nb_pt)
agricolae::scheffe.test(aov_pt_SES_LOS,"SES", group=TRUE,console=TRUE)

kruskal.test(Charge ~ SES, data = nb_pt) 

nb_pt_2ses <- nb_pt %>% filter(SES %in% c("$66,000+","$51,000 - 65,999"))
wilcox.test(Charge ~ SES, data=nb_pt_2ses)

mean_SES_all <- nb01_3payer %>%
  group_by(as.factor(SES)) %>% #as.factor(RACE001),
  summarize(Average_Charge = mean(Charge, na.rm = TRUE),
            Median_Charge = median(Charge, na.rm = TRUE),
            Average_LOS = mean(LOS, na.rm = TRUE),
            Median_LOS = median(LOS, na.rm = TRUE),
            Mortality = paste(round(mean(DIED, na.rm = TRUE)*100,2),"%"),
            Average_NPR = mean(NPR, na.rm = TRUE),
            Median_NPR = median(NPR, na.rm = TRUE),
            Average_NDX = mean(NDX, na.rm = TRUE),
            Median_NDX = median(NDX, na.rm = TRUE))
print(data.frame(mean_SES_all))

SES_D <- table(nb01_3payer$DIED,nb01_3payer$SES)
mantelhaen.test(SES_D)
chisq.test(SES_D)