# 📘 CashFlowBuilder

**CashFlowBuilder** é uma calculadora interativa desenvolvida em **R + Shiny** para simular e projetar o fluxo de caixa recorrente gerado por investimentos em renda fixa com cupons semestrais. A ferramenta permite ao investidor montar uma estratégia de engenharia financeira baseada em ativos como CRAs, CRIs e debêntures incentivadas, com foco em previsibilidade, reinvestimento e geração de caixa ao longo dos anos.
"engenharia de fluxo de caixa recorrente via renda fixa"
---

## 🚀 Funcionalidades

- Entrada manual de ativos ou importação via arquivo `.csv`
- Cálculo de cupons semestrais com base em IPCA projetado + spread
- Simulação de reinvestimento dos cupons ao longo do tempo
- Seleção inteligente de ativos conforme critérios definidos pelo usuário
- Visualização do fluxo de caixa por mês e ano
- Gráficos interativos e tabelas dinâmicas

---

## 🛠️ Tecnologias utilizadas

- [R](https://www.r-project.org/)
- [Shiny](https://shiny.posit.co/)
- Pacotes: `dplyr`, `lubridate`, `ggplot2`, `DT`, `tidyr`

---

## 📥 Como instalar e rodar

1. Clone o repositório:
   ```bash
   git clone https://github.com/lsbrito/CashFlowBuilder.git

---

## Execute o app:
shiny::runApp()

---

## 📁 Estrutura do projeto

```text
CashFlowBuilder/
├── ui.R               # Interface do usuário
├── server.R           # Lógica de cálculo e renderização
├── CashFlowBuilder.Rproj
├── .gitignore
├── dados.csv       # Arquivo modelo para testes (inclui ativos fictícios)
└── data/
    └── ativos.csv     # Exemplo de base de ativos (opcional)


---

