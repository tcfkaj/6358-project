clean_data <- read.csv('clean_data.csv', row.names = 1)

# ===============
r2goal <- 0.50 # R squared value we want
# ===============

index_clean <- cbind(1:nrow(clean_data), clean_data, rep(0, nrow(clean_data)))
colnames(index_clean)[1] <- 'Index'
colnames(index_clean)[11] <- 'R-Sq'
dropvar <- 1000
model1 <- lm(Delta.price ~ ., data = index_clean[-1])
looplist <- 1:nrow(clean_data)
while (max(index_clean$`R-Sq`) < r2goal){
  for (i in looplist[-dropvar]){
    dropping <- c(-i, -dropvar)
    model1 <- lm(Delta.price ~ ., data = index_clean[, -1], subset = dropping)
    index_clean[i, 'R-Sq'] <- summary(model1)['r.squared'][[1]]
  }
  model2 <- lm(Delta.price ~ ., data = index_clean[, -1], subset = -dropvar)
  dropvar <- c(dropvar, as.numeric(names(outlierTest(model2)[[1]])))
  # Or dropping outliers that gives max R squared, but worse than the above method.
  #dropvar <- c(dropvar, index_clean$Index[which(index_clean$`R-Sq`==max(index_clean$`R-Sq`[-dropvar]))])
  print(max(index_clean$`R-Sq`))
  print(dropvar)
}









