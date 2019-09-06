####Subset del dataset para quedarme con los inmuebles que disponen de latitud y longitud.
install.packages('ggmap')
library(ggmap)

map <- get_googlemap(center = c(-58.55,-34.55),zoom=11,maptype = "roadmap",
               style = c(feature = "all", element = "labels", visibility = "off"))

datatomap <- datatrain %>% subset(!is.na(lat)&!is.na(lon))
datatomap <- datatomap[,c('lat','lon','price_aprox_usd')]
datatomap <- datatomap %>% subset(price_aprox_usd < 1000000)
datatomap$price_aprox_usd <- round(datatomap$price_aprox_usd/1000)
aux = sum(as.numeric(datatomap$price_aprox_usd))
options("scipen"=100, "digits"=4)
ggmap(map) +
  geom_point(data=datatomap, aes(x=lon, y=lat, colour = price_aprox_usd ),
             size = (datatomap$price_aprox_usd*3000)/aux + 0.6,
             alpha =0.3 + (datatomap$price_aprox_usd*160)/aux )  +
  scale_color_gradient(high="#F00000",low="#FFEDED", name="Precio en Miles de Dólares  ") +
  
  ggtitle("Mapa de inmuebles según precio") +
  theme(axis.text.y = element_blank(), 
        axis.ticks = element_blank(),
        plot.title = element_text( size=16, family="Noto Serif Lao", lineheight=.8, face="bold",hjust = 0.5),
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        legend.title = element_text(face='bold'),
        legend.position = "bottom"
  )