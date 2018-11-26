setwd("C:/")

final_result <- read.csv('sp500_predictors_run500.csv', row.names = 2)
# For merging additional variables
#final_result_v2 <- read.csv('sp500_predictors_run500_v2.csv', row.names = 2)
price <- read.csv('Change-in-price.csv', sep='\t')

full_data <- merge(price, final_result[ , -1], by = 'row.names', all.x=TRUE)
#rownames(full_data) <- full_data$Row.names
#full_data <- merge(full_data[ , -1], final_result_v2[ , -1], by = 'row.names', all.x=TRUE)
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
#save(full_data, cor.matrix, file = 'linear_project_data_plot_cor.Rda')
write.csv(full_data, file = 'full_data_v2.csv')
#write.csv(cor.matrix, file = 'cor_matrix.csv')
# Run the above once =============================================================

# Loading data
#load('linear_project_data_plot_cor.Rda')
full_data <- read.csv('full_data_v2.csv', row.names = 1)

# Replace NAs with mean of the column
clean_data <- full_data[, -1]

# Clean NAs of Dividends as 0.
clean_data[is.na(clean_data[, 3]), 3] <- 0

for (i in 1:ncol(clean_data)){
  clean_data[is.na(clean_data[, i]), i] <- mean(clean_data[, i], na.rm = T)
}

# Checking infinite values
for (i in 1:ncol(clean_data)){
  print(clean_data[is.infinite(clean_data[, i]), i])
}

# Saving...
write.csv(clean_data, file = 'clean_data.csv')

# Replace NAs with 0 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
zero_data <- full_data[, -1]
for (i in 1:ncol(zero_data)){
  zero_data[is.na(zero_data[, i]), i] <- 0
}

# Saving...
write.csv(zero_data, file = 'zero_data.csv')
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

