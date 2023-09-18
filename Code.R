install.packages("dplyr")
install.packages("ggplot2")
install.packages("gridExtra")
library(dplyr)
library(ggplot2)
library(gridExtra)

# Downloading and uploading data
temp <- tempfile()
download.file(https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip,temp)
#setwd("C:/Users/ferna/Downloads/exdata_data_NEI_data")
NEI <- readRDS(unzip(temp,"summarySCC_PM25.rds"))
SCC <- readRDS(unzip(temp,"Source_Classification_Code.rds"))
unlink(temp)

# Correlate data from SCC and NEI
NEI <- NEI %>% left_join(SCC, by = join_by(SCC == SCC))

# Question 1
grouped_data <- NEI %>% group_by(year) %>% summarise(Emissions = sum(Emissions/1000000))

barplot(names = grouped_data$year, height = grouped_data$Emissions,
        xlab = "Year", ylab = "Total Emission in USA [Mtons]",
        main = "Total Emissions per Year")
text(grouped_data$Emissions, format(round(grouped_data$Emissions,2)), xpd = TRUE, pos = 3)

# Question 2
grouped_data <- NEI[NEI$fips=="24510",] %>% group_by(year) %>% summarise(Emissions = sum(Emissions)/1000)

barplot(names = grouped_data$year, height = grouped_data$Emissions,
        xlab = "Year", ylab = "Total Emission in Baltimore City, Maryland [ktons]",
        main = "Total Emissions per Year")
text(grouped_data$Emissions, format(round(grouped_data$Emissions,2)), xpd = TRUE, pos = 3)

# Question 3
grouped_data <- NEI %>% group_by(year, type) %>% summarise(Emissions = sum(Emissions))

ggplot(grouped_data, aes(x = as.factor(year), y = Emissions)) +
        geom_col() + facet_wrap(~type, scales = "free") + theme_bw()

# Question 4
grouped_data <- NEI[grepl("Coal", NEI$EI.Sector),] %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

ggplot(grouped_data, aes(x = as.factor(year), y = Emissions)) +
        geom_col()  + theme_bw()

# Question 5
grouped_data <- NEI[grepl("Vehicle", NEI$EI.Sector),] 
grouped_data <- grouped_data[NEI$fips == "24510",] %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

ggplot(grouped_data, aes(x = as.factor(grouped_data$year), y = grouped_data$Emissions)) +
        geom_col() + theme_bw()

# Question 6
grouped_data <- NEI[grepl("Vehicle", NEI$EI.Sector),] 
grouped_data <- grouped_data[grouped_data$fips == "24510" | grouped_data$fips == "06037",] %>% group_by(year, fips) %>% summarise(Emissions = sum(Emissions))

ggplot(grouped_data, aes(x = as.factor(grouped_data$year), y = grouped_data$Emissions)) +
        geom_col() + theme_bw() + facet_wrap(~fips, scales = "free")



