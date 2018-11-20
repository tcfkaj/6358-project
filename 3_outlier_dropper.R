setwd("C:/")

clean_data <- read.csv('clean_data.csv', row.names = 1)

full.model <- lm(Delta.price ~ ., data = clean_data)
coefficients(full.model)
summary(full.model)

# Influential measures (DFBETAS, DFFITS, COOK's distance, Leverage)
infl <- influence.measures(full.model)
outliers <- summary(infl)
outlist <- rownames(outliers)

# Cook's distance plot
plot(infl[[1]][, "cook.d"], type="l")

# Dropping outliers
dropping <- 0 - as.numeric(outlist)
# length(dropped)
full.model.drop1 <- lm(Delta.price ~ ., data = clean_data, subset = dropping)

# By Residual and QQ plots
dropped <- c(-6,-333,-404,-14,-214,
             -27,-2,-127,-287,
             -384,-426,-49,-181,
             -43,-28,-149,-39,
             -50, -320, -326,
             -9, -119, -440,
             -78,-148, -29,-389,
             -21, -75, -297, -233)
# length(dropped)
full.model.drop2 <- lm(Delta.price ~ ., data = clean_data, subset=dropped)


summary(full.model.drop1) # No good
summary(full.model.drop2)

# Dropping by Residuals vs Leverage plot
droplist <- c(-384, -58, -358, -437, -236, -333, -218, -141, -228, -419, 
              -6, -328, -175, -78, -136, -95, -280, -17, -127, -447, -354, 
              -334, -106, -259, -388, -314, -404, -2, -149, -436, -426, -451, 
              -465, -372, -20, -14, -52, -276, -320, -27, -352, -131)

model1 <- lm(Delta.price ~ ., data = clean_data, subset=droplist)
summary(model1)
plot(model1)
# No good R^2

# Saving...
clean_data_drop <- clean_data[dropped, ]
write.csv(clean_data_drop, file = 'clean_data_drop.csv')

# If replaced NAs with 0 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
zero_data_drop <- zero_data[dropped, ]
write.csv(zero_data_drop, file = 'zero_data_drop.csv')
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


