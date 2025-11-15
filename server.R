library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)
library(DT)
library(tidyr)   # <- necessário para unnest()

shinyServer(function(input, output) {
  
  # 📥 Leitura da base de ativos importada via CSV
  ativos <- reactive({
    req(input$arquivo_csv)
    ler_ativos(input$arquivo_csv$datapath)
  })
  
  # 📊 Cálculo do fluxo de caixa com base nos ativos e IPCA atual
  fluxo_caixa <- eventReactive(input$calcular, {
    df <- ativos()
    req(df)
    
    # 🔢 IPCA mais recente (definido no global.R ou informado manualmente)
    ipca <- ifelse(is.na(ipca_atual), input$ipca_proj / 100, ipca_atual)
    
    # 🔄 Geração do fluxo de cupons para cada ativo
    fluxo <- df %>%
      rowwise() %>%
      mutate(
        taxa_total = ipca + taxa_ipca_aa / 100,
        valor_cupom = valor_investimento * taxa_total / 2,
        datas = list(seq.Date(from = Sys.Date(), by = "6 months", length.out = total_cupons))
      ) %>%
      tidyr::unnest(cols = c(datas)) %>%
      select(nome, codigo, tipo, datas, valor_cupom)
    
    # 🏷️ Renomear colunas para exibição
    fluxo_final <- fluxo %>%
      rename(
        Ativo = nome,
        Código = codigo,
        Tipo = tipo,
        Data = datas,
        Cupom = valor_cupom
      )
    
    fluxo_final
  })
  
  # 📋 Tabela com os ativos importados
  output$resumo <- renderTable({
    ativos()
  })
  
  # 📈 Tabela com o fluxo de caixa consolidado
  output$fluxo <- renderDataTable({
    fluxo_caixa()
  })
  
  # 📉 Gráfico de barras com os cupons
  output$grafico <- renderPlot({
    df <- fluxo_caixa()
    ggplot(df, aes(x = Data, y = Cupom, fill = Ativo)) +
      geom_col(position = "stack") +
      theme_minimal() +
      labs(title = "Fluxo de Cupons Semestrais por Ativo", x = "Data", y = "Valor (R$)")
  })
  
  # 🧠 Seleção inteligente dos melhores ativos
  output$ativos_recomendados <- renderDataTable({
    df <- ativos()
    req(df)
    
    # 🔢 IPCA mais recente
    ipca <- ifelse(is.na(ipca_atual), input$ipca_proj / 100, ipca_atual)
    
    # 🧪 Filtro por critérios internos
    filtrados <- df %>%
      filter(
        taxa_ipca_aa > 0,
        isento_ir == "Sim"
      ) %>%
      arrange(desc(taxa_ipca_aa)) %>%
      slice_head(n = 4)
    
    # 📋 Exibir principais colunas
    filtrados %>%
      select(nome, codigo, tipo, taxa_ipca_aa, vencimento, semestre_01, semestre_02)
  })
})
