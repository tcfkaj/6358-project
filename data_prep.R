library(tidyverse)
library(imputeTS)


## Put together predictors and Price

predictors <- read.csv('sp500_predictors_run500.csv', row.names = 2)
price <- read.csv('Change-in-price.csv', sep='\t')
full.data <- merge(price, predictors[ , -1], by = 'row.names', all.x=TRUE)
colnames(full.data)[1] <- 'Company'
head(full.data)

## Clean NAs

clean.data <- full.data
for (i in colnames(full.data)){
	clean.data[i] <- clean.data[i] %>%
		na.mean()
}
head(clean.data)
