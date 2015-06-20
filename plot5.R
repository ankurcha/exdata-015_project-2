require('ggplot2')
require('dplyr')

setwd("~/Downloads/exdata-data-NEI_data")
# loadd data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# prepare data
NEI$year <- as.factor(NEI$year)
NEI$SCC <- as.factor(NEI$SCC)
NEI$Pollutant <- as.factor(NEI$Pollutant)
NEI$type <- as.factor(NEI$type)

NEI_Baltimore <- NEI[NEI$fips == 24510, ]

# filter SCC table using EI.Sector variable
# looked at other variables, but the EI.Sector variable looked like the right one to use
# created a filter vector from SCC table to apply to NEI data frame
SCC_Filter <- as.character(SCC[SCC$EI.Sector %in% SCC$EI.Sector[grep("Vehicle",SCC$EI.Sector)], "SCC"])

# apply filter to NEI data frame
NEI_Baltimore_Vehicle_Combustion <- NEI_Baltimore[NEI_Baltimore$SCC %in% SCC_Filter,]

# group by year
group_year <- group_by(NEI_Baltimore_Vehicle_Combustion, year)

# summarize by summing emissions
emissions_by_year <- summarise(group_year, total_emissions=sum(Emissions))

# plot
plot(emissions_by_year$year, 
     emissions_by_year$total_emissions, 
     cex=0.6, 
     ylab="Emissions",
     xlab="Year",
     pch=5,
     main="pm2.5 emissions in Baltimore \nfor Vehicles by Year")
abline(lm(emissions_by_year$total_emissions~as.integer(emissions_by_year$year)), col="red", lwd=1.5)
legend(x="topright", 
       legend=c("Emissions","Regression Line"), 
       pch=c(5,NA), 
       lwd=c(NA,1.5), 
       col=c("blue", "red"), 
       cex=0.8)

# save plot to png file
dev.copy(png, "plot5.png")
dev.off()
