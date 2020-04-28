rm(list=ls())
require(ncdf.tools)
require(raster)
require(ncdf4)
require(rgdal)
require(sp)
library(sf)
library(ggplot2)

#PARA TRANSFORMAR RASTERS NetCDF A raster GeoTIFF:

## Read the netCDF file as a raster layer. 
r<- raster("C:/Users/pc/Desktop/R-ladies/Archivos/A20190012019031.L3m_MO_CHL_chlor_a_4km.nc.nc4")

#Usamos funcion SpatialGridDataFrame = permite transformar atributos espaciales que tienen ubicaciones espaciales en una cuadrícula regular.

sgdf<-as(r,"SpatialGridDataFrame") #definir cuadrícula espacial con datos de atributos espaciales
r
#Una vez convertida la imagen, la guardamos en el directorio con la extension .tiff
writeGDAL(sgdf, "C:/Users/pc/Desktop/R-ladies/Archivos/A20190012019031.L3m_MO_CHL_chlor_a_4km.tiff")

###-----Para sacar datos de esta imagen en base a datos que tenemos en un csv:

##Leemos nuestro nuevo raster y vemos la proyeccion para convertir nuestro csv en shape

rr<- raster("C:/Users/pc/Desktop/R-ladies/Archivos/A20190012019031.L3m_MO_CHL_chlor_a_4km.tiff")
rr#para ver la proyeccion, leer en crs(coordinate reference system)
summary(rr)

#Otra forma de chequear proyeccion
projection(rr)

#cargar csv
plot.ejem <- read.csv("C:/Users/pc/Desktop/R-ladies/Archivos/ejemplo.csv",
                     stringsAsFactors = FALSE) # Para evitar que las columnas 
                                               #que contienen caracteres                        
                                               #se convierten en factores
plot.ejem
str(plot.ejem)

#creamos un objeto que tenga la proyeccion deseada (la misma que la imagen satelital)
r.ejem<- crs("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0" )
r.ejem

#Convertimos nuestro dataframe (csv) en un objeto espacial. Necesitamos especificar:
#el archivo a convertir
#Columnas que contienen las coordenadas
#El sistemas de referencia de coordenadas (CRS)
#usaremos la funcion st_as_sf() para la conversion

plot_locations<- st_as_sf(plot.ejem, coords = c("LONG", "LAT"), crs = r.ejem)
plot_locations

#chequeamos crs de nuestros puntos
st_crs(plot_locations)

#ploteamos los puntos
ggplot() +
  geom_sf(data = plot_locations) +
  ggtitle("Map of Plot Locations")

# Ahora necesitamos crear un objeto límite (boundary). Mapa base del área en estudio


boundary_ejem <- st_read("C:/Users/pc/Desktop/R-ladies/Archivos/sudamerica.shp")

#Chequeamos que el mapa base y mis puntos tengan el mismo sistema de referencia (sino hay que reproyectar)
st_crs(boundary_ejem)
st_crs(plot_locations)

#podemos visualizar los limites de ambos. El de mapa base tiene que ser mayor al de los puntos
st_bbox(boundary_ejem)
st_bbox(plot_locations)

# Si necesito reproyectarlo para que coincida con mis puntos. Correr:
# Cargar mapa base. Funcion readORG nos permite leer shapes:
zona_estudio<-readOGR("C:/Users/pc/Desktop/R-ladies/Archivos","sudamerica")
proj4string(zona_estudio)#esta funcion nos permite ver la proyeccion del shape
#generar un objeto con la proyeccion deseada:
wgs84 <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
proj4string(zona_estudio) <- CRS(wgs84)#asignamos la proyeccion
#transformamos el shape con la funcion spTransform y el objeto creado antes
zona_estudio_wgs84 <- spTransform(zona_estudio,CRS(wgs84))#transformación
zona_estudio_wgs84

#Guardamos nuestro nuevo mapa base proyectado (poner nuevo nombre que "layer="):

writeOGR(zona_estudio_wgs84, dsn = "C:/Users/pc/Desktop/R-ladies/Archivos", layer = "sudamerica_georef", driver = "ESRI Shapefile",overwrite_layer = TRUE)

# Volvemos a cargar el objeto limite con el mapa base reproyectado:

boundary_ejem2 <- st_read("C:/Users/pc/Desktop/R-ladies/Archivos/sudamerica_georef.shp")

#Chequeamos proyecciones
st_crs(boundary_ejem2)
st_crs(plot_locations)

#visualizamos puntos+ mapa base
ggplot() +
  geom_sf(data =boundary_ejem2 ) +
  geom_sf(data = plot_locations) +
  ggtitle("Plot gls+chla")

#guardamos el nuevo shapefile
setwd("C:/Users/pc/Desktop/R-ladies/Archivos")
st_write(plot_locations,
         "EJEMPLO.shp", driver = "ESRI Shapefile")


#Cargo el nuevo shape con los puntos con la funcion readOGR
puntos.ejem<-readOGR(dsn="C:/Users/pc/Desktop/R-ladies/Archivos",layer="EJEMPLO")

#projection(puntosgls)# si no coincide exactamente, defino yo la proyeccion:
##para transformar proyeccion:
#puntosgls<-spTransform(puntosgls,CRS("+proj=utm +zone=21 +datum=WGS84 +units=m +no_defs +towgs84=0,0,0"))


# extraigo valores en buffer alrededor de cada punto de GLS. Buffer en metros!
ejem_186km <- extract(rr,puntos.ejem,df=TRUE,fun=mean,buffer=186000)
ejem_186km #El Id= 1 corresponde al primer valor de mi csv y asi, no pone coordenadas pero coinciden con el orden original.


#guardo archivo
setwd("C:/Users/pc/Desktop/R-ladies/Archivos")
write.csv(ejem_186km,"Ejem_186.csv",quote=F,row.names=F,dec=".",sep=";")




