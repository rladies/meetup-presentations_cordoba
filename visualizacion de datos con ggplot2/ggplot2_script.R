

#  set de datos de diamantes
#Scatter plot de price (precio en dólares) vs carat (peso de los diamantes)



library(ggplot2)
str(diamonds)
#data frame con las primers 1000 filas del set de datos de diamantes
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
str(dsamp)
#paso a paso como se construye un grafico
#datos
ggplot(data = dsamp)

#datos y mapeos esteticos
ggplot(data = dsamp, aes(x = carat, y = price, colour = cut))

ggplot(data = dsamp, aes(x = carat, y = price, colour = cut)) + 
  geom_point( alpha = 1/3) 

#datos mapeo estetico +geom + uso de escalas
ggplot(data = dsamp, aes(x = carat, y = price, colour = cut)) + 
  geom_point( alpha = 1/3) +scale_y_log10() +scale_x_log10()

#ahora cambiando nombres a las variables, titulo
ggplot(data = dsamp, aes(x = carat, y = price, colour = cut)) + 
  geom_point( alpha = 1/3) + labs(x = "Peso", y = "Precio en dólares",
                                  title = "Scatterplot precio vs pesos",
                                  colour="Corte") 
# por que en el grafico anterior en la leyenda los tipos de corte siguen en ingles??


#con <- guardamos el objeto
gg1 <- ggplot(data = dsamp, aes(x = carat, y = price, colour = cut)) + 
  geom_point() + labs(x = "Peso", y = "Precio en dólares",
                                  title = "Scatterplot precio vs pesos",
                                  colour="Corte") 



# viendo los ultimos  graficos, que es alpha???

gg1 + facet_wrap( ~ cut, ncol=3)  # columna definida por 'cut'

# el siguiente grafico demora un poco mas de tiempo
gg1 + facet_wrap(color ~ cut)  # fila: color, columna: cut

#como agregar dos geoms 
#aca vemos como se pueden agregar capas
# que datos utilizan los geoms?
ggplot(dsamp, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() 


# Asi que agregamos dos capas (geoms) a este grafico: geom_point() y geom_smooth().
#Debido a que el eje x, y y el color estan en la funcion ggplot los geoms "heredaron" esas esteticas, sino se puede especificar dentro de la capa geom, como en los ejemplos a continuacion

  
  
ggplot(dsamp) + geom_point(aes(x=carat, y=price, color=cut)) + geom_smooth(aes(x=carat, y=price))  


ggplot(dsamp) + geom_point(aes(x=carat, y=price, color=cut)) + geom_smooth(aes(x=carat, y=price,color=cut)) 


#ejemplos del libro de Hadley de ggplot2
# Para crear un grafico de dispersion usando mpg que incluya el tamaño del motor
# (displ) en el eje de las x y cantidad de millas por galon (hwy) en el eje de 
# las y

str(mpg)
#plot simple de mtcars
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))



#como hacer para que todos los puntos tengan el mismo color
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")


#que similitudes tienen los siguiente dos graficos
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
#esto
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

# Usando colores para identificar las distintas clases de vehiculos (class)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()
#
#como cambiar los colores de los puntos
library(ggsci)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + scale_color_futurama()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy,color = class)) + 
  geom_point() + scale_color_npg()
  

# Que pasa si se usa la variable cty (variable continua) para el atributo estetico 
# color? El codigo para eso es:

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = cty))


#que ocurre en este grafico??
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
#agregar en el grafico anterior color= class

#bar plot
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut)) 
# que es count?


# A veces queremos hacer un grafico a partir
# de una tabla de doble entrada (dos categorias)
# por ejemplo nos interesa cut y clarity de los diamantes

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))


ggplot(data = diamonds,aes(x = cut, fill = clarity))+
  geom_bar(position = "dodge")


ggplot(data = diamonds,aes(x = cut, fill = clarity))+
  geom_bar(position = "dodge") +facet_wrap(. ~ clarity)

p1 <- ggplot(data = diamonds,aes(x = cut, fill = clarity))+
  geom_bar(position = "dodge") +facet_grid(. ~ clarity) 
p1

p1 + coord_flip()

#no es necesario hacer una tabla con info resumen, funciones como stat_  hacen eso
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )








str(ChickWeight)
ggplot(data=ChickWeight, aes(x=Time, y=weight, group=Chick)) +  geom_line(color = "gray") 


ggplot(ChickWeight, aes(x=weight,color=Diet)) + 
  geom_histogram(binwidth=20,position="dodge")


ggplot(ChickWeight, aes(x=weight, fill=Diet)) + 
  geom_histogram(binwidth=30,position="dodge")



ggplot() +
  geom_line(data=ChickWeight, aes(x=Time, y=weight, group=Chick), color = "gray") +
  geom_line(data=subset(ChickWeight, Chick==17),
            aes(x=Time, y=weight, group=Chick), color = "red", size = 1) 


p <- ggplot(ChickWeight, aes(x=Diet, y=weight)) + 
  geom_boxplot()
p
p+theme_classic()

# Rotar el box plot (usamos coord_)
p + coord_flip()+theme_classic()




library(GGally)

chick <-ChickWeight[,c(1:2)]

ggpairs(chick)

ggpairs(iris)



library(ggplot2)
# cargar datos
DATA <- data.frame(iris)

#  PCA
PCA <- prcomp(iris[,1:4])

# Extraer ejes de los PC  para el grafico
PCAvalues <- data.frame(Species = iris$Species, PCA$x)

# Extraer loadings de las variables
PCAloadings <- data.frame(Variables = rownames(PCA$rotation), PCA$rotation)

# Plot
ggplot(PCAvalues, aes(x = PC1, y = PC2, colour = Species)) +
  geom_segment(data = PCAloadings, aes(x = 0, y = 0, xend = (PC1),
                                       yend = (PC2)), arrow = arrow(length = unit(1/2, "picas")), color = "black") +  geom_point(size = 3) + annotate("text", x = (PCAloadings$PC1), y = (PCAloadings$PC2),label = PCAloadings$Variables)





#set de datos Iris
df=iris
m=as.matrix(cbind(df$Petal.Length, df$Petal.Width),ncol=2)
cl=(kmeans(m,3))

df$cluster=factor(cl$cluster)


centers=as.data.frame(cl$centers)


ggplot(data=df, aes(x=Petal.Length, y=Petal.Width, color=cluster )) + 
  geom_point() + 
  geom_point(data=centers, aes(x=V1,y=V2, color="Center")) +
  geom_point(data=centers, aes(x=V1,y=V2, color="Center"), size=16, alpha=.3)
