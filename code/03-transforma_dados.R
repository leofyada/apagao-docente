#-------------------------------------------------
#- 1-) Tratamento da base de regionais de ensino -
#-------------------------------------------------

# Importa dados das regionais
regionais_bruta <- fread(here("data", "bronze", "regionais_municipios.csv"))
# Importa a base de dados do IBGE
df_ibge <- readxl::read_xls(here("data", "bronze", "RELATORIO_DTB_BRASIL_2024_MUNICIPIOS.xls"), skip = 5)
# Exclusão da última coluna (sem dados)
df_ibge_filtrada <- df_ibge %>% 
  select(UF, Nome_UF, `Código Município Completo`, Nome_Município) %>% 
  rename(
    "co_uf" = "UF",
    "no_uf" = "Nome_UF",
    "co_municipio" = "Código Município Completo",
    "no_municipio" = "Nome_Município"
  )

# Ajuste de 1 regional para 2 municípios
df_regionais_tratada <- regionais_bruta %>% 
  filter(!(municipio %in% c("Olinda e Paulista", "Moreno e São Lourenço da Mata"))) 

regional_dupla <- tibble(
  UF=c("PE", "PE", "PE", "PE"),
  regional=c("METROPOLITANA NORTE", "METROPOLITANA NORTE", "METROPOLITANA SUL", "METROPOLITANA SUL"),
  municipio=c("Olinda", "Paulista", "Moreno", "São Lourenço da Mata")
) 
df_regionais_tratada <- rbind(df_regionais_tratada, regional_dupla)

