library(tidyverse)
library(rvest)
library(glue)
library(xlsx)
library(readxl)
library(stringr)
library(writexl)

#BASE DE DATOS
clean_data <- read_excel("ForoData.xlsx")

#DICCIONARIO DE PRUEBA, AL CAMBIARLO CAMBIARLO EN EL OTRO SCRIPT
Insultos=c("idiota", "idiotas", "estúpido", "estúpida", "estúpidos", "estúpidas", "imbécil", "imbéciles", "tonto", "tonta", "tontos", "tontas", "gilipollas", "capullo", "capulla", "capullos", "capullas", "payaso", "payasa", "payasos", "payasas", "cabrón", "cabrona", "cabrones", "cabronas", "subnormal", "subnormales", "hijo de puta", "hija de puta", "hijos de puta", "hijas de puta", "cretino", "cretina", "cretinos", "cretinas", "mamón", "mamona", "mamones", "mamonas", "caraculo", "caraculos", "miserable", "miserables", "bobo", "boba", "bobos", "bobas", "lameculos", "pelota", "pelotas", "soplagaitas", "cabestro", "cabestros", "tarado", "tarada", "tarados", "taradas", "jilipollas", "zángano", "zángana", "zánganos", "zánganas", "zopenco", "zopenca", "zopencos", "zopencas", "lechón", "lechona", "lechones", "lechonas", "cachondo", "cachonda", "cachondos", "cachondas", "pardillo", "pardilla", "pardillos", "pardillas", "desgraciado", "desgraciada", "desgraciados", "desgraciadas", "cenutrio", "cenutria", "cenutrios", "cenutrias", "petardo", "petarda", "petardos", "petardas", "chupatintas", "chupatintas", "mamonazo", "mamonaza", "mamonazos", "mamonazas", "maricón", "maricona", "maricones", "mariconas", "mierda", "mierdas", "farsante", "farsantes", "gañán", "gañana", "gañanes", "gañanas", "mequetrefe", "mequetrefes", "botarate", "botarates", "tontolaba", "tontolabas", "imbécil de mierda", "imbéciles de mierda", "mocoso", "mocosa", "mocosos", "mocosas", "ñú", "ñús", "gilipuertas", "bocazas", "tontaina", "tontainas", "tontorrón", "tontorrona", "tontorróns", "tontorronas", "papanatas", "panoli", "panolis", "tontarra", "tontarras", "tolai", "tolais", "fantasma", "fantasmas", "cansino",
           "cansina", "cansinos", "cansinas", "estúpido de mierda", "estúpida de mierda", "estúpidos de mierda", "estúpidas de mierda", "matao", "mataos", "perroflauta", "perroflautas", "malnacido", "malnacida", "malnacidos", "malnacidas", "bastardo", "bastarda", "bastardos", "bastardas", "baboso", "babosa", "babosos", "babosas", "mosquita muerta", "mosquitas muertas", "metomentodo", "metomentodos", "penco", "penca", "pencos", "pencas", "bocachancla", "bocachanclas", "pesado", "pesada", "pesados", "pesadas", "puñetero", "puñetera", "puñeteros", "puñeteras", "petulante", "petulantes", "flipado", "flipada", "flipados", "flipadas", "creído", "creída", "creídos", "creídas", "patán", "patana", "patanes", "patanas", "merluzo", "merluza", "merluzos",
           "merluzas", "mongolo", "mongola", "mongolos", "mongolas", "patético", "patética", "patéticos", "patéticas", "pelagatos", "pelagatos", "cansao", "cansaos", "pelagambas", "pelagambas", "pegaplatos", "pegaplatos", "huevón", "huevona", "huevones", "huevonas", "pollaboba", "pollabobas", "tontolculo", "tontolculos", "chupaculos", "parguela", "parguelas", "gusano", "gusana", "gusanos", "gusanas", "tarugo", "taruga", "tarugos", "tarugas", "pelele", "peleles", "pelele de mierda", "peleles de mierda", "miserable de mierda", "miserables de mierda", "despojo", "despojos", "pelocha", "pelochas", "pelochera", "pelocheras", "casposo", "casposa", "casposos", "casposas", "gafapasta", "gafapastas", "gili", "gilis", "lamebotas", "cabezón", "cabezona", "cabezones", "cabzonas", "tocahuevos", "gordinflón", "gordinflona", "gordinflones", "gordinflonas", "cabeza de chorlito", "cabezas de chorlito", "mamón de mierda", "mamona de mierda", "mamones de mierda", "mamonas de mierda", "cacho carne", "cachos carne", "paquete", "paquetes", "inútil", "inútiles", "colgadera", "colgaderas", "espanto", "espanta", "espantos", "espantas", "odio", "odios", "extraterrestre", "extraterrestres", "floja", "flojas", "mala", "malas", "hacendado", "hacendada", "hacendados", "hacendadas", "ridícula", "ridículas", "cansino", "cansina", "cansinos", "cansinas", "coñazo", "coñazos", "tostón", "tostones", "chalada", "chaladas", "chiquilicuatre", "chiquilicuatres", "Ignatius", "chustas", "repelente", "repelentes", "fulano", "fulana", "fulanos", "fulanas")
