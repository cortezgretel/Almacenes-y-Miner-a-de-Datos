#Asociacion
#cargar datos
datos <- read.csv("Documentos/Almacenes y Mineria de Datos/Proyecto/ClasificacionArboles/datosPrepTerrorismo2.csv", stringsAsFactors = TRUE)
# Preparar los datos
# Cargar las librerías necesarias
library(arules)
library(dplyr)

# Seleccionar variables relevantes en un nuevo dataset
trules <- datos %>%
  select(country, attacktype1, targtype1, weaptype1, nkill, nwound,success)

# Cambiar nkill y nwound a factores con una codificación basada en rangos
trules <- trules %>%
  mutate(nkill = case_when(
    nkill == 0 ~ 0,
    nkill < 2 ~ 1,
    nkill < 6 ~ 2,
    nkill < 16 ~ 3,
    TRUE ~ 4
  )) %>%
  mutate(nwound = case_when(
    nwound == 0 ~ 0,
    nwound < 2 ~ 1,
    nwound < 6 ~ 2,
    nwound < 16 ~ 3,
    TRUE ~ 4
  ))

# Cambiar todo a factores
trules <- trules %>%
  mutate(across(everything(), as.factor))

# Aplicar el algoritmo Apriori con los parámetros especificados
terror_rules <- apriori(trules, parameter = list(support = 0.01, confidence = 0.8, minlen = 2, maxlen = 15))

#variable objetivo success
# Inspeccionar las reglas que contienen la variable 'success' como consecuente
rules_with_success <- subset(terror_rules, rhs %pin% "success=1" | rhs %pin% "success=0")

# Inspeccionar las reglas encontradas que incluyen la variable objetivo 'success'
inspect(rules_with_success)

# Inspeccionar las reglas encontradas
inspect(terror_rules)


