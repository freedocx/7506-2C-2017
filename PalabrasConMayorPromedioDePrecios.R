###### PARA HACER UN PLOT SIMPLE: 
## BARPLOT: ggplot(dataset, aes(x,y)) + geom_bar(stat = "identity")
## para otros plots: http://ggplot2.tidyverse.org/reference/
#library(extrafont)
## + 1000 ocurrencias
byName <- byName %>% subset(.,promedio>450)
byName$variable <- toupper(byName$variable)
byName$variable <- factor(byName$variable, levels = byName$variable[order(byName$promedio)])
toaxis  = subset(byName,byName$promedio> 450)
toaxis$promedio <- round(toaxis$promedio)
auxAxis = t(as.vector(toaxis[1]))


##PLOT

ggplot(byName, aes(variable, promedio, label = promedio),scale="free") +
  geom_bar(stat = "identity",position = "dodge", color = "#FFFFFF", fill = "#99CCFF") +
  
  #TITULOS en los ejes y del plot
  
  xlab("Palabras") +
  ylab("Promedio de precios en miles de Dolares") +
  ggtitle("Palabras con mayor promedio de precios") + 
  
  ##HASTA ACA ES UN PLOT BASICO
  #AGREGO TEMAS
  
  theme(axis.text.x = element_blank(), 
        axis.ticks = element_blank(),
        plot.title = element_text(size=16, family="Noto Serif Lao", lineheight=.8, face="bold",hjust = 0.5,
                                  margin = margin(t = 5, r = -10, b = 30, l = 0)),
        axis.line = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.text.y = element_text(hjust = 0, angle = 0, 
                                   vjust = 0.5, size = 11 ,
                                   face="bold",color = "#330066",
                                   margin = margin(t = 0, r = -150, b = 0, l = 20)),
        axis.title = element_text(size = 11, family="Noto Serif Lao", face = "bold"),
        axis.title.y = element_text(margin = margin(t = 0, r = 30, b = 0, l = 0))
  ) +
  
  # Ajusto los labels que aparecen en el eje X
  
  scale_x_discrete(breaks = auxAxis) + 
  
  # LE AGREGO LOS VALORES EN LA PARTE SUPERIOR DE LA BARRA
  
  geom_text(data = toaxis,
            aes(y = promedio), 
            vjust = 0.5,
            color = "#330066",
            fontface = "bold",
            size=3.3,
            angle = 0,
            hjust = 1.2
  ) + coord_flip()
