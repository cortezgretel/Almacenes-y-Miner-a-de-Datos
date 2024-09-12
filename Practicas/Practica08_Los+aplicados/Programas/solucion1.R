setwd("C:/Users/escal/OneDrive - UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO/Desktop/UNAM/Almacenes Y minería/Dataseet")
library(ggplot2)
library(tidyr)
library(GGally)
library(reshape2)
library(dplyr)
library(corrplot)
library(nortest)
library(car)
library(mice)
library(stringr)

vgsales  = read.csv('vgsales.csv')

##LIMPIEZA DE VARIABLES NUMÉRICAS
vgsales_numVariables <- select(vgsales, "Year", "NA_Sales", "EU_Sales",
                               "JP_Sales", "Other_Sales", "Global_Sales")
summary(vgsales_numVariables)
md.pattern(vgsales_numVariables)

### ANTES DE LA IMPUTACIÓN, NOTEMOS QUE LA VARIABLE GLOBAL SALES CONTIENE 
### VALORES NEGATIVOS, SE APLICARA VALOR ABSOLUTO A ESTA COLUMNA PARA CORREGIR}
vgsales_numVariables_abs <- abs(vgsales_numVariables)
summary(vgsales_numVariables_abs)

### IMPUTACIÓN DE VALORES PERDIDOS

### EMPLEO DE METODO DE EMPAREJAMIENTO PREDICTIVO DE MEDIAS :)
vgsales_numVariables_imputadas <- mice(vgsales_numVariables_abs, 
                                       m=5, maxit = 50, method = 'pmm', seed = 500)

summary(vgsales_numVariables_imputadas)

##
vgsales_num_complete <- complete(vgsales_numVariables_imputadas, 1)

md.pattern(vgsales_num_complete)
### IMMPUTACIÓN TERMINADA :)

####### VARIABLES CATEGÓRICAS ######
## ESTO VA A ESTAR FEO ##

vgsales_CAT <- select(vgsales, "Platform", "Genre", "Publisher")
## TENEMOS MUCHAS VARIABLES CON LOS NOMBRES ERRONEOS EN PLATFORM Y PUBLISHER, Y ERRORES
## DE TIPEO EN GENRE 

## :(

###  PLATFORM  ###
### CONVERSION DE NOMBRES DE VARIABLES A MAYUSCULAS (PARA TENER UN ESTANDAR)
vgsales_CAT$Platform <- toupper(vgsales_CAT$Platform)

### CONTEO DE INCIDENCIAS POR CATEGORÍA, PARA DARNOS UNA IDEA DE COMO LIMPIARLA
count(vgsales_CAT, c("Platform")) 

### VARIABLES CON ERRORES: 
### XBOXONE = XONE
### WI = WII
### PLAYS2 == PSTATION 2 == PLAYSTATION2
### AFORTUNADAMENTE SE PUEDE CORREGIR BUSCANDO Y REEMPLAZANDO LOS ERRORES EN 
### UN SCRIPT DE R
library(plyr)
vgsales_CAT$Platform<-revalue(vgsales_CAT$Platform,
                         c("XONE"="XBOXONE",
                           "WI"="WII",
                           "PS2" = "PLAYSTATION2",
                           "PLAYS2"="PLAYSTATION2",
                           "PSTATION2"="PLAYSTATION2",
                           "X360" = "XBOX360"
                           ))
####
count(vgsales_CAT, c("Platform")) 
### LIMPIO

### GENRE ###
### CONVERSION DE NOMBRES DE VARIABLES A MAYUSCULAS (PARA TENER UN ESTANDAR)
vgsales_CAT$Genre <- toupper(vgsales_CAT$Genre)

### CONTEO DE INCIDENCIAS POR CATEGORÍA, PARA DARNOS UNA IDEA DE COMO LIMPIARLA
count(vgsales_CAT, c("Genre")) 

### VARIABLE CON ERRORES: 
### ACTION = ACTON = ATION

###LIMPIEZA
vgsales_CAT$Genre<-revalue(vgsales_CAT$Genre,
                              c("ACTON"="ACTION",
                                "ATION"="ACTION"
                              ))
####
count(vgsales_CAT, c("Genre")) 
vgsales_CAT$vgsales_CAT<-revalue(vgsales_CAT$vgsales_CAT,
                           c("NA"="ACTION"
                           ))

var.replace = c("d"=NA, "a"="A")
vgsales_CAT$Genre <- replace(vgsales_CAT$Genre, vgsales_CAT$Genre == '', "ACTION") %>% plyr::revalue(var.replace)

#vgsales_CAT$Genre <- vgsales_CAT$vgsales_CAT
#vgsales_CAT <- vgsales_CAT[,-4]
#### LIMPIO

##### PUBLISHER
### CONVERSION DE NOMBRES DE VARIABLES A MAYUSCULAS (PARA TENER UN ESTANDAR)
vgsales_CAT$Publisher <- toupper(vgsales_CAT$Publisher)
count(vgsales_CAT, c("Publisher")) 
### ERRORES DE VARIABLES: 
### NINTEND0 = NINTNDO
### NINTENDO = INTENDO

vgsales_CAT$Publisher<-revalue(vgsales_CAT$Publisher,
                           c("NINTNDO"="NINTENDO",
                             "INTENDO"="NINTENDO"
                           ))
count(vgsales_CAT, c("Publisher")) 
### IMPUTACION DE VALORES PERDIDOS

var.replace = c("d"=NA, "a"="A")
vgsales_CAT$Publisher <- replace(vgsales_CAT$Publisher, vgsales_CAT$Publisher == '', NA) %>% plyr::revalue(var.replace)

#### CREACIÓN DE DATAFRAME LIMPIO

vgsales_limpio <- cbind(vgsales$Rank, vgsales$Name, vgsales_num_complete, vgsales_CAT)
## REORDENAMOS PARA TENER EL ORDEN DEL DATAFRAME ORIGINAL
vgsales_limpio2 <- vgsales_limpio[, c(1,2,9,3,10,11,4,5,6,7,8)]
##RENOMBRAMOS NOMBRES DE COLUMNAS
names(vgsales_limpio2)[names(vgsales_limpio2) == 'vgsales$Rank'] <- 'Rank'
names(vgsales_limpio2)[names(vgsales_limpio2) == 'vgsales$Name'] <- 'Name'
vgsales_limpio <- vgsales_limpio2

##EXPORTAMOS A CSV :)

write.csv(vgsales_limpio, "vgsales_limpio.csv", row.names=FALSE)
#################### POR FIN 




#### PRUEBA CHI-CUADRADA

chisq.test(x=vgsales_CAT$Genre, y=vgsales_CAT$Publisher)
#### TENEMOS UN P-VALUE MENOR A 0.05, POR LO QUE SE RECHAZA LA HIPÓTESIS NULA 
#### DE INDEPENDENCIA ENTRE AMBAS VARIABLES