SexualizacionNoInsulto = c("sexy", "sexys", "caliente", "calientes", "atractivo", "atractiva", "atractivos", "atractivas", "guapo", "guapa", "guapos", "guapas", "buenorro", "buenorra", "buenorros", "buenorras", "macizo", "maciza", "macizos", "macizas", "tetas", "lolas", "buenorra", "buenorras", "pibonazo", "pibonazos", "pezón", "pezones", "pechugona", "pechugonas", "jamona", "jamonas", "muslaco", "muslaca", "muslacos", "muslacas", "tetona", "tetonas", "tetillas", "tetilla", "tetitas", "tetita", "tetazas", "tetaza", "tetorro", "tetorros", "tetorras", "tetorra", "teta", "tetas", "tete", "tetas", "teto", "tetas", "teta", "tetas", "teton", "tetonas")
SexualizacionInsulto = c("puta", "putas", "zorra", "zorras", "perra", "perras", "prostituta", "prostitutas", "ramera", "rameras", "furcia", "furcias", "meretriz", "meretrices", "buscona", "busconas", "buscones", "zorrita", "zorritas", "cachonda", "cachondas", "me pone", "pa ponerla mirando", "follable", "follables", "Pornhub", "melafo", "mefo", "Raluca", "estela reynolds", "empotrarla", "hembras", "perra", "perras", "fresco", "fresca", "frescos", "frescas")
Homofobia = c("maricón", "maricones", "gay", "gays", "gai", "gais", "marikon", "mariquita", "mariquitas", "maricona", "mariconas", "homo", "homos", "homovision", "mariflor", "mariflores", "Transexual", "Transexuales", "trans", "travolo", "travolos", "lgtbi", "plumovision", "Gayómetro")
Bodyshaming = c("gordo", "gorda", "gordos", "gordas", "flaco", "flaca", "flacos", "flacas", "peso", "pesos", "botox", "fea", "feas", "feo", "feos", "obeso", "obesa", "obesos", "obesas", "fofo", "fofa", "fofos", "fofas", "rechoncho", "rechoncha", "rechonchos", "rechonchas", "esquelético", "esquelética", "esqueléticos", "esqueléticas", "barrigón", "barrigona", "barrigones", "barrigonas", "anoréxico", "anoréxica", "anoréxicos", "anoréxicas", "demacrado", "demacrada", "demacrados", "demacradas", "escuálido", "escuálida", "escuálidos", "escuálidas", "mofletudo", "mofletuda", "mofletudos", "mofletudas", "fofisano", "fofisana", "fofisanos", "fofisanas")
Politica = c("Israel", "gobierno", "gobiernos", "elección", "elecciones", "terrorista", "terroristas", "Netanhayu", "Netanyahu", "islam", "musulmán", "musulmana", "musulmanes", "musulmanas", "antisemita", "antisemitas", "jewrovision", "antiprogre", "antiprogres", "progre", "progres", "propalestina", "propalestinas", "guerra", "guerras", "proterrorista", "proterroristas", "sionista", "sionistas", "genocidio", "genocidios", "genocida", "genocidas", "musulmanismo", "morito", "moritos", "moro", "moros", "projudio", "projudios", "woke", "wokes")
DesprecioGeneral = c("horrible", "horribles", "abucheo", "abucheos", "next", "mierda", "mierdas", "imitación", "imitaciones", "imitador", "imitadora", "imitadores", "imitadoras", "peor", "peores", "fatal", "desafinando", "basura", "basuras", "frikada", "frikadas", "fricada", "fricadas", "friki", "frikis", "plagio", "plagios", "plagiado", "plagiada", "plagiados", "plagiadas", "copia", "copias", "truño", "truños", "aburre", "aburren", "aburrido", "aburrida", "aburridos", "aburridas", "tongo", "tongos", "tongazo", "tongazos", "aberración", "aberraciones", "despropósito", "despropósitos", "extraña", "extrañas", "extraño", "extraños", "grima", "asqueroso", "asquerosa", "asquerosos", "asquerosas", "asco", "ascos", "lamentable", "lamentables", "chapuza", "chapuzas", "troll", "trolls", "playback", "horror", "horrores")

diccionario <- list(
  Insultos = Insultos,
  SexualizacionNoInsulto = SexualizacionNoInsulto,
  SexualizacionInsulto = SexualizacionInsulto,
  Homofobia = Homofobia,
  Bodyshaming = Bodyshaming,
  Politica = Politica,
  DesprecioGeneral = DesprecioGeneral
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
  frecuencias_df %>% mutate(Palabra = Categoria, Frecuencia_palabras = Frecuencia, Categoria = ""),
  detalle_palabras_df %>% rename(Frecuencia_palabras = Frecuencia)
) %>%
  arrange(Categoria, desc(Frecuencia_palabras)) %>%
  select(Categoria, Palabra, Frecuencia_palabras)
colnames(RESULTADO) <- c("Categoria", "Palabra/Frecuencia", "Frecuencia")

#RESULTADO FINAL
print(RESULTADO)

#GUARDAR EN XLSX
write.xlsx(RESULTADO, "Diccionario.xlsx")


