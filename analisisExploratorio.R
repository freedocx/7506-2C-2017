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
dataBA$operation <- NULL
dataBA$place_with_parent_names <- NULL
dataBA$country_name <- NULL
dataBA$lat.lon <- NULL
dataBA$price_aprox_local_currency <- NULL
dataBA$price <- NULL
dataBA$currency <- NULL
dataBA$price_per_m2 <- NULL
dataBA$properati_url <- NULL
##dataBA$description <- NULL
dataBA$image_thumbnail <- NULL
remove(data)

### Analisis de la descripcion y el titulo
dataText <- dataBA[c("description","title")]
dataDes <- as.character(dataText$description)
dataTitle <- as.character(dataText$title)
dataText = as.character(cbind(dataTitle,dataDes))
remove(dataTitle,dataDes)

stopWords <- stopwords("spanish")

dataText = iconv(dataText, from="UTF-8",to="ASCII//TRANSLIT") 
dataText <- tolower(gsub("[^[:alnum:] ]", " ",dataText)) %>%
  removeWords(.,stopWords) %>%
  gsub("[[:digit:]]+", " ",.) %>%
  gsub(" *\\b[[:alpha:]]{1,2}\\b *", " ",.) %>%
  gsub("\\s+", " ",.) %>% as.data.frame(.)

remove(stopWords)

f <- ~ split(., delim = " ", type = "existence")
d1 <- hashed.model.matrix(f, data = dataText, hash.size = 2^27)
d1 <- d1[ , colSums(d1) > 200]





byPlace = dataBA %>%
  group_by(place_with_parent_names,place_name) %>%
  summarise(cantidad = n() )

byStateName = dataBA %>%
  group_by(state_name) %>%
  summarise(cantidad = n() )

byGeonames = dataBA %>%
  group_by(geonames_id) %>%
  summarise(cantidad = n() )

byLatlong = dataBA %>%
  group_by(lat,lon) %>%
  summarise(cantidad = n())

datatest <- dataBA %>% subset(is.na(price_aprox_usd))
datatrain <- dataBA %>% subset(!is.na(price_aprox_usd))





