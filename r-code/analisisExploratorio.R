###########  ANALISIS EXPLORATORIO  #################

### Designando directorio de trabajo
setwd("~/Documents/orgadedatos") 

### Cargando paquetes necesarios
options("scipen"=100, "digits"=4)
library(lubridate)
library(plyr)
library(dplyr)
library(ggplot2)
library(data.table)
library(Matrix)
library(FeatureHashing)
library(tm)
library(SnowballC)
library(wordcloud)
library(reshape2)

### Cargando set de datos

temp = list.files(pattern="*.csv")
for (i in 1:length(temp)) assign(temp[i], read.csv(temp[i], header = TRUE, fileEncoding = "UTF-8"))

data <- rbind(`properati-AR-2016-01-01-properties-sell.csv`,
              `properati-AR-2016-02-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2016-03-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2016-04-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2016-05-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2016-06-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2016-07-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2016-08-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2016-10-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2016-11-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2016-12-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2017-01-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2017-03-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2017-05-01-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2017-06-06-properties-sell.csv`) %>%
  rbind(. , `properati-AR-2017-07-03-properties-sell.csv`)

data <- data[!duplicated(data$id), ]

write.csv(data, file = "alldata.csv",row.names = FALSE)
data <- read.csv(file = "alldata.csv", header = TRUE, fileEncoding = "UTF-8")

dim(data)

### Subset del set de datos para quedarse solamente con
### los inmuebles que estan en CABA y GBA.

dataBA = data %>% subset(state_name == "Bs.As. G.B.A. Zona Norte" | 
                         state_name == "Bs.As. G.B.A. Zona Sur" |
                         state_name == "Bs.As. G.B.A. Zona Oeste" |
                         state_name == "Capital Federal")

### Removiendo las columnas del set de datos que no aportan informacion util
dataBA$operation <- dataBA$place_with_parent_names <- dataBA$country_name <- dataBA$lat.lon <- NULL
dataBA$price_aprox_local_currency <- dataBA$price <- dataBA$currency <- dataBA$price_per_m2 <- NULL
dataBA$properati_url <- dataBA$image_thumbnail <- NULL 
dataBA$created_on <- dataBA$geonames_id<- NULL
remove(data)

datatest <- dataBA %>% subset(is.na(price_aprox_usd) | price_aprox_usd == 0)
datatrain <- dataBA %>% subset(!(is.na(price_aprox_usd) | price_aprox_usd == 0))

datatest$price_aprox_usd <- NULL
datatrain$price_aprox_usd <- as.integer(datatrain$price_aprox_usd)

#############################################


