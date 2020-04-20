library("data.table")
library("ggplot2")

setwd('~/Coursera/Data_science/datasciencecoursera/course_4/project2')
path <- file.path(getwd(), 'data')

# download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#               , destfile = paste(path, "dataFiles.zip", sep = "/"))
# unzip(zipfile = "dataFiles.zip")

SCC <- data.table::as.data.table(x = readRDS(file =  file.path(path, "dataFiles", "Source_Classification_Code.rds")))
NEI <- data.table::as.data.table(x = readRDS(file = file.path(path, "dataFiles", "summarySCC_PM25.rds")))

vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]
bal_nei <- vehiclesNEI[vehiclesNEI$fips==24510,]

#plot
png(filename="plot5.png", width = 480, height = 480)
ggp <- ggplot(bal_nei,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y="Total PM2.5 Emission (Tons)") +
  labs(title="PM2.5 Baltimore Motor Vehicle Emissions")
print(ggp)
dev.off()