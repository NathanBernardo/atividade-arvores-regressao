
# LISTA DE EXERCÍCIOS — ÁRVORES E REGRESSÃO LOGÍSTICA


install.packages("rpart")
install.packages("rpart.plot")
install.packages("caret")
install.packages("ggplot2")
install.packages("mlbench")
install.packages("palmerpenguins")
install.packages("nnet")

library(rpart)
library(rpart.plot)
library(caret)
library(ggplot2)
library(mlbench)
library(palmerpenguins)
library(nnet)

# EXERCÍCIO 1 — ÁRVORE DE REGRESSÃO
# Base: diamonds
# Variável resposta: price (preço do diamante)

data(diamonds)

# Traduz os nomes das colunas para português
diamantes <- diamonds
names(diamantes) <- c("quilate", "corte", "cor", "clareza",
                      "profundidade", "tabela", "preco",
                      "comprimento", "largura", "altura")

diamantes
str(diamantes)

# Divisão treino (70%) e teste (30%)
set.seed(42)
indice1   <- createDataPartition(diamantes$preco, p = 0.7, list = FALSE)
treino1   <- diamantes[ indice1, ]
teste1    <- diamantes[-indice1, ]

# Ajuste da árvore de regressão
arvore1 <- rpart(formula = preco ~ .,
                 data    = treino1,
                 method  = "anova",
                 control = rpart.control(cp        = 0.001,
                                         minsplit  = 20,
                                         minbucket = 10,
                                         maxdepth  = 6,
                                         xval      = 10))

arvore1

# Gráfico da árvore
rpart.plot(arvore1,
           type          = 2,
           extra         = 101,
           fallen.leaves = TRUE,
           main          = "Árvore de Regressão — Preço de Diamantes")

# Importância das variáveis
arvore1$variable.importance

# Predição no conjunto teste
predicao1 <- predict(arvore1, newdata = teste1)

predicao1

# Avaliação do modelo
rmse1 <- sqrt(mean((teste1$preco - predicao1)^2))
mae1  <- mean(abs(teste1$preco - predicao1))
r2_1  <- cor(teste1$preco, predicao1)^2

cat("RMSE:", round(rmse1, 2), "\n")
cat("MAE :", round(mae1,  2), "\n")
cat("R²  :", round(r2_1,  4), "\n")

# Adiciona predição ao conjunto teste
teste1$predicao <- predicao1
head(teste1[, c("preco", "predicao")])

# EXERCÍCIO 2 — ÁRVORE DE CLASSIFICAÇÃO
# Base: Sonar
# Variável resposta: Class (R = Rocha, M = Mina)

data(Sonar)

# As colunas V1 a V60 são sinais de sonar — mantemos como estão
# Apenas renomeamos a variável resposta
sonar <- Sonar
names(sonar)[61] <- "classe"

sonar
str(sonar)

# Distribuição da variável resposta
table(sonar$classe)

# Divisão treino (70%) e teste (30%)
set.seed(42)
indice2   <- createDataPartition(sonar$classe, p = 0.7, list = FALSE)
treino2   <- sonar[ indice2, ]
teste2    <- sonar[-indice2, ]

# Ajuste da árvore de classificação
arvore2 <- rpart(formula = classe ~ .,
                 data    = treino2,
                 method  = "class",
                 parms   = list(split = "gini"),
                 control = rpart.control(cp        = 0.01,
                                         minsplit  = 10,
                                         minbucket = 5,
                                         maxdepth  = 5,
                                         xval      = 10))

arvore2

# Gráfico da árvore
rpart.plot(arvore2,
           type          = 3,
           extra         = 104,
           under         = TRUE,
           faclen        = 0,
           fallen.leaves = TRUE,
           main          = "Árvore de Classificação — Sonar (Rocha vs Mina)")

# Importância das variáveis
arvore2$variable.importance

# Predição no conjunto teste
predicao2_classe <- predict(arvore2, newdata = teste2, type = "class")
predicao2_prob   <- predict(arvore2, newdata = teste2, type = "prob")

predicao2_classe
predicao2_prob

# Matriz de confusão
confusionMatrix(predicao2_classe, teste2$classe, positive = "M")

# Adiciona predição ao conjunto teste
teste2$predicao <- predicao2_classe
head(teste2[, c("classe", "predicao")])


# EXERCÍCIO 3 — REGRESSÃO LOGÍSTICA MULTICLASSE
# Base: penguins
# Variável resposta: species (espécie do pinguim)

data(penguins)

# Traduz os nomes das colunas para português e remove NAs
pinguins <- na.omit(penguins[, c("species",
                                  "bill_length_mm",
                                  "bill_depth_mm",
                                  "flipper_length_mm",
                                  "body_mass_g")])

names(pinguins) <- c("especie",
                     "comprimento_bico",
                     "profundidade_bico",
                     "comprimento_nadadeira",
                     "massa_corporal")

pinguins
str(pinguins)

# Distribuição da variável resposta
table(pinguins$especie)

# Divisão treino (70%) e teste (30%)
set.seed(42)
indice3   <- createDataPartition(pinguins$especie, p = 0.7, list = FALSE)
treino3   <- pinguins[ indice3, ]
teste3    <- pinguins[-indice3, ]

# Ajuste do modelo de regressão logística multinomial
modelo3 <- multinom(formula = especie ~ comprimento_bico + profundidade_bico +
                                        comprimento_nadadeira + massa_corporal,
                    data    = treino3,
                    maxit   = 300,
                    trace   = FALSE)

modelo3

# Resumo do modelo
summary(modelo3)

# Predição no conjunto teste
predicao3_classe <- predict(modelo3, newdata = teste3)
predicao3_prob   <- predict(modelo3, newdata = teste3, type = "probs")

predicao3_classe
predicao3_prob

# Matriz de confusão
confusionMatrix(factor(predicao3_classe), teste3$especie)

# Novos pinguins para predição
novos_pinguins <- data.frame(
  comprimento_bico      = c(39.5, 48.7, 55.9),
  profundidade_bico     = c(17.4, 15.1, 17.8),
  comprimento_nadadeira = c(186,  203,  228),
  massa_corporal        = c(3750, 4450, 5650)
)

novos_pinguins

# Predição dos novos pinguins
predicao_novos <- predict(modelo3, newdata = novos_pinguins)
predicao_novos

# Probabilidades para cada espécie
predicao_novos_prob <- predict(modelo3, newdata = novos_pinguins, type = "probs")
predicao_novos_prob

# Adiciona a predição ao data.frame
novos_pinguins$especie <- predicao_novos
novos_pinguins

