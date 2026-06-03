# Atividade P2 — Árvores de Decisão e Regressão Logística

**Disciplina:** Técnicas Avançadas em Estatística  
**Instituição:** Faculdade de Tecnologia Jundiaí – Deputado Ary Fossen  
**Aluno:** Nathan Bernardo Novais de Melo  

---

## 📋 Descrição

Este repositório contém a resolução da lista de exercícios avaliativa da disciplina, com a implementação de três modelos preditivos em R:

- **Exercício 1:** Árvore de Regressão — previsão do preço de diamantes
- **Exercício 2:** Árvore de Classificação — identificação de rochas e minas por sinais de sonar
- **Exercício 3:** Regressão Logística Multiclasse — classificação de espécies de pinguins

---

## 📁 Arquivo

| Arquivo | Descrição |
|---------|-----------|
| `ATIVIDADE_P2_TAE.R` | Script R com os três exercícios completos |

---

## 📦 Pacotes necessários

Os pacotes são instalados automaticamente ao rodar o script. São eles:

```r
rpart
rpart.plot
caret
ggplot2
mlbench
palmerpenguins
nnet
```

---

## ▶️ Como executar

1. Abra o arquivo `ATIVIDADE_P2_TAE.R` no **RStudio**
2. Execute o script completo (`Ctrl + Shift + Enter`) ou rode linha a linha (`Ctrl + Enter`)
3. Na primeira execução os pacotes serão instalados automaticamente

---

## 📊 Bases de dados utilizadas

| Exercício | Base | Origem | Variável Resposta |
|-----------|------|--------|-------------------|
| 1 | `diamonds` | pacote `ggplot2` | `preco` (numérica) |
| 2 | `Sonar` | pacote `mlbench` | `classe` (R = Rocha / M = Mina) |
| 3 | `penguins` | pacote `palmerpenguins` | `especie` (3 classes) |

---

## 🔍 Resumo dos modelos

### Exercício 1 — Árvore de Regressão (diamonds)
- Método: `rpart` com `method = "anova"`
- Divisão: 70% treino / 30% teste
- Métricas: RMSE, MAE e R²

### Exercício 2 — Árvore de Classificação (Sonar)
- Método: `rpart` com `method = "class"` e critério Gini
- Divisão: 70% treino / 30% teste
- Métricas: Matriz de confusão, Acurácia, Sensibilidade, Especificidade, F1

### Exercício 3 — Regressão Logística Multiclasse (penguins)
- Método: `nnet::multinom`
- Variáveis preditoras: comprimento e profundidade do bico, comprimento da nadadeira, massa corporal
- Divisão: 70% treino / 30% teste
- Métricas: Matriz de confusão e Acurácia
