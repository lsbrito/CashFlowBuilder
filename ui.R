library(shiny)

shinyUI(fluidPage(
  titlePanel("Calculadora de Fluxo de Caixa Recorrente - Renda Fixa"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("valor_total", "Valor total a investir (R$):", value = 10000),
      numericInput("ipca_proj", "IPCA projetado (% a.a.):", value = 4.5),
      numericInput("taxa_min", "Taxa mínima desejada (% acima do IPCA):", value = 5),
      fileInput("arquivo_csv", "Importar base de ativos (.csv)", accept = ".csv"),
      actionButton("calcular", "Calcular fluxo de caixa")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Resumo", tableOutput("resumo")),
        tabPanel("Fluxo de Caixa", dataTableOutput("fluxo")),
        tabPanel("Gráfico", plotOutput("grafico"))
      )
    )
  )
))
