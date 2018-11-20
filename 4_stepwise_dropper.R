# After dropping outliers in Step 3
clean_data_drop <- read.csv('clean_data_drop_v2.csv', row.names = 1)

# Better cor matrix
cor.matrix.cleaned <- cor(clean_data_drop)
plot(clean_data_drop, main = 'Scatter Plot for Variables (Cleaned)')

full.model <- lm(Delta.price ~ ., data = clean_data_drop)
summary(full.model)
# Backward elimination method: 
# Dropping variables to minimize AIC (quality of fitting & complexity of the model)
reduced.model <- step(full.model, direction = 'backward') # same result as 'forward'

reduced.cor.matrix <- cor(clean_data_drop[ , rownames(coefficients(summary(reduced.model)))[-1]]) # Good, predictors are not highly correlated
reduced.cor.matrix

summary(reduced.model)
anova(reduced.model)

library(RColorBrewer)
heatmap(cor.matrix.cleaned, col=brewer.pal(9,"Greys"), cexRow = 0.7, cexCol = 0.7,
        Rowv = NA, symm = T, reorderfun = NULL, margins = c(8,8), main = 'cor.matrix.cleaned')

# Saving...
write.csv(cor.matrix.cleaned, file = 'cor_matrix_cleaned.csv')
write.csv(reduced.cor.matrix, file = 'reduced_cor_matrix.csv')

# If replaced NAs with 0 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
zero_data_drop <- read.csv('zero_data_drop.csv', row.names = 1)

cor.matrix.zero <- cor(zero_data_drop)

full.model.zero <- lm(Delta.price ~ ., data = zero_data_drop)
summary(full.model.zero)
# Backward elimination method: 
# Dropping variables to minimize AIC (quality of fitting & complexity of the model)
reduced.model.zero <- step(full.model.zero, direction = 'backward') # same result as 'forward'

cor(zero_data_drop[ , rownames(coefficients(summary(reduced.model.zero)))[-1]]) # Good, predictors are not highly correlated

summary(reduced.model.zero)
anova(reduced.model.zero)

heatmap(cor.matrix.zero, col=brewer.pal(9,"Greys"), cexRow = 0.7, cexCol = 0.7,
        Rowv = NA, symm = T, reorderfun = NULL, margins = c(8,8), main = 'cor.matrix.zero')
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

