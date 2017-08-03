library(data.table)
library(dplyr)

# Download data (if not present)
zipFile <- "household_power_consumption.zip"
dataFile <- "household_power_consumption.txt"
if (!file.exists(zipFile)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileURL, zipFile, method="curl")
}  
if (!file.exists(dataFile))
        unzip(zipFile)

#Read house power consumption data (only the data needed to create the plot)
hpc <- fread(input=dataFile, select = c("Date", "Global_active_power"))

# Change Date Column to date type
hpc[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

# Change Global_active_power Column to numeric type
hpc[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Filter data between "2007-02-01" and "2007-02-02"
hpc <- filter(hpc, (Date >= "2007-02-01") & (Date <= "2007-02-02"))

# Next line is needed to display texts in english
Sys.setlocale(category = "LC_ALL", locale = "english")

# Open png device
png("plot1.png", width=480, height=480)

# Plot Global_active_power histogram
hist(hpc$Global_active_power, main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

# Close device
dev.off()