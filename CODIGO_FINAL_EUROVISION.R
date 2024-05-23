library(tidyverse)
library(rvest)
library(glue)
library(xlsx)
library(readxl)

#RVEST EXTRAER DATOS HTML
extract_page_data <- function(url, page_number) {
  full_url <- glue("{url}&page={page_number}")
  html <- read_html(full_url)
  
  #SACA FECHAS DE HTML CON .OLD
  datos <- html %>%
    html_elements(".old") %>%
    html_text2() %>%
    str_trim() %>%
    str_replace_all("\\s+", " ")
  
  #SACA MENSAJES DE HTML CON TD
  posts <- html %>%
    html_elements("td") %>%
    html_text2() %>%
    str_trim() %>%
    str_replace_all("\\s+", " ")
  
  #HACE QUE TENGAN MIS TAMAÑO AMBOS VECTORES
  max_length <- max(length(datos), length(posts))
  datos <- c(datos, rep(NA, max_length - length(datos)))
  posts <- c(posts, rep(NA, max_length - length(posts)))
  
  #COMBINA FECHAS Y MENSAJES
  data <- tibble(Date = datos, Post = posts)
  return(data)
}

#URLS CON LAS PAGINAS QUE QUEREMOS
urls <- list(
  list(url = "https://forocoches.com/foro/showthread.php?t=9787076", pages = 25:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958328", pages = 1:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958375", pages = 1:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958422", pages = 1:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958487", pages = 1:67),
  list(url = "https://forocoches.com/foro/showthread.php?t=9958539", pages = 1:46)
)

#CREA DATAFRAME VACIO
all_data <- tibble(Date = character(), Post = character())

#JUNTA LAS URLS Y LAS PAGINAS
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



