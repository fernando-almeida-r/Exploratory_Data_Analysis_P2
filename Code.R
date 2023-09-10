install.packages("dplyr")
install.packages("ggplot2")
install.packages("gridExtra")
library(dplyr)
library(ggplot2)
library(gridExtra)

# Downloading and uploading data
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
#setwd("C:/Users/ferna/Downloads/exdata_data_NEI_data")
NEI <- readRDS(unzip(temp,"summarySCC_PM25.rds"))
SCC <- readRDS(unzip(temp,"Source_Classification_Code.rds"))
unlink(temp)

# Correlate data from SCC and NEI
NEI <- NEI %>% left_join(SCC, by = join_by(SCC == SCC))

grouped_data <- NEI %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

plot(grouped_data$year, grouped_data$Emissions,
     xlab = "Year", ylab = "Total Emission in USA",
     main = "Total Emissions per Year",
     pch = 19)

grouped_data <- NEI[NEI$fips=="24510",] %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

plot(grouped_data$year, grouped_data$Emissions,
     xlab = "Year", ylab = "Total Emission in Baltimore City, Maryland",
     main = "Total Emissions per Year",
     pch = 19)


grouped_data <- NEI %>% group_by(year, type) %>% summarise(Emissions = sum(Emissions))

ggplot(grouped_data) +
        geom_point(aes(year, Emissions)) + facet_wrap(~type, scales = "free")


