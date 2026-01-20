# Projeto: Análise do Mercado Imobiliário com Arquitetura de Medalhão

Este repositório apresenta um projeto completo de **engenharia e análise de dados** aplicado ao mercado imobiliário, utilizando uma base pública do Kaggle. O projeto envolve ingestão, transformação, análise exploratória e preparação dos dados para modelagem analítica e consumo em BI, seguindo uma **arquitetura de dados em medalhão (Bronze → Silver → Gold)**.

**Base de dados utilizada:**  
https://www.kaggle.com/datasets/shengkunwang/housets-dataset

---
## Objetivos do Projeto

- Construir um pipeline de dados estruturado seguindo boas práticas de engenharia de dados  
- Implementar a arquitetura de medalhão em um projeto de pequeno/médio porte  
- Realizar análises exploratórias para entender o comportamento do mercado imobiliário  
- Avaliar a influência de fatores socioeconômicos e de mercado nos preços dos imóveis  
- Preparar os dados para regressão, análises estatísticas e visualização em BI  

---

## Arquitetura de Dados (Medalhão)

O projeto segue uma **arquitetura de medalhão modificada**, adequada para projetos analíticos menores, composta por três camadas:

### Bronze (Raw)
- Dados brutos carregados diretamente do arquivo CSV
- Nenhuma modificação ou limpeza aplicada


### Silver
- Dados limpos, padronizados e tipados
- Padronização de nomes de colunas (snake_case)
- Remoção de acentos e caracteres especiais
- Criação de variáveis derivadas (ex: `month`, `season`)
- Arredondamento de valores numéricos
- Preparação para análises exploratórias

### Gold (planejada)
- Modelagem dimensional
- Criação de tabela fato e dimensões
- Estrutura otimizada para consumo analítico e Power BI
- Conceito de *One Big Table* para análises finais

---

## Tecnologias Utilizadas

- **Linguagem:** Python  
- **Banco de Dados:** PostgreSQL  
- **Containerização:** Docker / Docker Compose  
- **Bibliotecas:**  
  - Pandas  
  - NumPy  
  - SQLAlchemy  
  - Matplotlib  
  - Seaborn  
- **Ambiente de Análise:** Jupyter Notebook  
- **BI (futuro):** Power BI  

---

## ⚙️ Pipeline ETL (Raw to Silver)

O processo de ETL foi implementado via script Python e executa as seguintes etapas:

1. Conexão com banco PostgreSQL
2. Criação automática do schema `silver`
3. Leitura dos dados brutos (`dados_brutos.csv`)
4. Padronização dos nomes das colunas
5. Conversão de tipos (datas e numéricos)
6. Limpeza de textos (remoção de acentos e caracteres especiais)
7. Remoção de registros inválidos
8. Criação de colunas derivadas
9. Gravação da tabela `silver.silver_houses`

Esse processo garante dados consistentes, reutilizáveis e prontos para análise.

---

## 🔍 Análises Exploratórias de Dados (EDA)

As análises exploratórias foram realizadas diretamente a partir da camada **raw**, utilizando visualizações estatísticas e gráficas. Posteriormente as mesmas análises foram feitas no analytics da camada siver.

### 📊 Análises realizadas

- Distribuição dos preços dos imóveis
- Distribuição da renda per capita
- Relação entre renda per capita e preço dos imóveis (nível cidade)
- Análise de liquidez do mercado (tempo de venda × preço)
- Análise por faixas (segmentação de mercado)
- Análises temporais e sazonais

---
