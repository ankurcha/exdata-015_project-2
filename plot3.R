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

# keep only baltimore data
NEI_Baltimore <- NEI[NEI$fips == 24510, ]

# group by year
group_year_type <- group_by(NEI_Baltimore, year, type)

# summarize dataset by summing Emissions into total_emissions
total_emissions_type_year <- summarise(group_year_type, total_emissions=sum(Emissions))

# make bar chart showing changes of total emissions from 1999 to 2008 by type
plot <- ggplot(total_emissions_type_year, aes(x = factor(type), y = total_emissions, fill=factor(year))) +
  geom_bar(stat = "identity", position="dodge") +
  scale_size_area() + 
  xlab("Type") +
  ylab("Total PM2.5 Emissions")  +
  scale_fill_discrete(name="Year")
plot + ggtitle("Change in Total Emissions in Baltimore by Type")

dev.copy(png, "plot3.png")
dev.off()
