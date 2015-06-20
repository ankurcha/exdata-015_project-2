require('ggplot2')
require('plyr')
require('dplyr')

setwd("~/Downloads/exdata-data-NEI_data")
# loadd data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# filter out data for Baltimore and LA
Baltimore_LA <- NEI[(NEI$fips == "24510" | NEI$fips == "06037"),]

SCC$EI.Sector <- as.character(SCC$EI.Sector)
Baltimore_LA$SCC <- mapvalues(Baltimore_LA$SCC, SCC$SCC, SCC$EI.Sector)
Baltimore_LA$fips <- mapvalues(Baltimore_LA$fips, c("24510", "06037"), c("Baltimore City", "Los Angeles"))
NEI_subset <- Baltimore_LA[grep("Vehicles", Baltimore_LA$SCC), ]

Emissions <- NEI_subset$Emissions
year<- NEI_subset$year
place <- NEI_subset$fips
temp <- data.frame(year,Emissions, place)
temp <- temp %>% group_by(year, place) %>% summarise_each(funs(sum))
temp$place <- as.factor(temp$place)

qplot(year, 
      Emissions, 
      data = temp, 
      geom = c("point", "smooth"),
      main = "Vehicle Emissions in Baltimore vs LA", 
      facets = .~place)

# save plot
dev.copy(png, "plot6.png")
dev.off()
