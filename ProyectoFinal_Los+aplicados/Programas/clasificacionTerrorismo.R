#cargamos los datos "datosPrepTerrorismo2.csv
datos <- read.csv("Documentos/Almacenes y Mineria de Datos/Proyecto/ClasificacionArboles/datosPrepTerrorismo2.csv", stringsAsFactors = TRUE)
# Carga las librerías necesarias
library(rpart)
library(rpart.plot)
library(ggplot2)
# Convertir las variables a factores 
datos$attacktype1 <- as.factor(datos$attacktype1)
datos$targtype1 <- as.factor(datos$targtype1)
datos$weaptype1 <- as.factor(datos$weaptype1)
datos$country <- as.factor(datos$country)
datos$region <- as.factor(datos$region)
# attacktype1 grafica
ggplot(datos, aes(x = attacktype1, fill = success)) +
  geom_bar(position = "fill") +
  ylab("Proporción") +
  ggtitle("Relación entre Tipo de Ataque y Éxito")
# Gráfico para 'attacktype1'
ggplot(datos, aes(x = attacktype1, fill = factor(success))) +
  geom_bar(position = "fill") +
  ylab("Proporción") +
  xlab("Tipo de Ataque") +
  ggtitle("Proporción de Éxito por Tipo de Ataque") +
  scale_fill_discrete(name = "Éxito")
# targtype
ggplot(datos, aes(x = targtype1, fill = factor(success))) +
  geom_bar(position = "fill") +
  ylab("Proporción") +
  xlab("Tipo de Objetivo") +
  ggtitle("Proporción de Éxito por Tipo de Objetivo")
#  modelo de árbol de decisión con un subconjunto de variables
#minsplit: Este parámetro determina el número mínimo de observaciones que debe tener un nodo antes de que se considere para una división. 
#Un valor más alto hará que el árbol sea más pequeño y menos complejo.
#cp (parámetro de complejidad): Este parámetro controla el tamaño del árbol mediante el podado. 
#Un valor más grande permitirá árboles más complejos; 
#un valor más pequeño podará más agresivamente, resultando en un árbol más simple.
modelo_cart <- rpart(success ~attacktype1+ targtype1 + weaptype1 +
                       country + region, 
                     data = datos, 
                     method = "class",
                     control = rpart.control(minsplit = 1000, cp = 0.00001, xval = 10))

# Calculamos la importancia de las variables
importancia <- varImp(modelo_cart)

# Graficamos la importancia de las variables
plot(importancia)

# Muestra un resumen del modelo
summary(modelo_cart)

# Visualiza el árbol
rpart.plot(modelo_cart)



#evaluacion del arbol
# Suponiendo que 'modelo_arbol' es tu modelo entrenado y 'datos_prueba' es tu conjunto de pruebas
# Primero, necesitas hacer predicciones con tu modelo
predicciones <- predict(modelo_cart, newdata = datos, type = "class")

# Ahora, crea la matriz de confusión
matriz_confusion <- table(Prediccion = predicciones, Realidad = datos$success)

# Imprime la matriz de confusión
print(matriz_confusion)

# Calcular métricas a partir de la matriz de confusión
library(caret)
confusionMatrix(matriz_confusion)



# ==============================================================================
# REDES NEURONALES, Proyecto
# ==============================================================================


# Cargar las librerías necesarias
library(caTools)
library(neuralnet)

# Cargar los datos
datosTerrorismo <- read.csv("datosPrepTerrorismo2.csv", header = TRUE, sep = ",")

# Seleccionar las columnas de entrada y salida
columnas_entrada <- c("attacktype1", "country", "iyear", "imonth")
columna_salida <- "success"

# Dividir los datos en conjuntos de entrenamiento y prueba
set.seed(123)  
muestra <- sample.split(datosTerrorismo$success, SplitRatio = 0.66)
datos_entrenamiento <- datosTerrorismo[muestra, ]
datos_prueba <- datosTerrorismo[!muestra, ]

# Crear y entrenar la red neuronal
red_neuronal <- neuralnet("success ~ attacktype1  + country + iyear + imonth", data = datos_entrenamiento[, c(columnas_entrada, columna_salida)], hidden = c(4, 2), linear.output = TRUE)

# Realizar predicciones en el conjunto de prueba
predicciones <- predict(red_neuronal, newdata = datos_prueba[, columnas_entrada])

# Convertir las predicciones a valores binarios (0 o 1)
umbral <- 0.50
predicciones_binarias <- ifelse(predicciones >= umbral, 1, 0)

# Crear una tabla comparativa
tabla_comparativa <- data.frame(Real = datos_prueba$success, Predicho = predicciones_binarias)

# Calcular la precisión
precision <- mean(datos_prueba$success == predicciones_binarias)
cat("Precisión en el conjunto de prueba:", precision, "\n")

# Mostrar la red neuronal
plot(red_neuronal)

red$result.matrix



