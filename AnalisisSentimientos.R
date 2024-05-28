library(tidyverse)
library(syuzhet)
library(tm)
library(NLP)
library(readxl)
library(wordcloud)
library(RColorBrewer)
library(openxlsx)

clean_data <- read_excel("ForoData.xlsx")

# eliminar cosas que no queeremos que aparezcan en el analisis
clean_data_Sentimientos <- clean_data %>%
  mutate(Post = iconv(Post, "UTF-8", "latin1", sub = " "),
         Post = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", " ", Post),
         Post = gsub("@\\w+", " ", Post),
         Post = gsub("[[:punct:]]", " ", Post),
         Post = gsub("[[:digit:]]", " ", Post),
         Post = gsub("http.*", " ", Post),
         Post = gsub("[ \t]{2,}", " ", Post),
         Post = gsub("^\\s+|\\s+$", "", Post),
         Post = gsub("\\n", " ", Post))

# analizar sentimientos
polarity <- get_sentiment(clean_data_Sentimientos$Post, method = "nrc", language = "spanish")

# crear dataframe y guardarlo
Sentimientos <- clean_data_Sentimientos %>%
  mutate(AnalisisSentimientos = polarity)
write.xlsx(Sentimientos, "Sentimientos.xlsx")

# Eliminar palabras comunes que no nos interesan
clean_data_Sentimientos$Post <- removeWords(clean_data_Sentimientos$Post, stopwords("spanish"))

# Dividir las palabras en 3 grupos, todas, positivas y negativas
corpus.texts.all <- Corpus(VectorSource(clean_data_Sentimientos$Post))
corpus.texts.pos <- Corpus(VectorSource(clean_data_Sentimientos$Post[polarity > 0]))
corpus.texts.neg <- Corpus(VectorSource(clean_data_Sentimientos$Post[polarity < 0]))

# Ajustes de las nubes
wordcloud_params <- list(
  max.words = 100,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2"),
  scale = c(3, 0.8),
  rot.per = 0.35,
  min.freq = 2
)
par(mfrow = c(1, 3))

# Nube de todas las palabras
png("wordcloud_all.png", width = 800, height = 800)
do.call(wordcloud, c(list(corpus.texts.all), wordcloud_params))
dev.off()

# Nube de palabras de Posts positivos
png("wordcloud_pos.png", width = 800, height = 800)
do.call(wordcloud, c(list(corpus.texts.pos), wordcloud_params))
dev.off()

# Nube de palabras de Posts negativos
png("wordcloud_neg.png", width = 800, height = 800)
do.call(wordcloud, c(list(corpus.texts.neg), wordcloud_params))
dev.off()