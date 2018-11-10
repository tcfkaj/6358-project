load("2011/master.Rda")
ls()

library(tidyverse)

dim(master)

avg.2011 <- master %>%
		apply(2, mean)

rm(master)
load("2017/master.Rda")


avg.2017 <- master %>%
		apply(2, mean)

avg.2017
avg.2011

sp500.delta.price <- (avg.2017-avg.2011)/avg.2011
sp500.delta.price
sp500.delta.price <- data.frame('Delta.price'=sp500.delta.price)
head(sp500.delta.price)

write.table(sp500.delta.price, file = "Change-in-price2.csv",row.names=TRUE,col.names=TRUE, sep="\t")
