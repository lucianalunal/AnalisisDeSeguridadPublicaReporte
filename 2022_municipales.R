library(dplyr)

setwd("C:/Users/Jay Luna/Downloads/bd_envipe_2022_csv")

# Cargar tablas
tper_Vic2 <- read.csv("TPer_Vic2.csv")
tper_Vic1 <- read.csv("TPer_Vic1.csv")

# Estandarizar nombres y preparar datos
names(tper_Vic2) <- toupper(names(tper_Vic2))
names(tper_Vic1) <- toupper(names(tper_Vic1))

tper_Vic2 <- tper_Vic2 %>%
  mutate(
    ID_PER = as.character(ID_PER),
    FAC_ELE = as.numeric(FAC_ELE),
    FAC_HOG = as.numeric(FAC_HOG),
    FAC_ELE_AM = as.numeric(FAC_ELE_AM),
    FAC_HOG_AM = as.numeric(FAC_HOG_AM),
    CVE_ENT = sprintf("%02d", as.integer(CVE_ENT)),
    CVE_MUN = sprintf("%03d", as.integer(CVE_MUN))
  )

tper_Vic1 <- tper_Vic1 %>%
  mutate(
    ID_PER = as.character(ID_PER),
    FAC_ELE = as.numeric(FAC_ELE),
    FAC_HOG = as.numeric(FAC_HOG),
    FAC_ELE_AM = as.numeric(FAC_ELE_AM),
    FAC_HOG_AM = as.numeric(FAC_HOG_AM),
    CVE_ENT = sprintf("%02d", as.integer(CVE_ENT)),
    CVE_MUN = sprintf("%03d", as.integer(CVE_MUN))
  )

# Dominios: estado con factores generales, municipios con factores AM
dominios <- list(
  Estado = list(
    nombre = "Querétaro (Estado)",
    filtro_vic1 = quote(CVE_ENT == "22"),
    filtro_vic2 = quote(CVE_ENT == "22"),
    fac_persona = "FAC_ELE",
    fac_hogar = "FAC_HOG"
  ),
  Corregidora = list(
    nombre = "Corregidora",
    filtro_vic1 = quote(CVE_ENT == "22" & CVE_MUN == "006"),
    filtro_vic2 = quote(CVE_ENT == "22" & CVE_MUN == "006"),
    fac_persona = "FAC_ELE_AM",
    fac_hogar = "FAC_HOG_AM"
  ),
  Queretaro_mun = list(
    nombre = "Querétaro",
    filtro_vic1 = quote(CVE_ENT == "22" & CVE_MUN == "014"),
    filtro_vic2 = quote(CVE_ENT == "22" & CVE_MUN == "014"),
    fac_persona = "FAC_ELE_AM",
    fac_hogar = "FAC_HOG_AM"
  ),
  ElMarques = list(
    nombre = "El Marqués",
    filtro_vic1 = quote(CVE_ENT == "22" & CVE_MUN == "011"),
    filtro_vic2 = quote(CVE_ENT == "22" & CVE_MUN == "011"),
    fac_persona = "FAC_ELE_AM",
    fac_hogar = "FAC_HOG_AM"
  )
)

