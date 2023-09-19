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

# Question 4
grouped_data <- NEI[grepl("Coal", NEI$EI.Sector),] %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

ggplot(grouped_data, aes(x = as.factor(year), y = Emissions)) +
        geom_col()  + theme_bw()
