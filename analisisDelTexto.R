### Analisis de la descripcion y el titulo

dataText <- datatrain[c("description","title","price_aprox_usd")]
dataText$texto = paste(dataText$description,dataText$title, sep = " ")
dataText$description<-NULL
dataText$title<-NULL

dataText$texto = iconv(dataText$texto, from="UTF-8",to="ASCII//TRANSLIT") 

#############hasta aca esta el dataset sin procesamiento de texto
save.image("~/Documents/orgadedatos/data1.RData")

dataText$texto <- tolower(gsub("[^[:alnum:] ]", " ",dataText$texto)) %>%
  removeWords(.,stopwords("spanish")) %>%
  gsub("[[:digit:]]+", " ",.) %>%
  gsub(" *\\b[[:alpha:]]{1,2}\\b *", " ",.) %>%
  gsub("\\s+", " ",.) %>% as.character(.)

save.image("~/Documents/orgadedatos/data1.RData")
#############Hasta aca tengo el dataText con las descripciones y titulos limpios.
#############WordCloud
aux <- as.data.frame(dataText$price_aprox_usd)
colnames(aux)[1] <- "price"

f <- ~ split(texto, delim = " ", type = "existence")

d1 <- hashed.model.matrix( f,
                           data = dataText, hash.size = 2^24,
                           create.mapping = T)

mapp <- as.data.frame(hash.mapping(d1))
colnames(mapp)[1] <- "hash"
mapp$name <-gsub('^.....', '', rownames(mapp))
rownames(mapp) <- NULL

save.image("~/Documents/orgadedatos/data1.RData")

d1 <- d1[ , colSums(d1) > 700]

d1d <- as.data.frame((as.matrix(d1)))
d1d <- d1d[,-1]

names(d1d) <- mapp$name[match(names(d1d), mapp$hash)]
d1d <- cbind(aux,d1d)
aux$price <- as.integer(aux$price)

remove(f,mapp,dataText,d1)

#d1d = t(aux)*d1d
#d1d <- d1d %>% subset(price < 15000000)

df_melt <- melt(d1d,id = "price")
df_melt <- df_melt %>% subset(value == 1)
df_melt <- df_melt[,-3]

byName = df_melt %>%
  group_by(.,variable) %>%
  summarise(promedio = mean(price) )
#set.seed(312)
byName$promedio <- round(byName$promedio/1000)
