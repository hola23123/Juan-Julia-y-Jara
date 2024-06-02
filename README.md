# README

Juan Calvo, Jara Martínez y Jara Montes 2024-06-02

# Análisis de Sentimientos y Tendencias en el Foro Forocoches sobre el Festival de Eurovisión 2024

Este proyecto tiene como objetivo analizar los sentimientos y tendencias en el foro “Forocoches” respecto al Festival de Eurovisión 2024. El análisis se basa en datos recopilados de los foros utilizando técnicas de web scraping y diversas librerías de R para la manipulación y visualización de datos.

## Tabla de Contenidos

-   [Descripción del Proyecto](#descripción-del-proyecto)
-   [Instalación](#instalación)
-   [Uso](#uso)
-   [Scripts](#scripts)
    -   [CODIGO_FINAL_EUROVISION.R](#codigo_final_eurovisionr)
    -   [GraficosDIAS.R](#graficosdiasr)
    -   [GraficoHORAS.R](#graficohorasr)
    -   [diccionarioGrande.R](#diccionariogrander)
    -   [GraficoCATEGORIAS.R](#graficocategoriasr)
    -   [GraficosCategoriasDesglosado.R](#graficoscategoriasdesglosador)
    -   [AnalisisSentimientos.R](#analisissentimientosr)
-   [Contacto](#contacto)

## Descripción del Proyecto {#descripción-del-proyecto}

Este proyecto se centra en analizar las publicaciones de la comunidad hispanohablante de Forocoches en relación con el Festival de Eurovisión 2024 para extraer tendencias y sentimientos generales en torno a él. Los principales objetivos incluyen clasificar la polarización política, analizar tendencias de palabras relacionadas con el festival, identificar picos de actividad y analizar la evolución temporal de los sentimientos.

## Instalación {#instalación}

Para ejecutar este proyecto, necesitarás los siguientes paquetes de R:

\`\`\`r library(tidyverse) library(rvest) library(glue) library(xlsx) library(readxl) library(lubridate) library(ggplot2) library(stringr) library(writexl) library(syuzhet) library(tm) library(NLP) library(wordcloud) library(RColorBrewer) library(openxlsx)

## Uso {#uso}

git clone <https://github.com/hola23123/Juan-Julia-y-Jara.git> cd Juan-Julia-Jara

## Scripts {#scripts}

Se han realizado los siguientes análisis utilizando diferentes scripts en R para obtener una comprensión profunda de los datos y visualizaciones del foro Forocoches respecto al Festival de Eurovisión 2024. A continuación se describe cada script y su propósito:

### **CODIGO_FINAL_EUROVISION.R** {#codigo_final_eurovisionr}

Este script crea la base de datos a partir de los foros de Forocoches sobre Eurovisión 2024. Utiliza web scraping para extraer los comentarios y nombres de usuario del hilo HILO OFICIAL EUROVISIÓN 2024 (Malmö, Suecia)”, y luego crea una base de datos que se usará para el análisis subsiguiente.

### **GraficosDIAS.R** {#graficosdiasr}

Genera un gráfico de la cantidad de mensajes enviados según el día, desde el día 8 hasta el 14 de mayo. Utiliza ggplot2 para la visualización de los datos, mostrando los picos de actividad diaria en el foro.

### **GraficoHORAS.R** {#graficohorasr}

Crea un gráfico que muestra la cantidad de mensajes enviados según la hora del día. Esto ayuda a identificar los momentos de mayor actividad en el foro durante cada día del período analizado.

### **diccionarioGrande.R** {#diccionariogrander}

Este script define un diccionario categorizado a partir del análisis visual de los foros. Las categorías incluyen Insultos, Sexualización No Insulto, Sexualización Insulto, Homofobia, Bodyshaming, Política y Desprecio General. Cada categoría contiene una lista de palabras relevantes que se buscarán en los mensajes.

### **GraficoCATEGORIAS.R** {#graficocategoriasr}

Genera un gráfico que muestra la cantidad de palabras detectadas en cada categoría definida en el diccionario del script diccionarioGrande.R. Este gráfico ayuda a visualizar la frecuencia de uso de términos específicos dentro de cada categoría.

### **GraficosCategoriasDesglosado.R** {#graficoscategoriasdesglosador}

Crea siete gráficos, uno por cada categoría del diccionario, mostrando las cinco palabras más utilizadas en cada una. Esto proporciona una vista detallada de los términos más frecuentes en cada categoría de interés.

### **AnalisisSentimientos.R** {#analisissentimientosr}

Realiza un análisis de sentimientos de todos los mensajes en el foro. Utiliza el paquete syuzhet para evaluar cuantitativamente las emociones expresadas en los comentarios. Además, genera tres nubes de palabras: una con todas las palabras importantes, otra con palabras relacionadas con mensajes negativos y otra más con palabras relacionadas con mensajes positivos.

## Contacto {#contacto}

Para preguntas o sugerencias, por favor contacta a:

Juan Calvo López, Julia Martínez Alonso o Jara Montes Herreros
