library(tidyverse)
library(readxl)
library(lubridate)
library(ggplot2)

clean_data <- read_excel("ForoData.xlsx")

# CREAR UNA COLUMNA CON SOLO LA FECHA
clean_data <- clean_data %>%
  mutate(Only_Date = case_when(
    str_detect(Date, "^\\d{2}-\\w{3}-\\d{4}") ~ dmy(substr(Date, 1, 11)),
    str_detect(Date, "^\\d{4}-\\d{2}-\\d{2}") ~ ymd(substr(Date, 1, 10)),
    TRUE ~ as.Date(NA)
  ))

# CONTAR LOS MENSAJES POR DIA SEGUN LA COLUMNA Only_Date
mensajes_por_dia <- clean_data %>%
  group_by(Only_Date) %>%
  summarise(n_mensajes = n())

# CREAR UNA SECUENCIA COMPLETA DE FECHAS INCLUYENDO EL DÍA 14 DE MAYO
complete_dates <- data.frame(Only_Date = seq(min(mensajes_por_dia$Only_Date), as.Date("2024-05-14"), by = "day"))

# UNIR LA SECUENCIA COMPLETA DE FECHAS CON LOS DATOS CONTADOS
mensajes_por_dia <- complete_dates %>%
  left_join(mensajes_por_dia, by = "Only_Date") %>%
  replace_na(list(n_mensajes = 0)) %>%
  filter(!Only_Date %in% as.Date(c("2024-05-15", "2024-05-16", "2024-05-17")))

# GRAFICA CON GGPLOT
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
