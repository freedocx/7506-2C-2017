setwd("~/Documents/orgadedatos") 

library(data.table)
library(Matrix)
library(FeatureHashing)
library(tm)
library(SnowballC)
library(wordcloud)

dataText <- datatrain[c("description","title","price_aprox_usd")]
dataText$texto = paste(dataText$description,dataText$title, sep = " ")
dataText$description<-NULL
dataText$title<-NULL

dataText$texto = iconv(dataText$texto, from="UTF-8",to="ASCII//TRANSLIT") 


dataText$texto <- tolower(gsub("[^[:alnum:] ]", " ",dataText$texto)) %>%
  removeWords(.,stopwords("spanish")) %>%
  gsub("[[:digit:]]+", " ",.) %>%
  gsub(" *\\b[[:alpha:]]{1,2}\\b *", " ",.) %>%
  gsub("\\s+", " ",.) %>% as.character(.)

dataText1 <- dataText %>% subset(price_aprox_usd < 50000)
dataText1$price_aprox_usd <- NULL
colnames(dataText1)[1] <- "texto"
dataText2 <- dataText %>% subset(price_aprox_usd >= 50000 & price_aprox_usd <80000)
dataText2$price_aprox_usd <- NULL
colnames(dataText2)[1] <- "texto"
dataText3 <- dataText %>% subset(price_aprox_usd >= 80000 & price_aprox_usd <115000)
dataText3$price_aprox_usd <- NULL
colnames(dataText3)[1] <- "texto"
dataText4 <- dataText %>% subset(price_aprox_usd >= 115000 & price_aprox_usd <150000)
dataText4$price_aprox_usd <- NULL
colnames(dataText4)[1] <- "texto"
dataText5 <- dataText %>% subset(price_aprox_usd >= 150000 & price_aprox_usd <200000)
dataText5$price_aprox_usd <- NULL
colnames(dataText5)[1] <- "texto"
dataText6 <- dataText %>% subset(price_aprox_usd > 200000)
dataText6$price_aprox_usd <- NULL
colnames(dataText6)[1] <- "texto"


f <- ~ split(texto, delim = " ", type = "existence")

###############################################################################################

#EN LA VARIABLE dataText cambiar el nombre segun que segmento de precio se quiera analizar.#

d1 <- hashed.model.matrix( f,
                           data = dataText6, hash.size = 2^24,
                           create.mapping = T)

###############################################################################################

mapp <- as.data.frame(hash.mapping(d1))
colnames(mapp)[1] <- "hash"
mapp$name <-gsub('^.....', '', rownames(mapp))
rownames(mapp) <- NULL

d1 <- d1[ , colSums(d1) > 50]

d1d <- as.data.frame(colSums(as.matrix(d1)))
colnames(d1d)[1] <- "cantidad"
d1d$hash <- rownames(d1d)
rownames(d1d) <- NULL
d1d <- d1d[-1,]

aver = join(d1d, mapp, by = "hash","left")

aver$hash <- NULL

aver<-aver[!(aver$name=="departamento" |
               aver$name=="venta" |
               aver$name=="cocina" |
               aver$name=="bano" |
               aver$name=="null" |
               aver$name=="ambientes" |
               aver$name=="ambiente"  |
               aver$name=="dormitorios" |
               aver$name=="dormitorio" |
               aver$name=="comedor" |
               aver$name=="living" |
               aver$name=="completo"),]

set.seed(1214)
wordcloud(words = aver$name, freq = aver$cantidad, min.freq = 10,
          max.words=300, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))