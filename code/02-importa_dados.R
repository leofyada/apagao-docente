#------------------------------------------------------------------------
#- 1-) Script para importar os microdados do Censo da Educação Superior - 
#------------------------------------------------------------------------

# Caminho para os microdados do Censo da Educação Superior de 2023
caminho_microdados_superior_23 <- "https://download.inep.gov.br/microdados/microdados_censo_da_educacao_superior_2023.zip"

# Download do arquivo ZIP com os microdados do Censo da Educação Superior de 2023
download.file(caminho_microdados_superior_23, here("data", "bronze", "micro_censo_sup_2023.zip"))
# Unzip arquivos
archive::archive_extract(archive = here("data", "bronze", "micro_censo_sup_2023.zip"), dir = here("data", "bronze"))
# Remove arquivo ZIP
unlink(here("data", "bronze", "micro_censo_sup_2023.zip"))

# Importa arquivo de cursos e converte para .parquet
microdados_censosuperior_cursos_23 <- data.table::fread(here("data", "bronze", "microdados_censo_da_educacao_superior_2023", "dados", "MICRODADOS_CADASTRO_CURSOS_2023.CSV"), encoding="Latin-1")
arrow::write_parquet(microdados_censosuperior_cursos_23, here("data", "bronze", "MICRODADOS_CADASTRO_CURSOS_2023.parquet"))
# Remove arquivo .CSV e limpa o ambiente
rm(microdados_censosuperior_cursos_23)
gc()

# Importa o arquivo de ies e converte para .parquet
microdados_censosuperior_ies_23 <- data.table::fread(here("data", "bronze", "microdados_censo_da_educacao_superior_2023", "dados", "MICRODADOS_ED_SUP_IES_2023.CSV"), encoding="Latin-1")
arrow::write_parquet(microdados_censosuperior_ies_23, here("data", "bronze", "MICRODADOS_ED_SUP_IES_2023.parquet"))
# Remove arquivo .CSV e limpa o ambiente
rm(microdados_censosuperior_ies_23)
gc()

# Remove pasta dos microdados do Censo da Educação Superior de 2023
unlink(here("data", "bronze", "microdados_censo_da_educacao_superior_2023"), recursive = TRUE, force = TRUE)
# Remove o caminho
rm(caminho_microdados_superior_23)

#------------------------------------------------------------------------
#- 2-) Script para importar os dados da Chamada Regular do SiSU de 2023 -
#------------------------------------------------------------------------

# Caminho para o arquivo da chamada regular do SiSU
chamada_regular_sisu_20231 <- "https://dadosabertos.mec.gov.br/images/conteudo/sisu/2023/chamada_regular_sisu_2023_1.csv"

# Download do arquivo da chamada regular do SiSU
download.file(chamada_regular_sisu_20231, here("data", "bronze", "chamada_regular_sisu_20231.csv"))
# Importa o arquivo da chamada regular do SiSU e converte para .parquet
chamada_regular_sisu_20231 <- data.table::fread(here("data", "bronze", "chamada_regular_sisu_20231.csv"), encoding="Latin-1")
arrow::write_parquet(chamada_regular_sisu_20231, here("data", "bronze", "chamada_regular_sisu_20231.parquet"))
# Remove arquivo .CSV e limpa o ambiente
rm(chamada_regular_sisu_20231)
gc()

# Remove arquivo .CSV
unlink(here("data", "bronze", "chamada_regular_sisu_20231.csv"))

#-----------------------------------------------------------------------------------------
#- 3-) Script para importar os dados dos códigos IBGE dos municípios brasileiros de 2024 -
#-----------------------------------------------------------------------------------------

# Caminho para o arquivo ZIP dos dados dos municípios brasileiros
caminho_ibge_municipios <- "https://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/divisao_territorial/2024/DTB_2024.zip"

# Download do arquivo ZIP com os dados dos municípios brasileiros
download.file(caminho_ibge_municipios, here("data", "bronze", "DTB_2024.zip"))
# Unzip arquivos
archive::archive_extract(archive = here("data", "bronze", "DTB_2024.zip"), dir = here("data", "bronze"))
# Remove arquivo ZIP
unlink(here("data", "bronze", "DTB_2024.zip"))

# Remove arquivos não utilizados
unlink(here("data", "bronze", "Distritos_novos_e_extintos.ods"))
unlink(here("data", "bronze", "Distritos_novos_e_extintos.xls"))
unlink(here("data", "bronze", "RELATORIO_DTB_BRASIL_2024_DISTRITOS.ods"))
unlink(here("data", "bronze", "RELATORIO_DTB_BRASIL_2024_DISTRITOS.xls"))
unlink(here("data", "bronze", "RELATORIO_DTB_BRASIL_2024_SUBDISTRITOS.ods"))
unlink(here("data", "bronze", "RELATORIO_DTB_BRASIL_2024_SUBDISTRITOS.xls"))
unlink(here("data", "bronze", "RELATORIO_DTB_BRASIL_2024_MUNICIPIOS.ods"))

# Remove o caminho
rm(caminho_ibge_municipios)

