library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)

shinyServer(function(input, output) {
  
  ativos <- reactive({
    req(input$arquivo_csv)
    read.csv(input$arquivo_csv$datapath, sep = ";", stringsAsFactors = FALSE)
  })
  
  fluxo_caixa <- eventReactive(input$calcular, {
    # Aqui entra a lógica de cálculo dos cupons e reinvestimento
    # Vamos montar juntos depois!
    data.frame(
      Mês = c("Jan", "Mar", "Abr", "Jul", "Set", "Out"),
      Valor = c(605, 287, 855, 605, 287, 855)
    )
  })
  
  output$resumo <- renderTable({
    ativos()
  })
  
  output$fluxo <- renderDataTable({
    fluxo_caixa()
  })
  
  output$grafico <- renderPlot({
    df <- fluxo_caixa()
    ggplot(df, aes(x = Mês, y = Valor)) +
      geom_col(fill = "steelblue") +
      theme_minimal() +
      labs(title = "Fluxo de Cupons Semestrais", y = "Valor (R$)", x = "Mês")
  })
})
