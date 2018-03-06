
library(sqldf)
library(lubridate)
library(chron)

##Create a working directory if it does not already exist
  if (!file.exists("workingDir")){
  dir.create("workingDir")
}
setwd("workingDir")

##Downloading the Electric Power Consumption dataset
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "data.zip", mode = "wb")
unzip(zipfile="data.zip", exdir = "./data")


##First calculate a rough estimate of how much memory the dataset will require in memory before reading into R
## 9 columns * 2075259 rows * 8 bytes
memory_required = round((9 * 2075259 * 8) / 1048576)

print(paste("Estimated memory usage:", memory_required, "MB"))

##Reading the necessary data and filter on the dates 1/2/2007 or 2/2/2007
consumptionData <- read.csv.sql("data/household_power_consumption.txt", sep = ";", header = TRUE, sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'")

## Set NA values
consumptionData[consumptionData == "?"] <- NA

## Set date values
consumptionData$Date = strptime(consumptionData$Date, "%d/%m/%Y")

## Set time values
consumptionData$Time = times(consumptionData$Time)

## For visualisation purposes
dow <- function(x) as.integer(format(as.Date(x), "%d"))
consumptionData$dayTime <- dow(consumptionData$Date) + consumptionData$Time

##Plot 2
png('plot2.png')
#consumptionData$dayName <- wday(as.Date(consumptionData$Date), label=TRUE)
plot(consumptionData$dayTime, consumptionData$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)",xlab = "",xaxt = "n")
axis(side=1, at=c(1,2,3), labels=c("Thu","Fri","Sat"))
dev.off()
