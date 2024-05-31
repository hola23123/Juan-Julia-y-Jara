library(tidyverse)
library(readxl)

resultado <- read_excel("Diccionario.xlsx")

#COGER SOLO LAS CATEGORIAS PRINCIPALES
categorias_principales <- resultado %>%
  filter(Categoria != "")

#GRAFICA CON GGPLOT
ggplot(categorias_principales, aes(x = reorder(Categoria, -Frecuencia), y = Frecuencia)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Frecuencia de Categorías",
       x = "Categoría",
       y = "Frecuencia") +
  scale_x_discrete() +
  scale_y_continuous(breaks = seq(0, 600, by = 50), limits = c(0, 600)) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5)
  )
  