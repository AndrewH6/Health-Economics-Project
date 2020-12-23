library(tidyverse)
# install.packages("caret")
library(caret)
# install.packages("glmnet")
library(glmnet)
library(MASS)
library(FactoMineR)
# install.packages("ggfortify")
library(ggfortify)
library(ggplot2)
# install.packages("factoextra")
library(factoextra)

nb01_reg <- nb01[,c("Charge","LOS", "ept",
                    "DIED001","NPR","NDX",
                    "IRC_NA","IRC_A","IRC_H","IRC_B","IRC_W",
                    "ID_NE","ID_MA","ID_ENC","ID_WNC","ID_SA",
                    "ID_ESC","ID_WSC","ID_MT","ID_PC",
                    "RDSI",
                    "PYM","PYP")]

# "IRW","IRS","IRNE","IRMW"

nb01_reg <- nb01_reg %>% filter(DIED001 == "Did not die")
nb01_reg$y <- nb01_reg$Charge

nb01_pca <- nb01_reg %>% dplyr::select(-c(DIED001,y))
nb01_pca1 <- nb01_pca %>% filter(Charge <= 20000)

dim(nb01_pca1)
#nb01_pca$Charge <- log(nb01_reg$Charge)

index1 <- sample(dim(nb01_pca1)[1], 1000, replace = FALSE)
nb01_pca2 <- nb01_pca1[index1,]
pca_nb <- princomp(nb01_pca1, cor = T)
pca_nb
summary(pca_nb, loadings = T)
PCA(nb01_pca1, scale.unit = TRUE, ncp = 5)
screeplot(pca_nb, type = "lines")

mtcars.pca <- prcomp(nb01_pca1, center = TRUE,scale. = TRUE)
summary(mtcars.pca)
fviz_pca_ind(mtcars.pca,
             col.ind = "cos2", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

fviz_pca_var(mtcars.pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)



fviz_pca_biplot(mtcars.pca, repel = TRUE,
                col.var = "#2E9FDF", # Variables color
                col.ind = "#696969"  # Individuals color
)
summary(mtcars.pca)


autoplot(prcomp(nb01_pca1))
  