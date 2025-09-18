library(TTR)
library(forecast)

csv <- "https://s3.us-east-2.amazonaws.com/artificium.us/datasets/waterusage.csv"

# Load the data
water.usage <- read.csv(csv,
                        stringsAsFactors = F)


# weight moving average
weights <- c(0.1, 0.3, 0.6)

wma <- TTR::WMA(water.usage$daily, n=length(weights), wts=weights)

wma

# SES simple exponential smoothing
for (i in 1:nrow(df)) {
  df$Ft[i] <- df$Ft[i-1] + a*df$E[i-1]
  df$E[i] <- df[i,2]  - df$Ft[i] 
}



# Holt winters regression
dailt.ts <- ts(water.usage$daily, start=c(2023,8), frequency=12)
dailt.ts

holt.model <- HoltWinters(dailt.ts,
                          alpha = 0.3,
                          beta = 0.5,
                          gamma = FALSE)
holt.forecast <-  forecast(holt.model, h=1)


# Linear Regression

trend.model <- lm(water.usage$daily~water.usage$period)

trend.forecast <- predict(trend.model, newdata=data.frame(period=13))

trend.model$residuals

trend.model$coefficients[[1]] + trend.model$coefficients[[2]]*12
water.usage$daily[12]

# arima


trend.forecast
holt.forecast
wma[12]



plot(water.usage$daily)
line(water.usage$daily)
