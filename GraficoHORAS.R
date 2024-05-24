library(tidyverse)
library(readxl)
library(lubridate)

clean_data <- read_excel("ForoData.xlsx")

#SACAMOS LA FECHA UTILIZANDO LUBRIDATE
clean_data <- clean_data %>%
  mutate(Hour = hour(dmy_hm(Date)))

#SUMAMOS TODAS LAS HORAS
mensajes_por_hora <- clean_data %>%
  group_by(Hour) %>%
  summarise(n_mensajes = n())

#GRAFICA CON GGPLOT
ggplot(mensajes_por_hora, aes(x = Hour, y = n_mensajes)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Cantidad de mensajes por hora del día",
       x = "Hora del día",
       y = "Número de mensajes") +
  scale_x_continuous(breaks = 0:23) +
  scale_y_continuous(breaks = seq(0, 3000, by = 250), limits = c(0, 2500)) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))
