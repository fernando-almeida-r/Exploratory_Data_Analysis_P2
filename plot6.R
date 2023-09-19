install.packages("dplyr")
install.packages("ggplot2")
install.packages("gridExtra")
library(dplyr)
library(ggplot2)
library(gridExtra)

# Downloading and uploading data
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)

NEI <- readRDS(unzip(temp,"summarySCC_PM25.rds"))
SCC <- readRDS(unzip(temp,"Source_Classification_Code.rds"))
unlink(temp)

# Correlate data from SCC and NEI
NEI <- NEI %>% left_join(SCC, by = join_by(SCC == SCC))

# Question 6
grouped_data <- NEI[grepl("Vehicle", NEI$EI.Sector),] 
grouped_data <- grouped_data[grouped_data$fips == "24510" | grouped_data$fips == "06037",] %>% group_by(year, fips) %>% summarise(Emissions = sum(Emissions))

png("./plot6.png", width = 480, units = "px")

ggplot(grouped_data, aes(x = as.factor(grouped_data$year), y = grouped_data$Emissions)) +
        geom_col() + theme_bw() + facet_wrap(~fips, scales = "free")

dev.off()