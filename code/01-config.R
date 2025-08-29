#---------------------------------------------
#- Importa bibliotecas utilizadas no projeto - 
#---------------------------------------------

# Função para importar pacotes 
importa_pacotes <- function(pacotes){
  for (pacote in pacotes) {
    if(!require(pacote, character.only = TRUE)) {
      message(paste("Pacote", pacote, "não encontrado."))
    } else {
      message(paste("Pacote", pacote, "carregado com sucesso."))
    }
  }
}

# Pacotes utilizados
pacotes <- c(
  "data.table", "archive", "here", "arrow", "dplyr", "readxl", "enderecobr", "stringi", "tidyr", "writexl", "glue", "ggplot2"
)

# Importa os pacotes
importa_pacotes(pacotes)


