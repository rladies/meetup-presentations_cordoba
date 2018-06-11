#Taller introductorio a R


#TIPOS DE OBJETOS

a <- 1 # una variable

v1 <- c(1,2,3)# vector 
class(v1)

# se unen los valores con el término c (concatenar)
# obtener la longitud de un vector
length(v1)
## [1] 3

#crear una matriz  con 0, con 3 filas y 2 columnas
m1 <- matrix(0, nrow = 3, ncol = 2) # matrix
# obtener las dimensione de la matriz
dim(m1)
## [1] 3 2

#crear un data.frame
df1 <- data.frame(v1, v1 * 10) # data frame

#crear una lista
l1 <- list("a" = a, "v1" = v1, "m1" = m1, "df1" = df1) #
l1
str(l1)



#extraer elementos según su posición
vec<-c(2,9,4,5,6,7,8)
vec[1] #solo un elemento
vec[2:3]# segundo y tercer elemento 
vec[c(2,3,6)]#segundo, tercer y sexto elemento

v1[2] # extrae el segundo elemento del vector v1
l1[2] # extrae el segundo elemento de la lista l1
m1[3,2] # extrae el elemento en la tercera fila segunda columna de m1
df1[3,2] # extract elemento en tercera fila segunda columna df1
#Sino, dimensiones con nombre pueden ser extraidas usando el operador $
l1$v1# extraer los valores del elemeento v1 de la lista l1
## [1] 1 2 3

x <- "auto"
y <- 2
class(x)
class(y)


#operaciones basicas
x <- c(1,2,3,4,5,6,7,8,9)
sum(x) #   suma de los elementos en el vector x
mean(x) # promedio
sd(x) # desvio estandar
max(x) # valor maximo
min(x) # valor minimo
log10(x) #  logaritmo en base10 (log10 computes logarith with base 10)
summary(x) #  estadisticas resumen

# como ven ninguno de los calculos de arriba está en el entorno, si se quiere almacenar algunos de esos resultados de las operaciones de arriba deberian asignarne un nombre 
suma<-sum(x)


# usamos una base de datos ya precargada en R
data("mtcars")

attributes(mtcars)
# ver primeras filas de los datos
head(mtcars)
# ver ultimas filas de los datos
tail(mtcars)
#tipo y tamaño de los datos
str(mtcars)
#estadisticas resumen de cada uno de los campos
summary(mtcars)
#estadisticas resumen de solo una variable
summary(mtcars$mpg)

#ponerle nombre a valores a un vector
a1 <-  c(18, 21)
names(a1) <-  c("SFE", "MZA")
a1



#creo un vector
v <- c(5, 2, 4, 3, 7)
#creo un df incluyendo al vector que recien hice
df <- data.frame(a = 3:7, v)
#selecciono cierto valores (los componentes de df cambiaron o son los mismos?)
df <- subset(df, v > 3)
df[order(df$v), ]


#grafico en R base
plot(mtcars$hp,mtcars$mpg, col=mtcars$carb)

#mismo grafico en ggplot2
library(ggplot2)
ggplot(data = mtcars, aes(x = hp, y = mpg,color=carb)) +   geom_point() 
