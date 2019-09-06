###### PARA HACER UN PLOT SIMPLE: 
## BARPLOT: ggplot(dataset, aes(x,y)) + geom_bar(stat = "identity")
## para otros plots: http://ggplot2.tidyverse.org/reference/
#library(extrafont)

##PLOT
boedo = datatrain %>%
  subset(place_name == "Boedo") %>% group_by(id)
boedo$price_aprox_usd = round(boedo$price_aprox_usd/1000)

ggplot(boedo, aes(x = id, price_aprox_usd, label = price_aprox_usd),scale="free") +
  geom_point(colour = "#5A5DFA") + 
  
  #TITULOS en los ejes y del plot
  
  xlab("Inmuebles") +
  ylab("Precio en miles de dólares") +
  ggtitle("Precios en Boedo") + 
  
  ##HASTA ACA ES UN PLOT BASICO
  #AGREGO TEMAS
  
  theme(axis.text.x = element_blank(), 
        axis.ticks = element_blank(),
        plot.title = element_text(size=16, family="Noto Serif Lao", lineheight=.8, face="bold",hjust = 0.5,
                                  margin = margin(t = 0, r = 0, b = 30, l = 0)),
        axis.line = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.text.y = element_blank(),
        axis.title = element_text(size = 11, family="Noto Serif Lao", face = "bold"),
        legend.title = element_text(face='bold'),
        axis.title.x = element_text( margin = margin(t = 5, r = -10, b = 4, l = 0))
    ) + 
    # LE AGREGO LOS VALORES EN LA PARTE SUPERIOR DE LA BARRA
  
  geom_text(data = subset(boedo,boedo$price_aprox_usd>1200),
            aes(y = price_aprox_usd), 
            vjust = -0.5,
            color = "#000066",
            fontface = "bold",
            size=4,
            angle = 0,
            hjust = 0.5
  ) + 
  geom_hline(yintercept = mean(boedo$price_aprox_usd), color = "#F71E1E")
  

