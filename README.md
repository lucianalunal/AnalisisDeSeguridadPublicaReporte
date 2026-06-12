# Análisis de Seguridad Pública y Percepción Ciudadana en Querétaro (2019-2024)

Este proyecto realiza un análisis estadístico y metodológico de la seguridad pública, la victimización y la percepción ciudadana en el estado de **Querétaro** y los municipios de su zona metropolitana (**Querétaro**, **Corregidora** y **El Marqués**), utilizando los microdatos de la **Encuesta Nacional de Victimización y Percepción sobre Seguridad Pública (ENVIPE)** del INEGI para los años de levantamiento **2020 a 2025** (que corresponden a los años de referencia **2019 a 2024**).

El análisis fue desarrollado en el marco del programa de **Ingeniería Matemática** para evaluar el impacto de la inseguridad objetiva y subjetiva en el comportamiento y bienestar social.

---

## 📋 Contenido del Repositorio

El repositorio está organizado de la siguiente manera:

*   **Códigos de Procesamiento (`.R`)**:
    *   `2020_municipales.R` a `2025_municipales.R`: Scripts individuales para la lectura de las tablas originales de la ENVIPE (`TPer_Vic1.dbf` y `TPer_Vic2.dbf`), filtrado por zona geográfica, aplicación de factores de expansión y cálculo de indicadores clave.
*   **Bases de Datos Procesadas (`.csv`)**:
    *   `resultados_municipios_2020.csv` a `resultados_municipios_2025.csv`: Tablas resultantes con indicadores consolidados a nivel estatal y municipal para cada año de estudio.
*   **Reporte Final (`reporte_v4.*`)**:
    *   `reporte_v4.Rmd`: Archivo fuente en R Markdown que consolida el análisis, genera la visualización gráfica y compila el documento explicativo.
    *   `reporte_v4.pdf`: Documento final compilado mediante LaTeX (XeLaTeX) con la presentación formal de los hallazgos y gráficos descriptivos.
*   **Configuración (`.gitignore`)**:
    *   Filtros específicos para omitir archivos temporales de R (como `.RDataTmp`, `.Rhistory`, directorios de caché, etc.).

---

## 🛠️ Requisitos e Instalación

Para replicar el análisis y compilar el reporte R Markdown, es necesario contar con:

1.  **R** (versión 4.0 o superior) y **RStudio** (recomendado).
2.  Las siguientes librerías de R instaladas:
    ```r
    install.packages(c("dplyr", "ggplot2", "readr", "tidyr", "scales", "foreign"))
    ```
3.  Una distribución de LaTeX (como MikTeX o TinyTeX) para compilar a formato PDF:
    ```r
    tinytex::install_tinytex() # Opcional si usas TinyTeX en R
    ```
4.  **Microdatos de la ENVIPE (INEGI)**:
    Para ejecutar los scripts de procesamiento (`*_municipales.R`), debes descargar los microdatos de cada año en formato `.dbf` desde el sitio web de INEGI y colocarlos en la ruta correspondiente (o modificar el `setwd` en los scripts). El análisis requiere las tablas:
    *   `TPer_Vic1.dbf`
    *   `TPer_Vic2.dbf`

---

## 📐 Aspectos Metodológicos Clave

*   **Factores de Expansión**: Se utilizaron de forma rigurosa los pesos muestrales provistos por el INEGI:
    *   `FAC_ELE` / `FAC_ELE_AM`: Para inferencia sobre variables a nivel de persona (percepción y victimización personal).
    *   `FAC_HOG` / `FAC_HOG_AM`: Para variables a nivel de vivienda u hogar (homicidio, vandalismo, secuestro).
*   **Representatividad Municipal**: La representatividad local de la ENVIPE en Querétaro está estrictamente delimitada al Área Urbana de Interés (AUI, código 36), que abarca los municipios de Querétaro, Corregidora y El Marqués.
*   **Estabilidad Temporal**: El reporte aborda la inestabilidad de las muestras previas a 2024 (ruido estadístico debido a un bajo número de Unidades Primarias de Muestreo en los municipios) y destaca la mejora metodológica introducida en la encuesta de 2025 (referencia 2024) mediante la ampliación del marco muestral.

---

## 📈 Hallazgos Principales

1.  **Crecimiento Poblacional**: La población adulta (18+) en Querétaro experimentó un crecimiento acelerado de más del 30% entre 2019 y 2024, pasando de 1.37 millones a 1.84 millones.
2.  **Tasa de Victimización**: Después de una caída durante la pandemia (2020), la tasa estatal repuntó hasta alcanzar **28,790 víctimas por cada 100,000 habitantes** en 2024.
3.  **Percepción frente a Realidad**: Existe una brecha significativa; mientras que la tasa de victimización afecta a casi el 28% de la población, el **85.3%** vive preocupado por la delincuencia, y solo el **41.1%** manifiesta sentirse seguro en el estado.
4.  **Desplazamiento Forzado**: En 2024 se reportó la cifra más alta de hogares que tuvieron que cambiar de residencia por miedo a la inseguridad, superando los **21,000 hogares**.
5.  **Confianza en las Instituciones**: Se observa un escepticismo persistente hacia los encargados de impartir justicia; entre el **21%** y el **32%** de los encuestados perciben a los jueces como corruptos, variando según el ámbito metropolitano.

---

## 👥 Autores

*   **Luna Aguado Luciana**
*   **Ramírez Mendoza Jorge Raúl**
