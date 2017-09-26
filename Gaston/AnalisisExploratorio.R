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

### Price by month.
sellsByMonth = sellsInBsAsWithPrice[, c(2,9)]
sellsByMonth$create_on_month <- month(sellsByMonth$created_on)

months_list <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")

sellsGroupedByMonth = sellsByMonth %>% 
  group_by(create_on_month) %>%
  summarise(mean_value = mean(price_aprox_usd))
sellsGroupedByMonth$create_on_month_name = months_list[sellsGroupedByMonth$create_on_month]

ggplot(sellsGroupedByMonth, aes(create_on_month_name, mean_value, fill=create_on_month_name), scale = "free") +
  geom_bar(stat = "identity", width = 0.6) +
  xlab("Mes") +
  ylab("Promedio en miles de d??lares") +
  ggtitle("Precio de los inmuebles promedio segun mes de creacion") +
  theme(axis.text.x = element_text(face = "bold", hjust = 0.7, size = 10, angle = 90))

#ggplot(byPlaceName, aes(place_name, promedio, fill = cantidad, label = promedio),scale="free") +
 # geom_bar(stat = "identity",position = "dodge", width=0.6) + 
  
  #TITULOS en los ejes y del plot
  
  #xlab("Localidad") +
  #ylab("Promedio en miles de Dolares") +
  #ggtitle("Localidades seg??n promedio de precio y cantidad de ventas") + 
  
  ##HASTA ACA ES UN PLOT BASICO
  #AGREGO TEMAS
  
  #theme(axis.text.x = element_text(face="bold",hjust = 0.7,size=10,angle=60), 
   #     axis.ticks = element_blank(),
    #    plot.title = element_text(size=16, family="Noto Serif Lao", lineheight=.8, face="bold",hjust = -0.2,
     #                             margin = margin(t = 5, r = 3, b = 20, l = 0)),
      #  axis.line = element_blank(),
       # panel.grid.major = element_blank(),
        #panel.grid.minor = element_blank(),
        #panel.border = element_blank(),
        #panel.background = element_blank(),
        #axis.text.y = element_blank(),
        #axis.title = element_text(size = 11, family="Noto Serif Lao", face = "bold"),
        #legend.title = element_text(face='bold'),
        #axis.title.x = element_text( margin = margin(t = 5, r = -10, b = 4, l = 0))
  #) +
  #scale_fill_gradient(high="#0E3982",low="#D4E4FF", name="N??Publicaciones") + 
  
  # LE AGREGO LOS VALORES EN LA PARTE SUPERIOR DE LA BARRA
  
  #geom_text(data = byPlaceName,
   #         aes(y = promedio), 
    #        vjust = -0.3,
     #       color = "#000066",
      #      fontface = "bold",
       #     size=3.5,
        #    angle = 0,
         #   hjust = 0.5
  #)
