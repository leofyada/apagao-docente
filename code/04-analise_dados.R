#-----------------------------------------------
#- 1-) Análise de dados por regional de ensino -
#-----------------------------------------------

# Importação da base de regionais
df_regionais <- data.table::fread(here("data", "prata", "df_regionais_limpa.csv"))
# Importação da base do SiSU
df_sisu <- data.table::fread(here("data", "prata", "df_sisu_licenciatura.csv"))
# Importação da base de oferta e demanda
df_oferta_demanda <- data.table::fread(here("data", "prata", "df_oferta_demanda.csv"))
# Importação da base de bolsas distribuídas
df_bolsas_distribuidas <- data.table::fread(here("data", "prata", "df_bolsas_distribuidas.csv"))

# Inclusão da regional na base de bolsas distribuídas
df_bolsas_distribuidas_tratada <- df_bolsas_distribuidas %>% 
  left_join(
    y=df_regionais, by=c("CO_MUNICIPIO_IES"="co_municipio")
  ) %>% 
  select(
    UF, regional, no_curso_aj_2, n, 
  ) %>% 
  rename("sg_uf" = "UF", "no_curso_aj" = "no_curso_aj_2")

# Inclusão da regional de ensino na base do SiSU
df_sisu_tratada <- df_sisu %>% 
  left_join(
    y=df_regionais, by=c("co_municipio", "no_municipio")
  ) %>% 
  rename("no_curso" = "NOME_CURSO_AJ_2") %>% 
  group_by(UF_CAMPUS, co_uf, no_uf, regional, no_curso) %>% 
  reframe(
    abaixo_550_abaixo_650 = sum(abaixo_550_abaixo_650, na.rm=T),
    acima_550_abaixo_650 = sum(acima_550_abaixo_650, na.rm=T),
    acima_550_acima_650 = sum(acima_550_acima_650, na.rm=T)
  )

# Inclusão dos dados do SiSU na base de oferta e demanda
df_oferta_demanda_tratada <- df_oferta_demanda %>% 
  left_join(
    y=df_sisu_tratada, by=c("regional", "no_curso_aj"="no_curso", "sg_uf"="UF_CAMPUS")
  )

# Inclusão outras análises
df_oferta_demanda_tratada <- df_oferta_demanda_tratada %>% 
  mutate(
    abaixo_550_abaixo_650 = ifelse(is.na(abaixo_550_abaixo_650), 0, abaixo_550_abaixo_650),
    acima_550_abaixo_650 = ifelse(is.na(acima_550_abaixo_650), 0, acima_550_abaixo_650),
    acima_550_acima_650 = ifelse(is.na(acima_550_acima_650), 0, acima_550_acima_650),
    match_550 = ifelse(acima_550_abaixo_650 <= qtd_bolsas_elegiveis, acima_550_abaixo_650, qtd_bolsas_elegiveis),
    match_650 = ifelse(acima_550_acima_650 <= qtd_bolsas_elegiveis, acima_550_acima_650, qtd_bolsas_elegiveis),
    match_demanda_concluintes = ifelse(demanda <= concluintes, demanda, concluintes)
  ) %>% 
  select(-c(co_uf, no_uf)) %>% 
  filter(no_curso_aj != "computacao")

# Inclusão de bolsas distribuídas
df_final <- df_oferta_demanda_tratada %>% 
  left_join(
    y=df_bolsas_distribuidas_tratada, by=c("regional", "no_curso_aj", "sg_uf")
  ) %>% 
  rename("qtd_bolsas_distribuidas"="n") %>% 
  mutate(
    qtd_bolsas_distribuidas = ifelse(is.na(qtd_bolsas_distribuidas), 0, qtd_bolsas_distribuidas),
    bolsas_distribuidas_match_550 = ifelse(qtd_bolsas_distribuidas <= match_550, qtd_bolsas_distribuidas, match_550),
    bolsas_distribuidas_match_650 = ifelse(qtd_bolsas_distribuidas <= match_650, qtd_bolsas_distribuidas, match_650)
  )

# Exporta base final para análise
writexl::write_xlsx(df_final, path=here("data", "ouro", glue("{Sys.Date()}-df_analise_final.xlsx")))

# Remove arquivos
rm(df_regionais, df_sisu, df_oferta_demanda, df_sisu_tratada, df_oferta_demanda_tratada, df_bolsas_distribuidas, df_bolsas_distribuidas_tratada, df_final)
gc()

