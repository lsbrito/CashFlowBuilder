library(shiny)

shinyUI(fluidPage(
  
  # 🧭 Título principal do aplicativo
  titlePanel("CashFlowBuilder — Engenharia de Fluxo de Caixa Recorrente via Renda Fixa"),
  
  sidebarLayout(
    sidebarPanel(
      
      # 📁 Seção de importação do arquivo CSV
      h4("📁 Importar base de ativos"),
      fileInput("arquivo_csv", "Escolha seu arquivo CSV", accept = ".csv"),
      
      # 🔧 Seção de parâmetros de simulação
      h4("🔧 Parâmetros de simulação"),
      
      # 📊 Campo para IPCA projetado (com legenda explicativa)
      numericInput("ipca_proj", "IPCA projetado (% a.a.):", value = 4.5, min = 0),
      helpText("Valor obtido automaticamente via IPEADATA (série BM12_IPCAEXP612). Você pode editar para simular cenários futuros."),
      
      # ▶️ Botão para iniciar o cálculo do fluxo de caixa
      actionButton("calcular", "Calcular fluxo de caixa", class = "btn-primary")
    ),
    
    mainPanel(
      
      # 🗂️ Abas de visualização dos resultados
      tabsetPanel(
        tabPanel("📋 Resumo dos Ativos", tableOutput("resumo")),
        tabPanel("📈 Fluxo de Caixa", dataTableOutput("fluxo")),
        tabPanel("📊 Gráfico", plotOutput("grafico")),
        tabPanel("🧠 Melhores Ativos", dataTableOutput("ativos_recomendados"))
      )
    )
  )
))
