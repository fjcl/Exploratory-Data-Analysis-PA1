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
hpc <- fread(input=dataFile, select = c("Date", "Time", "Global_active_power"))

# Create new dateTime column
hpc[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter data between "2007-02-01" and "2007-02-03"
hpc <- filter(hpc, (dateTime >= "2007-02-01") & (dateTime <= "2007-02-03"))

# Next line is needed to display texts in english
Sys.setlocale(category = "LC_ALL", locale = "english")

# Open png device
png("plot2.png", width=480, height=480)

# Plot Global_active_power vs dateTime
plot(x = hpc$dateTime, y = hpc$Global_active_power,
     type="l", xlab="", ylab="Global Active Power (kilowatts)")

# Close device
dev.off()