# Ajuste de municípios
df_regionais_tratada <- df_regionais_tratada %>% 
  mutate(
    municipio = case_when(
      municipio=="ALAGOINHAS" & UF=="PI" ~ "Alagoinha do Piauí", 
      municipio=="Aparecida do Tabuado" & UF=="MS" ~ "Aparecida do Taboado", 
      municipio=="Armação de Búzios" & UF=="RJ" ~ "Armação dos Búzios",
      municipio=="assu" & UF=="RN" ~ "Açu",
      municipio=="avelino" & UF=="RN" ~ "Pedro Avelino",
      municipio=="BARÃO DE MONTE ALTO" & UF=="MG" ~ "Barão do Monte Alto",
      municipio=="BARRA DALCANTARA" & UF=="PI" ~ "Barra D'Alcântara",
      municipio=="BETANIA" & UF=="PI" ~ "Betânia do Piauí",
      municipio=="BOA HORA-PI" & UF=="PI" ~ "Boa Hora",
      municipio=="boa saude" & UF=="RN" ~ "Januário Cicco",
      municipio=="BOQUEIRAO" & UF=="PI" ~ "Boqueirão do Piauí",
      municipio=="BREJO" & UF=="PI" ~ "Brejo do Piauí",
      municipio=="caicara do rio dos ventos" & UF=="RN" ~ "Caiçara do Rio do Vento",
      municipio=="CAJAZEIRAS" & UF=="PI" ~ "Cajazeiras do Piauí",
      municipio=="CAPITAL GERVASIO OLIVEIRA" & UF=="PI" ~ "Capitão Gervásio Oliveira",
      municipio=="CARAUBAS" & UF=="PI" ~ "Caraúbas do Piauí",
      municipio=="CAXINGOS" & UF=="PI" ~ "Caxingó",
      municipio=="ceara mirim" & UF=="RN" ~ "Ceará-Mirim",
      municipio=="Colônia de Leopoldina" & UF=="AL" ~ "Colônia Leopoldina",
      municipio=="conceicao do lago acu" & UF=="MA" ~ "Conceição do Lago-Açu",
      municipio=="Couto de Magalhães" & UF=="TO" ~ "Couto Magalhães",
      municipio=="CURRAL NOVO" & UF=="PI" ~ "Curral Novo do Piauí",
      municipio=="CURRALINHO" & UF=="PI" ~ "Curralinhos",
      municipio=="Major Izidoro" & UF=="AL" ~ "Major Isidoro",
      municipio=="DIAS D AVILA" & UF=="BA" ~ "Dias d'Ávila",
      municipio=="EMBU GUACU" & UF=="SP" ~ "Embu-Guaçu",
      municipio=="FARTUNA DO PIAUI" & UF=="PI" ~ "Fartura do Piauí",
      municipio=="felipe de guerra" & UF=="RN" ~ "Felipe Guerra",
      municipio=="fernando pedrosa" & UF=="RN" ~ "Fernando Pedroza",
      municipio=="GERMINIANO" & UF=="PI" ~ "Geminiano",
      municipio=="governador luis rocha" & UF=="MA" ~ "Governador Luiz Rocha",
      municipio=="governador ribamar fiquene" & UF=="MA" ~ "Ribamar Fiquene",
      municipio=="GUARANI D OESTE" & UF=="SP" ~ "Guarani d'Oeste",
      municipio=="ILHA GRANDE DO PIAUI" & UF=="PI" ~ "Ilha Grande",
      municipio=="ipixuna" & UF=="PA" ~ "Ipixuna do Pará",
      municipio=="VILA NOVA" & UF=="PI" ~ "Vila Nova do Piauí",
      municipio=="veracruz" & UF=="RN" ~ "Vera Cruz",
      municipio=="JATOBA" & UF=="PI" ~ "Jatobá do Piauí",
      municipio=="são vicente de ferrer" & UF=="MA" ~ "São Vicente Ferrer",
      municipio=="itapecuru-mirim" & UF=="MA" ~ "Itapecuru Mirim",
      municipio=="lageado novo" & UF=="MA" ~ "Lajeado Novo",
      municipio=="olho dagua das cunhas" & UF=="MA" ~ "Olho d'Água das Cunhãs",
      municipio=="ipanguassu" & UF=="RN" ~ "Ipanguaçu",
      municipio=="peri-mirim" & UF=="MA" ~ "Peri Mirim",
      municipio=="GUARIBAS DO PIAUI" & UF=="PI" ~ "Guaribas",
      municipio=="venha ver" & UF=="RN" ~ "Venha-Ver",
      municipio=="Várze Alegre" & UF=="CE" ~ "Várzea Alegre",
      municipio=="TANQUES DO PIAUI" & UF=="PI" ~ "Tanque do Piauí",
      municipio=="TAMBORIL" & UF=="PI" ~ "Tamboril do Piauí",
      municipio=="tabuleiro grande" & UF=="RN" ~ "Taboleiro Grande",
      municipio=="SÍTIO D ABADIA" & UF=="GO" ~ "Sítio d'Abadia",
      municipio=="senador georgino" & UF=="RN" ~ "Senador Georgino Avelino",
      municipio=="são mateus" & UF=="MA" ~ "São Mateus do Maranhão",
      municipio=="são luiz gonzaga do maranhao" & UF=="MA" ~ "São Luís Gonzaga do Maranhão",
      municipio=="SAO LUIS" & UF=="PI" ~ "São Luís do Piauí",
      municipio=="são jose de campestre" & UF=="RN" ~ "São José do Campestre",
      municipio=="SAO JOAO VARJOTA" & UF=="PI" ~ "São João da Varjota",
      municipio=="SÃO JOÃO D ALIANÇA" & UF=="GO" ~ "São João d'Aliança",
      municipio=="SAO F. DE ASSIS DO PIAUI" & UF=="PI" ~ "São Francisco de Assis do Piauí",
      municipio=="são domingos" & UF=="MA" ~ "São Domingos do Maranhão",
      municipio=="São Braz" & UF=="AL" ~ "São Brás",
      municipio=="santo amaro" & UF=="MA" ~ "Santo Amaro do Maranhão",
      municipio=="SANTA TERESINHA" & UF=="BA" ~ "Santa Terezinha",
      municipio=="santa filomena" & UF=="MA" ~ "Santa Filomena do Maranhão",
      municipio=="santa Bárbara" & UF=="PA" ~ "Santa Bárbara do Pará",
      municipio=="Rui Palmeira" & UF=="AL" ~ "Senador Rui Palmeira",
      municipio=="são Geraldo do araguaia e" & UF=="PA" ~ "São Geraldo do Araguaia",
      municipio=="RIBEIRA" & UF=="PI" ~ "Ribeira do Piauí",
      municipio=="presidente medice" & UF=="MA" ~ "Presidente Médici",
      municipio=="PORTO ALEGRE" & UF=="PI" ~ "Porto Alegre do Piauí",
      municipio=="Porto de Pedra" & UF=="AL" ~ "Porto de Pedras",
      municipio=="pindare" & UF=="MA" ~ "Pindaré-Mirim",
      municipio=="Pau-d'Arco" & UF=="TO" ~ "Pau D'Arco",
      municipio=="Olho D`Água Grande" & UF=="AL" ~ "Olho d'Água Grande",
      municipio=="PAU D'ARCO" & UF=="PI" ~ "Pau D'Arco do Piauí",
      municipio=="Olho D`Água do Casado" & UF=="AL" ~ "Olho d'Água do Casado",
      municipio=="olho dagua dos borges" & UF=="RN" ~ "Olho d'Água do Borges",
      municipio=="OLHO DAGUA" & UF=="PI" ~ "Olho d'Água do Piauí",
      municipio=="N.S.DE NAZARE" & UF=="PI" ~ "Nossa Senhora de Nazaré",
      municipio=="NOVO SANTO ANTONIO DO PIAUI" & UF=="PI" ~ "Novo Santo Antônio",
      municipio=="Nova Estrela" & UF=="RO" ~ "Rolim de Moura",
      municipio=="MORRO DO CHAPEU" & UF=="PI" ~ "Morro do Chapéu do Piauí",
      municipio=="MORRO CABECA DO TEMPO" & UF=="PI" ~ "Morro Cabeça no Tempo",
      municipio=="MADEIROS" & UF=="PI" ~ "Madeiro",
      municipio=="luiz gomes" & UF=="RN" ~ "Luís Gomes",
      municipio=="llhota" & UF=="SC" ~ "Ilhota",
      municipio=="lajes pintada" & UF=="RN" ~ "Lajes Pintadas",
      municipio=="LAGOINHA" & UF=="PI" ~ "Lagoinha do Piauí",
      municipio=="LAGOA DO SAO FRANCISCO" & UF=="PI" ~ "Lagoa de São Francisco",
      municipio=="LAGOA DO BARRO" & UF=="PI" ~ "Lagoa do Barro do Piauí",
      municipio=="JUREMA DO PIAUI" & UF=="PI" ~ "Jurema",
      municipio=="JUAZEIRO" & UF=="PI" ~ "Juazeiro do Piauí",
      municipio=="ITAPORANGA D AJUDA" & UF=="SE" ~ "Itaporanga d'Ajuda",
      municipio=="Itamaracá" & UF=="PE" ~ "Ilha de Itamaracá",
      municipio=="Herval d Oeste" & UF=="SC" ~ "Herval d'Oeste",
      municipio=="MASSAPE" & UF=="PI" ~ "Massapê do Piauí",
      municipio=="lagoa de pedra" & UF=="RN" ~ "Lagoa de Pedras",
      municipio=="rui barbosa" & UF=="RN" ~ "Ruy Barbosa",
      municipio=="Massagueira" & UF=="AL" ~ "Marechal Deodoro",
      municipio=="arez" & UF=="RN" ~ "Arês",
      municipio=="Vitor Meirelles" & UF=="SC" ~ "Vitor Meireles",
      (regional=="PORTO VELHO" | regional=="EXTREMA") & UF=="RO" ~ "Porto Velho",
      regional=="BURITIS" & UF=="RO" ~ "Buritis",
      regional=="CACOAL" & UF=="RO" ~ "Cacoal",
      .default = municipio
    )
  )

