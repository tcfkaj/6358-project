setwd("C:/Users...")

final_result <- read.csv('sp500_predictors_run500.csv')
price <- read.csv('Change-in-price.csv', sep='\t')

full_data <- merge(price, final_result[-c(1,2)], by = 'row.names', all.x=TRUE)
colnames(full_data)[1] <- 'Company'

# Scatter Plot and Correlation Matrix
#png('var_plot.png', width = 871, height = 677)
plot(full_data[-1], main = 'Scatter Plot for Variables')
#dev.off()

cor.matrix <- cor(full_data[-1], use='pairwise')

# Saving...
save(full_data, cor.matrix, file = 'linear_project_data_plot_cor.Rda')
write.csv(full_data, file = 'full_data.csv')
write.csv(cor.matrix, file = 'cor_matrix.csv')

# For loading data
load('linear_project_data_plot_cor.Rda')






















