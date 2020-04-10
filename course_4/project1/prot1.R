# Title     : Plot 1
# Objective : TODO
# Created by: sachaliguori
# Created on: 09/04/2020

library("data.table")
setwd('~/Coursera/Data_science/datasciencecoursera/course_4/project1')
path <- file.path(getwd(), 'data')

powerDT <- data.table::fread(input = "data/household_power_consumption.txt", na.strings="?")

powerDT[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

# Filter Dates for 2007-02-01 and 2007-02-02
powerDT <- powerDT[(Date >= "2007-02-01") & (Date <= "2007-02-02")]

png("plot1.png", width=480, height=480)

## Plot 1
hist(powerDT[, Global_active_power], main="Global Active Power",
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

dev.off()