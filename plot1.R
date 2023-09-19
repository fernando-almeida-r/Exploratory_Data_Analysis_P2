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

# Question 1
grouped_data <- NEI %>% group_by(year) %>% summarise(Emissions = sum(Emissions/1000000))

png("./plot1.png", width = 480, units = "px")

barplot(names = grouped_data$year, height = grouped_data$Emissions,
        xlab = "Year", ylab = "Total Emission in USA [Mtons]",
        main = "Total Emissions per Year")
text(grouped_data$Emissions, format(round(grouped_data$Emissions,2)), xpd = TRUE, pos = 3)

dev.off()