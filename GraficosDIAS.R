library(tidyverse)
library(readxl)
library(lubridate)
library(ggplot2)

clean_data <- read_excel("ForoData.xlsx")

#CREAR UNA COLUMNA CON SOLO LA FECHA
clean_data <- clean_data %>%
  mutate(Only_Date = as.Date(Date, format="%d-%b-%Y"))

#CONTAR LOS MENSAJES POR DIA SEGUN LA COLUMNA Only_Date
mensajes_por_dia <- clean_data %>%
  group_by(Only_Date) %>%
  summarise(n_mensajes = n())

#GRAFICA CON GGPLOT
ggplot(mensajes_por_dia, aes(x = Only_Date, y = n_mensajes)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Cantidad de mensajes por día",
       x = "Fecha",
       y = "Número de mensajes") +
  scale_x_date(breaks = seq(min(mensajes_por_dia$Only_Date), max(mensajes_por_dia$Only_Date), by = "day"),
               date_labels = "%d-%b") +
  scale_y_continuous(breaks = seq(0, max(mensajes_por_dia$n_mensajes), by = 500)) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5)
  )
