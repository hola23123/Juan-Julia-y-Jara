library(tidyverse)
library(rvest)
library(glue)
library(xlsx)
library(readxl)
library(stringr)

#BASE DE DATOS
clean_data <- read_excel("ForoData.xlsx")

#DICCIONARIO DE PRUEBA
diccionario <- list(
  politica = c("Israel", "gobierno", "elección", "terroristas", "Netanhayu"),
  machismo = c("machismo", "misoginia", "sexismo"),
  bodyshaming = c("gordo", "flaco", "peso"),
  otras = c("foro", "mensaje", "usuario"),
  insultos = c("idiota", "estúpido", "imbécil", "tonto", "gilipollas", "capullo", "payaso", "cabrón", "subnormal", "hijo de puta", "cretino", "mamón", "caraculo", "miserable", "bobo", "lameculos", "pelota", "soplagaitas", "cabestro", "tarado", "jilipollas", "zángano", "zopenco", "lechón", "cachondo", "pardillo", "desgraciado", "cenutrio", "petardo", "chupatintas", "mamonazo", "maricón", "mierda", "farsante", "gañán", "mequetrefe", "botarate", "tontolaba", "imbécil de mierda", "mocoso", "ñú", "gilipuertas", "bocazas", "tontaina", "tontorrón", "papanatas", "panoli", "tontarra", "tolai", "fantasma", "cansino", "puto amo", "estúpido de mierda", "matao", "perroflauta", "malnacido", "bastardo", "baboso", "mosquita muerta", "metomentodo", "penco", "bocachancla", "pesado", "puñetero", "petulante", "chulo", "fresco", "flipado", "creído", "patán", "merluzo", "mongolo", "patético", "pelagatos", "cansao", "pelagambas", "pegaplatos", "huevón", "pollaboba", "tontolculo", "chupaculos", "parguela", "gusano", "tarugo", "pelele", "pelele de mierda", "miserable de mierda", "despojo", "pelocha", "pelochera", "casposo", "gafapasta", "gili", "lamebotas", "cabezón", "tocahuevos", "gordinflón", "cabeza de chorlito", "mariquita", "mamón de mierda", "cacho carne", "paquete", "inútil"),
  sexualizacionNoInsulto = c("sexy", "caliente", "atractivo", "atractiva", "atractivos", "atractivas", "guapo", "guapa", "guapos", "guapas", "buenorro", "buenorra", "buenorros", "buenorras", "macizo", "maciza", "macizos", "macizas"),
  sexualizacionInsulto = c("puta", "zorra", "perra", "prostituta", "ramera", "furcia", "meretriz", "buscona", "busconas", "buscones")
)
#FUNCION PALABRAS POR CATEGORIA
contar_palabras_por_categoria <- function(df, diccionario) {
  frecuencias <- lapply(diccionario, function(palabras) {
    sapply(palabras, function(palabra) {
      sum(str_count(df$Post, fixed(palabra, ignore_case = TRUE)), na.rm = TRUE)
    })
  })
  return(frecuencias)
}

#CONTAR FRECUENCIA EN CLEAN_DATA
frecuencias_categorias <- contar_palabras_por_categoria(clean_data, diccionario)

#SUMAR POR CATEGORIA
frecuencias_totales <- sapply(frecuencias_categorias, sum, na.rm = TRUE)

#DATAFRAME FRECUENCIAS POR CATEGORIA
frecuencias_df <- data.frame(
  Categoria = names(frecuencias_totales),
  Frecuencia = frecuencias_totales
)

#DATAFRAME DESGLOSADO
detalle_palabras_df <- data.frame(
  Categoria = character(),
  Palabra = character(),
  Frecuencia = integer()
)

#DATAFRAME CON RESULTADOS  >0 Y MAX 5 PALABRAS
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

#COMBINAR DATAFRAMES Y QUE SE VEA BIEN
RESULTADO <- bind_rows(
  frecuencias_df %>% mutate(Palabra = Categoria, Frecuencia_Detalle = Frecuencia, Categoria = ""),
  detalle_palabras_df %>% rename(Frecuencia_Detalle = Frecuencia)
) %>%
  arrange(Categoria, desc(Frecuencia_Detalle)) %>%
  select(Categoria, Palabra, Frecuencia_Detalle)
colnames(combined_df) <- c("Categoria", "Palabra/Frecuencia", "Frecuencia")

#RESULTADO FINAL
print(RESULTADO)




