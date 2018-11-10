setwd("C:/")

final_result <- read.csv('sp500_predictors_run500.csv', row.names = 2)
price <- read.csv('Change-in-price.csv', sep='\t')

full_data <- merge(price, final_result[ , -1], by = 'row.names', all.x=TRUE)
colnames(full_data)[1] <- 'Company'

# Scatter Plot and Correlation Matrix
#png('var_plot.png', width = 871, height = 677)
plot(full_data[-1], main = 'Scatter Plot for Variables')
#dev.off()

# Non of these are accurate with NAs
cor.matrix1 <- cor(full_data[-1], use='pairwise')
cor.matrix2 <- cor(full_data[-1], use='complete.obs') # R class

library(RColorBrewer)
heatmap(cor.matrix1, col=brewer.pal(9,"Greys"), cexRow = 0.7, cexCol = 0.7, Rowv = NA,
        symm = T, reorderfun = NULL, margins = c(8,8), main = 'cor.matrix1')
heatmap(cor.matrix2, col=brewer.pal(9,"Greys"), cexRow = 0.7, cexCol = 0.7, Rowv = NA,
        symm = T, reorderfun = NULL, margins = c(8,8), main = 'cor.matrix2')

# Saving...
save(full_data, cor.matrix, file = 'linear_project_data_plot_cor.Rda')
write.csv(full_data, file = 'full_data.csv')
write.csv(cor.matrix, file = 'cor_matrix.csv')
# Run the above once =============================================================

# Loading data
load('linear_project_data_plot_cor.Rda')

# Replace NAs with mean of the column
clean_data <- full_data[, -1]
for (i in 1:ncol(clean_data)){
  clean_data[is.na(clean_data[, i]), i] <- mean(clean_data[, i], na.rm = T)
}
# Better cor matrix
cor.matrix.cleaned <- cor(clean_data)
plot(clean_data[-1], main = 'Scatter Plot for Variables (Cleaned)')

full.model <- lm(Delta.price ~ ., data = clean_data)
summary(full.model)
# Backward elimination method:
# Dropping variables to minimize AIC (quality of fitting & complexity of the model)
reduced.model <- step(full.model, direction = 'backward') # same result as 'forward'

reduced.cor.matrix <- cor(clean_data[ , c(3,7,8,9)]) # Good, predictors are not highly correlated
reduced.cor.matrix

summary(reduced.model)
anova(reduced.model)

library(RColorBrewer)
heatmap(cor.matrix.cleaned, col=brewer.pal(9,"Greys"), cexRow = 0.7, cexCol = 0.7,
        Rowv = NA, symm = T, reorderfun = NULL, margins = c(8,8), main = 'cor.matrix.cleaned')

# Saving...
save(clean_data, reduced.cor.matrix, cor.matrix.cleaned, reduced.model, file = 'linear_project_cleandata_reducedmodel.Rda')
write.csv(clean_data, file = 'clean_data.csv')
write.csv(cor.matrix.cleaned, file = 'cor_matrix_cleaned.csv')
write.csv(reduced.cor.matrix, file = 'reduced_cor_matrix.csv')


# Replace NAs with 0 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
zero_data <- full_data[, -1]
for (i in 1:ncol(zero_data)){
  zero_data[is.na(zero_data[, i]), i] <- 0
}
cor.matrix.zero <- cor(zero_data)

full.model.zero <- lm(Delta.price ~ ., data = zero_data)
summary(full.model.zero)
# Backward elimination method:
# Dropping variables to minimize AIC (quality of fitting & complexity of the model)
reduced.model.zero <- step(full.model.zero, direction = 'backward') # same result as 'forward'

cor(zero_data[ , c(3,7,8,9)]) # Good, predictors are not highly correlated

summary(reduced.model.zero)
anova(reduced.model.zero)

heatmap(cor.matrix.zero, col=brewer.pal(9,"Greys"), cexRow = 0.7, cexCol = 0.7,
        Rowv = NA, symm = T, reorderfun = NULL, margins = c(8,8), main = 'cor.matrix.zero')
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