# Utilização do pacote enderecobr para padronizar os municípios das regionais
df_regionais_padronizada <- df_regionais_tratada %>% 
  mutate(
    municipio_s_ponto = gsub("\\.", "", municipio),
    estado_padronizado = padronizar_estados(UF),
    municipio_padronizado = padronizar_municipios(municipio_s_ponto)
  )

# Utilização do pacote enderecobr para padronizar os municípios do IBGE
df_ibge_filtrada_padronizada <- df_ibge_filtrada %>% 
  mutate(
    estado_padronizado = padronizar_estados(no_uf),
    municipio_padronizado = padronizar_municipios(no_municipio)
  )

# Merge de tabelas
df_regionais_padronizada_limpa <- merge(x=df_regionais_padronizada, y=df_ibge_filtrada_padronizada, by=c("municipio_padronizado", "estado_padronizado"))
df_regionais_padronizada_limpa <- df_regionais_padronizada_limpa %>% select(UF, regional, municipio, co_municipio, no_municipio)
df_regionais_padronizada <- merge(x=df_regionais_padronizada, y=df_ibge_filtrada_padronizada, by=c("municipio_padronizado", "estado_padronizado"), all.x=T)

# Municípios não encontrados na base de dados do IBGE
df_regionais_nidentificado <- df_regionais_padronizada %>% filter(is.na(no_municipio)) %>% select(UF, regional, municipio)
nrow(df_regionais_nidentificado)

