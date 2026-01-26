# 🏠 Projeto: Análise do Mercado Imobiliário com Arquitetura de Medalhão

Este repositório apresenta um projeto completo de **engenharia e análise de dados** aplicado ao mercado imobiliário, utilizando uma base pública do Kaggle.  
O projeto cobre desde a ingestão de dados brutos até a **modelagem dimensional (Data Warehouse)** e a criação de **consultas analíticas avançadas**, seguindo uma **arquitetura de dados em medalhão (Raw → Silver → Gold)**.

🔗 **Base de dados utilizada:**  
https://www.kaggle.com/datasets/shengkunwang/housets-dataset

---

## 🎯 Objetivos do Projeto

- Implementar um pipeline de dados estruturado seguindo boas práticas de engenharia de dados  
- Aplicar a arquitetura de medalhão em um contexto analítico real  
- Realizar análises exploratórias e analíticas do mercado imobiliário  
- Avaliar impactos de fatores socioeconômicos, infraestrutura e tempo nos preços dos imóveis  
- Construir um **Data Warehouse** com modelo estrela  
- Preparar dados e consultas para visualização em ferramentas de BI (Power BI)  

---

## 📁 Estrutura de Pastas do Projeto
```
.
├── data_layer
│ ├── raw
│ │ ├── analytics
│ │ ├── dados_brutos.csv
│ │ └── dicionario_de_dados
│ │
│ ├── silver
│ │ ├── analytics
│ │ ├── mer_der_dld
│ │ └── ddl
│ │
│ └── gold
│ ├── consultas.sql
│ ├── ddl
│ ├── mnemonico
│ └── mer_der_dld
│
├── transformer
│ ├── raw_to_silver.py
│ └── silver_to_gold.py
│
├── docker-compose.yml
├── requirements.txt
└── README.md
```


---

## 🏅 Arquitetura de Dados (Medalhão)

O projeto segue uma **arquitetura de medalhão adaptada**, adequada para projetos analíticos de pequeno e médio porte.

### 🔹 Raw (Bronze)
- Dados brutos carregados diretamente do arquivo CSV  
- Nenhuma transformação aplicada  
- Preserva o dado original para auditoria e rastreabilidade  
- Contém análises exploratórias iniciais (EDA)  

---

### 🔸 Silver
- Dados limpos, padronizados e tipados  
- Padronização de nomes de colunas  
- Conversão de tipos de dados  
- Limpeza de textos e valores inválidos  
- Criação de variáveis derivadas (`month`, `season`)  
- Preparação para análises exploratórias consolidadas  
- Armazenamento em PostgreSQL no schema `silver`  

---

### ⭐ Gold
- Modelagem dimensional (Data Warehouse)  
- Separação em **tabelas dimensão** e **tabela fato**  
- Uso de **chaves substitutas (SRK)**  
- Padronização por **mnemônicos**  
- Consultas analíticas avançadas  
- Estrutura otimizada para BI e análises estratégicas  

---

## 🔄 Pipeline ETL

### Raw → Silver

Script responsável:

transformer/etl_raw_to_silver.ipynb


**Etapas executadas:**
1. Conexão com PostgreSQL  
2. Criação automática do schema `silver`  
3. Leitura dos dados brutos (`dados_brutos.csv`)  
4. Padronização dos nomes das colunas  
5. Conversão de tipos (datas e numéricos)  
6. Limpeza de dados textuais  
7. Criação de colunas derivadas  
8. Carga da tabela `silver.silver_houses`  

---

### Silver → Gold

Script responsável:

transformer/etl_silver_to_gold.ipynb


**Etapas executadas:**
1. Leitura dos dados da camada silver  
2. Aplicação dos mnemônicos definidos  
3. Criação das tabelas dimensão  
4. Geração das chaves substitutas (SRK)  
5. Construção da tabela fato  
6. Criação de PKs, FKs e índices  
7. Carga no schema `dw`  

---

## 📐 Modelagem Dimensional

O Data Warehouse segue o **modelo estrela**.

### Dimensões
- `dim_tempo`  
- `dim_local`  
- `dim_socio`  
- `dim_infra`  

Cada dimensão possui:
- Chave primária substituta (**SRK**)  
- Atributos descritivos padronizados  

### Tabela Fato
- `fat_houses`  
- Métricas do mercado imobiliário  
- Relacionamento com todas as dimensões  

Diagramas **MER, DER e DLD** estão disponíveis nas pastas das camadas **silver** e **gold**.

---

## 📊 Análises Exploratórias e Analíticas

### 🔍 Análises Exploratórias (EDA)
- Distribuição dos preços dos imóveis  
- Distribuição da renda per capita  
- Relação renda × preço dos imóveis  
- Análise de liquidez do mercado  
- Análises temporais e sazonais  

### 📈 Análises Analíticas (Gold)
- Ranking de cidades mais caras e mais baratas  
- Análise de custo-benefício de infraestrutura  
- Índices normalizados (0–100)  
- Pressão do mercado imobiliário  
- Análises socioeconômicas  
- Consultas avançadas utilizando CTE  

---

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** Python  
- **Banco de Dados:** PostgreSQL  
- **Containerização:** Docker / Docker Compose  
- **Bibliotecas:** Pandas, NumPy, SQLAlchemy, Matplotlib, Seaborn  
- **Ambiente de Análise:** Jupyter Notebook  
- **BI:** Power BI (planejado)  

---

## 🚀 Próximos Passos

- Integração do Data Warehouse com Power BI  
- Criação de dashboards analíticos