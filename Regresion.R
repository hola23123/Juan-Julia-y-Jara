library(readxl)
library(dplyr)
library(haven)

#Lista de variables y explicacioness
lista_variables <- read_excel("/Users/juan/Desktop/SOCIOLOGIA 3*/DATA SCIENCE/RStudio/Practica 15-16/cis3145_VarList.xlsx")

#Datos de spss
data <- read_sav("/Users/juan/Desktop/SOCIOLOGIA 3*/DATA SCIENCE/RStudio/Practica 15-16/cis3145t.sav")

# Selección de variables
datos_regresion <- data %>%
  select(edad, sexo, esta, ideopp)

# Convertir las variables categóricas a factores
datos_regresion$sexo <- as.factor(datos_regresion$sexo)
datos_regresion$esta <- as.factor(datos_regresion$esta)
datos_regresion$ideopp <- as.factor(datos_regresion$ideopp)

# Modelo de regresión lineal múltiple
model <- lm(edad ~ sexo + esta +ideopp, data = datos_regresion)

# Resumen del modelo
summary(model)