# Remoção de arquivos
rm(df_regionais_tratada, df_regionais_nidentificado, regionais_bruta, regional_dupla, df_ibge, df_ibge_filtrada, df_regionais_padronizada)
# Limpeza do ambiente
gc()

# Armazena a base de regionais tratada na pasta "prata"
data.table::fwrite(x=df_regionais_padronizada_limpa, file=here("data", "prata", "df_regionais_limpa.csv"))

#-------------------------------------------------------------------------------------
#- 2-) Estudantes na chamada regular em cursos de licenciatura com 550 e 650 no Enem -
#-------------------------------------------------------------------------------------

# Importa dados de cursos do Censo Superior
cols <- c('NO_CURSO', 'CO_CURSO', 'CO_CINE_AREA_GERAL', 'NO_CINE_AREA_GERAL', 'CO_CINE_ROTULO', 'NO_CINE_ROTULO', 'CO_CINE_AREA_ESPECIFICA', 'NO_CINE_AREA_ESPECIFICA', 'CO_CINE_AREA_DETALHADA', 'NO_CINE_AREA_DETALHADA', 'TP_GRAU_ACADEMICO', 'TP_NIVEL_ACADEMICO')
df_microdados_cursos <- read_parquet(here("data", "bronze", "MICRODADOS_CADASTRO_CURSOS_2023.parquet"), col_select = cols)
rm(cols)

# Pedagogia OK
# Biologia OK
# Educação física OK
# Matemática OK
# Química OK
# Física OK
# Língua Portuguesa OK
# Artes OK
# História OK
# Geografia OK
# Ciências
# Inglês OK
# Filosofia OK
# Sociologia OK

# Filtro de cursos de licenciatura
df_microdados_cursos_licenciatura <- df_microdados_cursos %>% 
  filter(TP_GRAU_ACADEMICO==2) %>% 
  mutate(
    NOME_CURSO_AJ = NO_CURSO |>
      stri_trans_general("Latin-ASCII") |>
      gsub("[[:punct:] ]", "", x = _) |>
      tolower(),
    NOME_CURSO_AJ_2 = case_when(
      grepl("pedagogia", NOME_CURSO_AJ) ~ "pedagogia",
      grepl("linguaportuguesa", NOME_CURSO_AJ) | grepl("letras", NOME_CURSO_AJ) ~ "linguaportuguesa",
      grepl("artes", NOME_CURSO_AJ) ~ "artes",
      grepl("biologi", NOME_CURSO_AJ) ~ "biologia",
      grepl("sociais", NOME_CURSO_AJ) | grepl("sociologia", NOME_CURSO_AJ) ~ "sociologia",
      .default = NOME_CURSO_AJ
    )
  )

# Importa dados do SiSU
cols <- c('SIGLA_IES', 'UF_CAMPUS', 'MUNICIPIO_CAMPUS', 'CODIGO_CURSO', 'NOME_CURSO', 'CPF', 'INSCRICAO_ENEM', 'NOTA_CANDIDATO')
df_chamada_regular_sisu_20231 <- read_parquet(here("data", "bronze", "chamada_regular_sisu_20231.parquet"), col_select = cols)
rm(cols)
# Cria variáveis para notas acima de 550 e 650
df_chamada_regular_sisu_20231 <- df_chamada_regular_sisu_20231 %>%
  mutate(
    SIGLA_IES, 
    UF_CAMPUS,
    UF_CAMPUS_AJ = padronizar_estados(UF_CAMPUS),
    MUNICIPIO_CAMPUS, 
    MUNICIPIO_CAMPUS_AJ = padronizar_municipios(MUNICIPIO_CAMPUS),
    NOME_CURSO, 
    NOME_CURSO_AJ = NOME_CURSO |>
      stri_trans_general("Latin-ASCII") |>
      gsub("[[:punct:] ]", "", x = _) |>
      tolower(),
    NOME_CURSO_AJ_2 = case_when(
      grepl("pedagogia", NOME_CURSO_AJ) ~ "pedagogia",
      grepl("linguaportuguesa", NOME_CURSO_AJ) | grepl("letras", NOME_CURSO_AJ) ~ "linguaportuguesa",
      grepl("artes", NOME_CURSO_AJ) ~ "artes",
      grepl("biologi", NOME_CURSO_AJ) ~ "biologia",
      grepl("sociais", NOME_CURSO_AJ) | grepl("sociologia", NOME_CURSO_AJ) ~ "sociologia",
      .default = NOME_CURSO_AJ
    ),
    NOME_CURSO_AJ_2 = gsub("^abi", "", NOME_CURSO_AJ_2),
    TOP_550 = ifelse(NOTA_CANDIDATO >= 550, "acima_550", "abaixo_550"), 
    TOP_650 = ifelse(NOTA_CANDIDATO >= 650, "acima_650", "abaixo_650")
  ) %>% 
  group_by(
    UF_CAMPUS,
    UF_CAMPUS_AJ,
    MUNICIPIO_CAMPUS_AJ,
    NOME_CURSO_AJ_2,
    TOP_550,
    TOP_650
  ) %>% 
  tally() %>% 
  filter(
    (NOME_CURSO_AJ_2 %in% unique(df_microdados_cursos_licenciatura$NOME_CURSO_AJ_2)) & (NOME_CURSO_AJ_2 %in% c("pedagogia", "biologia", "educacaofisica", "matematica", "quimica", "fisica", "linguaportuguesa", "artes", "historia", "geografia", "ciencias", "filosofia", "sociologia"))
  ) %>% 
  pivot_wider(
    names_from = c(TOP_550, TOP_650),
    values_from = n
  )

