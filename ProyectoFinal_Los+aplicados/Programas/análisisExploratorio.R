### Establecemos el directorio en que 
### R buscará archivos en caso de ser necesario
setwd("C:/Users/escal/OneDrive - UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO/Desktop/UNAM/Almacenes Y minería/Proyecto Final/DATASET")
dataset <- read.csv("globalterrorismdb_0718dist.csv")
##Paquetería para automatizar el proceso de análisis exploratorio
##Tenemos una gran cantidad de variables y esto hace de este proceso algo más
##rápido
summary(dataset)
library(tidyr)
library(dplyr)

out <- capture.output(summary(dataset))
cat("Tabla de Variables", out, file="tablavariables.txt", sep="n", append=TRUE)

## SEPARAMOS EL DATAFRAME EN VARIABLES NUMÉRICAS
categorical_vars <- dataset %>% select_if(is.character)
numeric_vars <- dataset %>% select_if(is.numeric)

summ <- summary(numeric_vars) # create the summary
summ["Std.Dev."] <- round(sd(numeric_vars),2) # add the new value
out <- capture.output(summ)
###
std_dev <- sapply(numeric_vars, sd)

# Create a summary table
summ <- data.frame(
  Mean = sapply(numeric_vars, mean),
  Median = sapply(numeric_vars, median),
  Min = sapply(numeric_vars, min),
  Max = sapply(numeric_vars, max),
  Std.Dev. = round(std_dev, 2)
)

# Print the summary table
print(summ)

# EXPORTAMOS EL OUTPUT A UN ARCHIVO CSV
out <- capture.output(summ)
summary_df <- as.data.frame(out)
write.csv(summary_df, "num_summary_output.csv", row.names = FALSE)
###

## REALIZAMOS LAS PRUEBAS ESTADÍSTICAS
# Function to perform Kolmogorov-Smirnov tests for normality, exponential, and Weibull distribution
ks_test_distributions <- function(var) {
  test_result_normal <- ks.test(var, "pnorm")
  test_result_exponential <- ks.test(var, "pexp")
  test_result_weibull <- ks.test(var, "pweibull", shape = 2, scale = sd(var))
  
  return(data.frame(
    variable = deparse(substitute(var)),
    p_value_normal = test_result_normal$p.value,
    is_normal = test_result_normal$p.value > 0.05,
    p_value_exponential = test_result_exponential$p.value,
    is_exponential = test_result_exponential$p.value > 0.05,
    p_value_weibull = test_result_weibull$p.value,
    is_weibull = test_result_weibull$p.value > 0.05
  ))
}

# Apply the Kolmogorov-Smirnov tests to each variable in df_numeric
results <- lapply(numeric_vars, ks_test_distributions)

# Combine the results into a data frame
results_df <- do.call(rbind, results)

# Print the results
print(results_df)

