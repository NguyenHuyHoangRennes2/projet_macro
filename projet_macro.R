
library(devtools)
install_github("taceconomics/taceconomics-r")
library(taceconomics)
library(reshape2)
taceconomics.apikey('sk_XwT_a_FqvIjhznM_qw1p1mu6-N1Fur8GqxKq7LbSF04')

#1) 
#broad money
date_fin <-as.Date("2018-04-01") 
date_début <- as.Date("1997-09-01")
broad_money <- taceconomics.api(sprintf("data/search?q=%s", "money"))$data
broad_money <- getdata('IFS/FDSBC_EUR_M/EUZ')
broad_money <- data.frame(broad_money$'IFS/FDSBC_EUR_M/EUZ')
row.names(broad_money) <- as.Date(row.names(broad_money))
broad_money <-broad_money[(row.names(broad_money) >= date_début) & (row.names(broad_money) <= date_fin) ,]

#industrial production
ind_prod <- taceconomics.api(sprintf("data/search?q=%s", "industrial"))$data
ind_prod <- getdata("IFS/AIP_SA_IX_M/EUZ")
ind_prod <- data.frame(ind_prod)
row.names(ind_prod) <- as.Date(row.names(ind_prod))
ind_prod <-ind_prod[(row.names(ind_prod) >= date_début) & (row.names(ind_prod) <= date_fin) ,]

#Remarque : car ind_prod et broad_money ne sont pas dans la période , donc on a du modifier pour il soit dans le même peride
#           01/09/1997 - 01/04/2018
data <-data.frame("Date" = seq(date_début , date_fin ,by= "month" ) ,"Broad money" = broad_money , "Industrial production" = ind_prod)
#supprimer les lignes NA
data <- na.omit(data)
#calculer le taux de croissance du masse monnétaire et de la production industrielle
TC_broad_money <- rep(NA , length(data$Broad.money)) 
TC_indus_prod <- rep(NA,length(data$Industrial.production))
for(i in 2:nrow(data)){
  TC_broad_money[i] <-(data$Broad.money[i]-data$Broad.money[i-1])/data$Broad.money[i-1]
  TC_indus_prod[i] <- (data$Industrial.production[i]-data$Industrial.production[i-1])/data$Industrial.production[i-1]
}
data<- cbind(data ,"Taux de croissance du masse monnétaire" = round(TC_broad_money , digits =4) , "Taux de croissance de la production industrielle " = round(TC_indus_prod),digits=4)
