###### PARA HACER UN PLOT SIMPLE: 
## BARPLOT: ggplot(dataset, aes(x,y)) + geom_bar(stat = "identity")
## para otros plots: http://ggplot2.tidyverse.org/reference/
#library(extrafont)

##PLOT

byProperty = datatrain %>%
  group_by(property_type) %>%
  summarise(promedio = mean(price_aprox_usd))

byPropertyC = datatrain %>%
  group_by(property_type) %>%
  summarise(cantidad = n())

byProperty$cantidad <- byPropertyC$cantidad
byProperty$promedio <- round(byProperty$promedio/1000)

ggplot(byProperty, aes(property_type, promedio, fill = cantidad, label = promedio),scale="free") +
  geom_bar(stat = "identity",position = "dodge", width=0.3) + 
  
  #TITULOS en los ejes y del plot
  
  xlab("Tipo de inmueble") +
  ylab("Promedio en miles de Dolares") +
  ggtitle("Tipos de inmueble según promedio de precio y cantidad de ventas") + 
  
  ##HASTA ACA ES UN PLOT BASICO
  #AGREGO TEMAS
  
  theme(axis.text.x = element_text(face="bold",hjust = 0.5,size=10), 
        axis.ticks = element_blank(),
        plot.title = element_text(size=16, family="Noto Serif Lao", lineheight=.8, face="bold",hjust = -0.2,
                                  margin = margin(t = 5, r = 0, b = 20, l = 0)),
        axis.line = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.text.y = element_blank(),
        axis.title = element_text(size = 11, family="Noto Serif Lao", face = "bold"),
        legend.title = element_text(face='bold'),
        axis.title.x = element_text( margin = margin(t = 20, r = -10, b = 4, l = 0))
    ) +
  scale_fill_gradient(high="#0E3982",low="#D4E4FF", name="N°Publicaciones") + 
  
    # LE AGREGO LOS VALORES EN LA PARTE SUPERIOR DE LA BARRA
  
  geom_text(data = byProperty,
            aes(y = promedio), 
            vjust = -0.3,
            color = "#000066",
            fontface = "bold",
            size=4,
            angle = 0,
            hjust = 0.5
  )
