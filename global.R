# 📦 Lista de pacotes necessários
pacotes <- c("shiny", "dplyr", "lubridate", "ggplot2", "DT", "tidyr", "ipeadatar", "insight")

# 🔧 Função para verificar e instalar pacotes ausentes
instalar_pacotes <- function(p) {
  novos <- p[!(p %in% installed.packages()[, "Package"])]
  if(length(novos)) install.packages(novos)
}

# 📥 Instalar os pacotes que faltam
instalar_pacotes(pacotes)

# 📚 Carregar todos os pacotes
lapply(pacotes, library, character.only = TRUE)

# 🔍 Consulta ao IPCA projetado para os próximos 6 meses
ipca <- tryCatch(ipeadata("BM12_IPCAEXP612"), error = function(e) NULL)

# ✅ Validação e fallback
ipca_atual <- if (!is.null(ipca) && "valor" %in% names(ipca)) {
  tail(ipca$valor, 1) / 100  # Convertendo para decimal
} else {
  NA
}

# 💡 Função para leitura inteligente de arquivos CSV
ler_ativos <- function(path) {
  df <- tryCatch(read.csv(path, stringsAsFactors = FALSE), error = function(e) NULL)
  if (is.null(df)) {
    df <- tryCatch(read.csv2(path, stringsAsFactors = FALSE), error = function(e) NULL)
  }
  
  # 🔎 Validação básica de colunas esperadas
  campos_esperados <- c("nome", "codigo", "tipo", "valor_investimento", "taxa_ipca_aa", 
                        "vencimento", "isento_ir", "semestre_01", "semestre_02", "total_cupons")
  
  # Normaliza nomes para minúsculas
  nomes_df <- tolower(names(df))
  if (!is.null(df) && !all(campos_esperados %in% nomes_df)) {
    stop("⚠️ Arquivo CSV inválido. Verifique os nomes das colunas.")
  }
  
  # 🔄 Conversões de tipos
  df$taxa_ipca_aa <- as.numeric(gsub(",", ".", df$taxa_ipca_aa))
  df$vencimento <- as.Date(df$vencimento)
  df$valor_investimento <- as.numeric(df$valor_investimento)
  df$total_cupons <- as.integer(df$total_cupons)
  
  return(df)
}
