library(tidyverse)
library(readxl)
library(ggplot2)
library(stringr)


clean_data <- read_excel("ForoData.xlsx")

#DICCIONARIO, CAMBIAR CUANDO SE CAMBIE EL OTRO SCRIPT

diccionario <- list(
  politica = c("Israel", "gobierno", "elección", "terroristas", "Netanhayu"),
  machismo = c("machismo", "misoginia", "sexismo"),
  bodyshaming = c("gordo", "flaco", "peso"),
  otras = c("foro", "mensaje", "usuario"),
  insultos = c("idiota", "estúpido", "imbécil", "tonto", "gilipollas", "capullo", "payaso", "cabrón", "subnormal", "hijo de puta", "cretino", "mamón", "caraculo", "miserable", "bobo", "lameculos", "pelota", "soplagaitas", "cabestro", "tarado", "jilipollas", "zángano", "zopenco", "lechón", "cachondo", "pardillo", "desgraciado", "cenutrio", "petardo", "chupatintas", "mamonazo", "maricón", "mierda", "farsante", "gañán", "mequetrefe", "botarate", "tontolaba", "imbécil de mierda", "mocoso", "ñú", "gilipuertas", "bocazas", "tontaina", "tontorrón", "papanatas", "panoli", "tontarra", "tolai", "fantasma", "cansino", "puto amo", "estúpido de mierda", "matao", "perroflauta", "malnacido", "bastardo", "baboso", "mosquita muerta", "metomentodo", "penco", "bocachancla", "pesado", "puñetero", "petulante", "chulo", "fresco", "flipado", "creído", "patán", "merluzo", "mongolo", "patético", "pelagatos", "cansao", "pelagambas", "pegaplatos", "huevón", "pollaboba", "tontolculo", "chupaculos", "parguela", "gusano", "tarugo", "pelele", "pelele de mierda", "miserable de mierda", "despojo", "pelocha", "pelochera", "casposo", "gafapasta", "gili", "lamebotas", "cabezón", "tocahuevos", "gordinflón", "cabeza de chorlito", "mariquita", "mamón de mierda", "cacho carne", "paquete", "inútil"),
  sexualizacionNoInsulto = c("sexy", "caliente", "atractivo", "atractiva", "atractivos", "atractivas", "guapo", "guapa", "guapos", "guapas", "buenorro", "buenorra", "buenorros", "buenorras", "macizo", "maciza", "macizos", "macizas"),
  sexualizacionInsulto = c("puta", "zorra", "perra", "prostituta", "ramera", "furcia", "meretriz", "buscona", "busconas", "buscones")
)

# Función que cuenta las palabras de cada categoria

contar_palabras_por_categoria <- function(df, diccionario) {
  frecuencias <- lapply(diccionario, function(palabras) {
    sapply(palabras, function(palabra) {
      sum(str_count(df$Post, fixed(palabra, ignore_case = TRUE)), na.rm = TRUE)
    })
  })
  return(frecuencias)
}

# dataframe con las frecuencias de las palabras por categoria

frecuencias_categorias <- contar_palabras_por_categoria(clean_data, diccionario)

# dataframe con los resultados
detalle_palabras_df <- data.frame(
  Categoria = character(),
  Palabra = character(),
  Frecuencia = integer()
)

for (categoria in names(diccionario)) {
  palabras <- diccionario[[categoria]]
  frecuencias <- frecuencias_categorias[[categoria]]
  palabras_frecuentes <- sort(frecuencias[frecuencias > 0], decreasing = TRUE)
  top_palabras <- head(palabras_frecuentes, 5)
  if (length(top_palabras) > 0) {
    detalle_palabras_df <- bind_rows(detalle_palabras_df, 
                                     data.frame(Categoria = categoria,
                                                Palabra = names(top_palabras),
                                                Frecuencia = as.integer(top_palabras)))
  }
}

# crea graficos de cada categoria
categorias <- unique(detalle_palabras_df$Categoria)

for (categoria in categorias) {
  # categoria actual
  data_categoria <- detalle_palabras_df %>%
    filter(Categoria == categoria)
  
  # Crear gráfico y lo guarda en PNG
  PNG <- ggplot(data_categoria, aes(x = reorder(Palabra, -Frecuencia), y = Frecuencia)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(title = paste("Palabras más usadas en la categoría:", categoria),
         x = "Palabra",
         y = "Frecuencia") +
    scale_x_discrete() +
    scale_y_continuous(breaks = seq(0, max(data_categoria$Frecuencia, na.rm = TRUE), by = 50)) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.title = element_text(hjust = 0.5)
    )
  
  # Guardar el gráfico
  ggsave(paste0("grafico_", categoria, ".png"), plot = PNG)
}
