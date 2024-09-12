### Establecemos el directorio en que 
### R buscará archivos en caso de ser necesario
setwd("C:/Users/escal/OneDrive - UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO/Desktop/UNAM/Almacenes Y minería/Proyecto Final/DATASET")
dataset <- read.csv("datosPrepTerrorismo2.csv")

## realizamos reduccion de dimensionalidad para visualizar el kmeans
library('corrr')
library(ggcorrplot)
library("FactoMineR")
library("factoextra")

### TOMAMOS UNA MUESTRA DEL CONJUNTO DE DATOS: 
library(dplyr)
muestra <- sample_n(dataset, 10000)

###### DETERMINAMOS EL NUMERO OPTIMO DE CLUSTERS #####
ggp1 <- fviz_nbclust(muestra,          # Determine number of clusters
                     FUNcluster = kmeans,
                     method = "wss")

ggp1      

#### CREAMOS VISUALIZACIÓN DE ESTOS GRUPOS
require(cluster)

X <- muestra
kmm <- kmeans(X, 5)

D <- daisy(X)
plot(silhouette(kmm$cluster, D), col=1:5, border=NA)
##### REPRESENTACIÓN EN DOS DIMENSIONES DEL CONJUNTO DE DATOS
fviz_cluster(kmm, data = X,geom="point", alpha = 0)
### analizamos los elementos de cada grupo:


### ANALIZAMOS LOS ELEMENTOS DE CADA GRUPO PARA DESCUBRIR SUS ELEMENTOS EN COMUN
# AÑADIMOS LAS ETIQUETAS DE KMEANS A CADA ELEMENTO DE LA MUESTRA
muestra$cluster <- as.factor(kmm$cluster)

# CREAMOS DATAFRAMES SEPARADOS PARA CADA CLUSTER
cluster_dataframes <- split(muestra, f = muestra$cluster)
##RESUMEN DE CADA DATAFRAME
k <- 5
for (i in 1:k) {
  cat("Summary for Cluster", i, ":\n")
  print(summary(cluster_dataframes[[i]]))
  cat("\n")
}