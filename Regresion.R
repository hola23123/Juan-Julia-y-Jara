library(readxl)
library(dplyr)
library(haven)

#Lista de variables y explicacioness
lista_variables <- read_excel("/Users/juan/Desktop/SOCIOLOGIA 3*/DATA SCIENCE/RStudio/Practica 15-16/cis3145_VarList.xlsx")

#Datos de spss
data <- read_sav("/Users/juan/Desktop/SOCIOLOGIA 3*/DATA SCIENCE/RStudio/Practica 15-16/cis3145t.sav")

# Selección de variables
datos_regresion <- data %>%
  select(edad, genero, status)

# Convertir las variables categóricas a factores
datos_regresion$sexo <- as.factor(datos_regresion$genero)
datos_regresion$esta <- as.factor(datos_regresion$status)
datos_regresion$ideopp <- as.factor(datos_regresion$ideopp)

# Modelo de regresión lineal múltiple
model <- lm(edad ~ genero + status, data = datos_regresion)

# Resumen del modelo
summary(model)
