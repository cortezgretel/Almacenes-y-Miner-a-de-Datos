### Establecemos el directorio en que 
### R buscará archivos en caso de ser necesario
setwd("C:/Users/escal/OneDrive - UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO/Desktop/UNAM/Almacenes Y minería/Proyecto Final/DATASET")
dataset <- read.csv("globalterrorismdb_0718dist.csv")
## removemos a las variables con alto porcentaje de valores perdidos, y 
## aquellas que almacenan la información de otras variables
## en tipo string
columns_to_remove <- c("approxdate", "country_txt", "region_txt", "provstate",
          "city", "location", "summary", "alternative_txt",
          "attacktype1_txt", "attacktype2", "attacktype2_txt",
          "attacktype3", "attacktype3_txt", "targtype1_txt",
          "targsubtype1_txt","natlty1_txt", "targtype2", 
          "targtype2_txt", "targsubtype2", "targsubtype2_txt",
          "corp2", "target2", "natlty2", "natlty2_txt", 
          "targtype3", "targtype3_txt","targsubtype3", "targsubtype3_txt",
          "corp3", "target3", "natlty3", "natlty3_txt","gsubname",
          "gname2", "gsubname2", "gname3", "gsubname3", "motive",
          "guncertain2", "guncertain3", "claimmode_txt","claim2",
          "claimmode2", "claimmode2_txt", "claim3", "claimmode3",
          "claimmode3_txt","compclaim","weaptype1_txt", "weapsubtype1_txt",
          "weaptype2", "weaptype2_txt","weapsubtype2", "weapsubtype2_txt",
          "weaptype3", "weaptype3_txt","weapsubtype3", "weapsubtype3_txt",
          "weaptype4", "weaptype4_txt","weapsubtype4","weapsubtype4_txt",
          "propextent_txt", "propcomment","divert", "kidhijcountry",
          "ransomamtus", "ransompaidus", "ransomnote", "hostkidoutcome_txt",
          "addnotes", "scite1", "scite2", "scite3", "related","resolution",
          "alternative", "claimmode", "propextent", "propvalue", "nhostkid", 
          "nhostkidus", "nhours", "ndays", "ransom", "ransomamt", "ransompaid",
          "hostkidoutcome", "nreleased", "nperps", "nperpcap", "target1", "corp1",
          "gname", "weapdetail", "dbsource")


cleanup <- dataset[, !(names(dataset) %in% columns_to_remove)]

### conjunto de datos a limpiar
print("Count of missing values by column wise") 
sapply(cleanup, function(x) sum(is.na(x)))

## Imputación de valores perdidos

## VARIABLES A IMPUTAR POR MODA:
library(dplyr)

# FUNCION PARA REALIZAR IMPUTACIÓN POR MODA
mode_impute <- function(x) {
  mode_value <- as.numeric(names(sort(table(x), decreasing = TRUE)[1]))
  x[is.na(x)] <- mode_value
  return(x)
}

## FUNCION PARA IMPUTAR POR MEDIANA
mean_impute <- function(x) {
  mean_value <- mean(x, na.rm = TRUE)
  x[is.na(x)] <- mean_value
  return(x)
}
## IMPUTACION POR MEDIANA 
median_impute <- function(x) {
  median_value <- median(x, na.rm = TRUE)
  x[is.na(x)] <- median_value
  return(x)
}


# IMPUTACION POR MODA DE VARIABLES CATEGÓRICAS
cleanup$latitude <- mode_impute(cleanup$latitude)
cleanup$longitude <- mode_impute(cleanup$longitude)
cleanup$specificity <- mode_impute(cleanup$specificity)
cleanup$doubtterr <- mode_impute(cleanup$doubtterr)
cleanup$multiple <- mode_impute(cleanup$multiple)
cleanup$targsubtype1 <- mode_impute(cleanup$targsubtype1)
cleanup$corp1 <- mode_impute(cleanup$corp1)
cleanup$natlty1 <- mode_impute(cleanup$natlty1)
cleanup$guncertain1 <- mode_impute(cleanup$guncertain1)
cleanup$claimed <- mode_impute(cleanup$claimed)
cleanup$corp1 <- mode_impute(cleanup$corp1)
cleanup$target1 <- mode_impute(cleanup$target1)
cleanup$ishostkid <- mode_impute(cleanup$ishostkid)
cleanup$weapsubtype1 <- mode_impute(cleanup$weapsubtype1)

## IMPUTACIÓN POR MEDIANA Y MODA PARA VARIABLES NUMÉRICAS 
cleanup$nwound <- median_impute(cleanup$nwound)
cleanup$nkill <- mean_impute(cleanup$nkill)
cleanup$nkillus <- mean_impute(cleanup$nkillus)
cleanup$nkillter <- median_impute(cleanup$nkillter)
cleanup$nwoundus <- mean_impute(cleanup$nwoundus)
cleanup$nwoundte <- median_impute(cleanup$nwoundte)

############ CONTEO DE VALORES PERDIDOS###########
print("Count of missing values by column wise") 
sapply(cleanup, function(x) sum(is.na(x)))

##### CREACION DE VARIABLES DUMMIES
library(caret)

#define one-hot encoding function
dummy <- dummyVars(" ~ .", data=cleanup)

#perform one-hot encoding on data frame
dummy_df <- data.frame(predict(dummy, newdata=cleanup))


#### ELIMINACIÓN DE VALORES ATÍPICOS
### FUNCION QUE ELIMINA VALORES ATÍPICOS DE VARIAS VARIABLES
### EMPLEANDO CUANTILES
outliers <- function(x) {
  
  Q1 <- quantile(x, probs=.25)
  Q3 <- quantile(x, probs=.75)
  iqr = Q3-Q1
  
  upper_limit = Q3 + (iqr*1.5)
  lower_limit = Q1 - (iqr*1.5)
  
  x > upper_limit | x < lower_limit
}

remove_outliers <- function(df, cols = names(df)) {
  for (col in cols) {
    df <- df[!outliers(df[[col]]),]
  }
  df
}

outlierrem <- remove_outliers(cleanup)

#### exportación del dataframe
write.csv(cleanup,"datosPrepTerrorismo2.csv", row.names=FALSE)

