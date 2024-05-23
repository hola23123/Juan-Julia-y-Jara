library(tidyverse)
library(rvest)
library(glue)
library(xlsx)
library(readxl)

# Función para extraer datos de forocoches
extract_page_data <- function(url, page_number) {
  full_url <- glue("{url}&page={page_number}")
  html <- read_html(full_url)
  
  # Extraer las fechas
  datos <- html %>%
    html_elements(".old") %>%
    html_text2() %>%
    str_trim() %>%
    str_replace_all("\\s+", " ")
  
  # Extraer los mensajes
  posts <- html %>%
    html_elements("td") %>%
    html_text2() %>%
    str_trim() %>%
    str_replace_all("\\s+", " ")
  
  # Verificar si se han encontrado fechas y mensajes
  if (length(datos) == 0 | length(posts) == 0) {
    message(glue("No se encontraron datos en la página {page_number}."))
    return(tibble(Date = character(), Post = character()))
  }
  
  # Asegurarse de que ambos vectores tengan el mismo tamaño
  max_length <- max(length(datos), length(posts))
  datos <- c(datos, rep(NA, max_length - length(datos)))
  posts <- c(posts, rep(NA, max_length - length(posts)))
  
  # Combinar fechas y mensajes
  data <- tibble(Date = datos, Post = posts)
  return(data)
}

# Definir las URLs y sus rangos de páginas correspondientes
urls <- list(
  list(url = "https://forocoches.com/foro/showthread.php?t=9787076", pages = 25:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958328", pages = 1:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958375", pages = 1:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958422", pages = 1:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958487", pages = 1:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958539", pages = 1:46)
)

# Inicializar un data frame vacío
all_data <- tibble(Date = character(), Post = character())

# Iterar sobre las URLs y sus rangos de páginas
for (link in urls) {
  url <- link$url
  pages <- link$pages
  
  for (page in pages) {
    page_data <- extract_page_data(url, page)
    if (nrow(page_data) > 0) {
      all_data <- bind_rows(all_data, page_data)
    }
  }
}

#DESCARGAR ALL_DATA
write_excel_csv(all_data, "all_data_Raw.xlsx")

#LIMPIA VARRIABLES CON NA O EQUIVOCADOS AL SACAR
clean_data <- all_data %>%
  filter(Post != "", 
         !str_detect(Post, "^\\s*$"), 
         !str_detect(Post, "^\\d+$"), 
         Post != "Herramientas", 
         Post != "Mostrar Versión Imprimible Enviar por Email")

clean_data <- clean_data %>%
  mutate(Date = str_replace_all(Date, "Editado: ", "")) %>%
  mutate(Date = str_replace_all(Date, " -", ""))

# ELIMINAR CITAS
clean_data <- clean_data %>%
  filter(!str_starts(Post, "Cita de"))

#ELIMINAR PRIMERA COLUMNA, NO NECESARRIO?
########clean_data <- clean_data %>% select(-...1)

#ELIMINAR # Y NUMEROS PEGADOS AL #
remove_hash_numbers <- function(post) {
  cleaned_post <- str_replace_all(post, "#\\d+", "")
  return(cleaned_post)
}
clean_data <- clean_data %>%
  mutate(Post = map_chr(Post, remove_hash_numbers))

#ELIMINAR COMILLAS
remove_quotes <- function(post) {
  cleaned_post <- str_replace_all(post, '["\']', "")
  return(cleaned_post)
}
clean_data <- clean_data %>%
  mutate(Post = map_chr(Post, remove_quotes))