# Inclusão do código do município na base do SiSU
df_chamada_regular_sisu_20231 <- df_chamada_regular_sisu_20231 %>%
  rename(
    "estado_padronizado" = "UF_CAMPUS_AJ",
    "municipio_padronizado" = "MUNICIPIO_CAMPUS_AJ"
  ) %>% 
  left_join(y=df_ibge_filtrada_padronizada, by=c("estado_padronizado", "municipio_padronizado")) %>% 
  select(UF_CAMPUS, co_uf, no_uf, co_municipio, no_municipio, NOME_CURSO_AJ_2, abaixo_550_abaixo_650, acima_550_abaixo_650, acima_550_acima_650)

# Exporta arquivo de chamada de cursos de licenciatura no SiSU
data.table::fwrite(x = df_chamada_regular_sisu_20231, file = here("data", "prata", "df_sisu_licenciatura.csv"))

# Remove arquivos não utilizados
rm(df_chamada_regular_sisu_20231, df_microdados_cursos, df_microdados_cursos_licenciatura, df_ibge_filtrada_padronizada, df_regionais_padronizada_limpa)
gc()

#-----------------------------------------------------------------------------------
#- 3-) Tratamento de dados de oferta e demanda para identificar "bolsas elegíveis" -
#-----------------------------------------------------------------------------------

# Importa base de oferta e demanda
df_oferta_demanda <- readxl::read_xlsx(here("data", "bronze", "oferta_e_demanda.xlsx"))
# Seleciona e renomeia as colunas
df_oferta_demanda <- df_oferta_demanda %>% 
  mutate(
    no_curso_aj = curso |>
      stri_trans_general("Latin-ASCII") |>
      gsub("[[:punct:] ]", "", x = _) |>
      tolower(),
    demanda = `demanda educação infantil` + `demanda anos iniciais` + `demanda anos finais` + `demanda ensino médio`
  ) %>% 
  rename("sg_uf" = "UF") %>% 
  select(sg_uf, regional, curso, no_curso_aj, vagas, concluintes, demanda)
  

# Cenários de "bolsas "elegíveis"
df_oferta_demanda <- df_oferta_demanda %>% 
  mutate(
    cenario = case_when(
      (demanda < vagas) & (vagas > concluintes) & (demanda > concluintes) ~ "Cenário 1",
      vagas == 0 & concluintes == 0 ~ "Cenário 2",
      (demanda > vagas) & (vagas > concluintes) ~ "Cenário 3",
      (vagas > concluintes) & (demanda > concluintes) ~ "Cenário 4",
      (concluintes >= vagas) & (concluintes >= demanda) ~ "Cenário 5",
      demanda <= concluintes ~ "Cenário 6",
      (vagas <= concluintes) & (vagas <= demanda) ~ "Cenário 7"
    ),
    qtd_bolsas_elegiveis = case_when(
      cenario == "Cenário 1" ~ demanda - concluintes,
      cenario %in% c("Cenário 3", "Cenário 4") ~ vagas - concluintes,
      .default = 0
    )
  ) %>% 
  select(-cenario)

# Armazena base de oferta e demanda tratada
data.table::fwrite(df_oferta_demanda, file=here("data", "prata", "df_oferta_demanda.csv"))
# Remove arquivos
rm(df_oferta_demanda)
gc()


