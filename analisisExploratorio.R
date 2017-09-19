###########  ANALISIS EXPLORATORIO  #################

### Designando directorio de trabajo
setwd("~/Documents/orgadedatos") 

### Cargando paquetes necesarios

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

data <- read.csv("Propiedades-0701.csv",header = TRUE, fileEncoding = "UTF-8" )

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
dataBA$created_on <- dataBA$description <- dataBA$title <- dataBA$geonames_id<- NULL
remove(data)

datatest <- dataBA %>% subset(is.na(price_aprox_usd))
datatrain <- dataBA %>% subset(!is.na(price_aprox_usd))

datatest$price_aprox_usd <- NULL
datatrain$price_aprox_usd <- as.integer(datatrain$price_aprox_usd)