# Función para calcular indicadores (sin cambios en la lógica)
calcular_indicadores <- function(df1, df2, dominio) {
  fac_p <- dominio$fac_persona
  fac_h <- dominio$fac_hogar
  
  n1 <- df1 %>% filter(eval(dominio$filtro_vic1)) %>% nrow()
  n2 <- df2 %>% filter(eval(dominio$filtro_vic2)) %>% nrow()
  
  if(n1 == 0 | n2 == 0) {
    return(data.frame(
      geografia = dominio$nombre,
      poblacion = NA_real_, victimas = NA_real_, tasa_victimizacion = NA_real_,
      seguros_estado = NA_real_, porc_seguros_estado = NA_real_,
      preocupados_delincuencia = NA_real_, porc_preocupados = NA_real_,
      seguros_trabajo = NA_real_, porc_seguros_trabajo = NA_real_,
      mudanza_delincuencia = NA_real_,
      jueces_corruptos = NA_real_, porc_jueces_corruptos = NA_real_,
      jueces_no_corruptos = NA_real_, porc_jueces_no_corruptos = NA_real_,
      jueces_ns_nc = NA_real_, porc_jueces_ns_nc = NA_real_,
      hogares_vict_menores = NA_real_, vandalismo_hogar = NA_real_, homicidio_hogar = NA_real_
    ))
  }
  
  suma_segura <- function(df, var_sum, filtro_adicional = NULL) {
    df_filt <- df
    if(!is.null(filtro_adicional)) df_filt <- df_filt %>% filter(!!filtro_adicional)
    val <- df_filt %>% summarise(s = sum(get(var_sum), na.rm = TRUE)) %>% pull(s)
    if(is.na(val)) val <- 0
    return(val)
  }
  
  poblacion <- suma_segura(df1 %>% filter(eval(dominio$filtro_vic1)), fac_p)
  
  victimas <- df2 %>%
    filter(eval(dominio$filtro_vic2), RESUL_H == "A",
           (AP7_3_05 == 1 | AP7_3_06 == 1 | AP7_3_07 == 1 | AP7_3_08 == 1 |
              AP7_3_09 == 1 | AP7_3_10 == 1 | AP7_3_11 == 1 | AP7_3_12 == 1 |
              AP7_3_13 == 1 | AP7_3_14 == 1 | AP7_3_15 == 1 |
              (AP6_4_01 == 1 & AP6_5_01 == 1) |
              (AP6_4_02 == 1 & AP6_5_02 == 1) |
              (AP6_4_04 == 1))) %>%
    summarise(v = sum(get(fac_p), na.rm = TRUE)) %>% pull(v)
  if(is.na(victimas)) victimas <- 0
  
  tasa_vict <- ifelse(poblacion > 0, (victimas / poblacion) * 100000, NA)
  
  seguros_estado <- suma_segura(df1 %>% filter(eval(dominio$filtro_vic1), AP4_3_3 == 1), fac_p)
  porc_seguros <- ifelse(poblacion > 0, (seguros_estado / poblacion) * 100, NA)
  
  preocupados <- suma_segura(df1 %>% filter(eval(dominio$filtro_vic1), 
                                            AP4_2_03 == 1 | AP4_2_05 == 1 | AP4_2_08 == 1 | AP4_2_11 == 1), fac_p)
  porc_preocupados <- ifelse(poblacion > 0, (preocupados / poblacion) * 100, NA)
  
  seguros_trabajo <- suma_segura(df1 %>% filter(eval(dominio$filtro_vic1), AP4_4_02 == 1), fac_p)
  porc_seguros_trabajo <- ifelse(poblacion > 0, (seguros_trabajo / poblacion) * 100, NA)
  
  mudanza_hogares <- suma_segura(df1 %>% filter(eval(dominio$filtro_vic1), RESUL_H %in% c("A", "B"), AP4_11_10 == 1), fac_p)
  
  corruptos <- suma_segura(df1 %>% filter(eval(dominio$filtro_vic1), AP5_5_10 == 1), fac_p)
  no_corruptos <- suma_segura(df1 %>% filter(eval(dominio$filtro_vic1), AP5_5_10 == 2), fac_p)
  ns_nc <- suma_segura(df1 %>% filter(eval(dominio$filtro_vic1), (AP5_5_10 == 9 | is.na(AP5_5_10))), fac_p)
  
  porc_corruptos <- ifelse(poblacion > 0, (corruptos / poblacion) * 100, NA)
  porc_no_corruptos <- ifelse(poblacion > 0, (no_corruptos / poblacion) * 100, NA)
  porc_ns_nc <- ifelse(poblacion > 0, (ns_nc / poblacion) * 100, NA)
  
  hogares_vict_menores <- suma_segura(df2 %>% filter(eval(dominio$filtro_vic2), RESUL_H == "A", AP6_8 == 1), fac_p)
  vandalismo <- suma_segura(df2 %>% filter(eval(dominio$filtro_vic2), RESUL_H == "A", AP6_4_03 == 1), fac_p)
  homicidio <- suma_segura(df2 %>% filter(eval(dominio$filtro_vic2), RESUL_H %in% c("A", "B"), AP6_20_1 == 1), fac_p)
  
  data.frame(
    año = 2021,
    geografia = dominio$nombre,
    poblacion = poblacion,
    victimas = victimas,
    tasa_victimizacion = tasa_vict,
    seguros_estado = seguros_estado,
    porc_seguros_estado = porc_seguros,
    preocupados_delincuencia = preocupados,
    porc_preocupados = porc_preocupados,
    seguros_trabajo = seguros_trabajo,
    porc_seguros_trabajo = porc_seguros_trabajo,
    mudanza_delincuencia = mudanza_hogares,
    jueces_corruptos = corruptos,
    porc_jueces_corruptos = porc_corruptos,
    jueces_no_corruptos = no_corruptos,
    porc_jueces_no_corruptos = porc_no_corruptos,
    jueces_ns_nc = ns_nc,
    porc_jueces_ns_nc = porc_ns_nc,
    hogares_vict_menores = hogares_vict_menores,
    vandalismo_hogar = vandalismo,
    homicidio_hogar = homicidio
  )
}

resultados_list <- lapply(dominios, function(d) {
  calcular_indicadores(tper_Vic1, tper_Vic2, d)
})

resultados_municipios <- bind_rows(resultados_list)

resultados_municipios <- resultados_municipios %>%
  mutate(across(where(is.numeric), ~ round(., 1)))

write.csv(resultados_municipios, "resultados_municipios_2022.csv", row.names = FALSE)

print(resultados_municipios)