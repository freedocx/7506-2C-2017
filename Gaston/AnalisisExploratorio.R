###########  ANALISIS EXPLORATORIO  #################

### Workspace location.
setwd("~/Projects/7506-2C-2017/Gaston") 

### Installing libraries.
#install.packages("lubridate")
#install.packages("plyr")
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("data.table")
#install.packages("Matrix")
#install.packages("FeatureHashing")
#install.packages("tm")
#install.packages("SnowballC")
#install.packages("wordcloud")
#install.packages("reshape2")

### Load libraries.
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

### Load data.
sellsData <- read.csv(file="Properati-Data.csv", header=TRUE, sep=",")

### Filtered data.

### Filter properties not located in Bs. As. or in Gran Bs. As.
sellsInBsAs = sellsData %>% subset(state_name == "Bs.As. G.B.A. Zona Norte" | 
                                     state_name == "Bs.As. G.B.A. Zona Sur" |
                                     state_name == "Bs.As. G.B.A. Zona Oeste" |
                                     state_name == "Capital Federal")

### Filter rows with NaN values or <= 0 values in price.
sellsInBsAsWithPrice <- sellsInBsAs %>% subset(!(is.na(price_aprox_usd) | price_aprox_usd == 0))

### Columns selection, delete unused columns.
sellsInBsAsWithPrice$operation <- NULL
sellsInBsAsWithPrice$place_with_parent_names <- NULL
sellsInBsAsWithPrice$country_name <- NULL
sellsInBsAsWithPrice$lat.lon <- NULL
sellsInBsAsWithPrice$price <- NULL
sellsInBsAsWithPrice$currency <- NULL
sellsInBsAsWithPrice$price_aprox_local_currency <- NULL
sellsInBsAsWithPrice$price_per_m2 <- NULL
sellsInBsAsWithPrice$properati_url <- NULL
sellsInBsAsWithPrice$image_thumbnail <- NULL

### Dataset texts formmating.
dataText <- sellsInBsAsWithPrice[c("description","title")]
dataText$text = paste(dataText$description,dataText$title, sep = " ")
dataText$text <- tolower(gsub("[^[:alnum:] ]", " ",dataText$text)) %>%
 	 removeWords(.,stopwords("spanish")) %>%
  	gsub("[[:digit:]]+", " ",.) %>%
  	gsub(" *\\b[[:alpha:]]{1,2}\\b *", " ",.) %>%
 	 gsub("\\s+", " ",.) %>% as.character(.)
sellsInBsAsWithPrice$text <- dataText$text
sellsInBsAsWithPrice$title <- NULL
sellsInBsAsWithPrice$description <- NULL


