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
hpc <- fread(input=dataFile, select = c("Date", "Time", "Global_active_power",
                                        "Global_reactive_power", "Voltage",
                                        "Sub_metering_1", "Sub_metering_2",
                                        "Sub_metering_3"))



# Create new dateTime column
hpc[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter data between "2007-02-01" and "2007-02-03"
hpc <- filter(hpc, (dateTime >= "2007-02-01") & (dateTime <= "2007-02-03"))

# Next line is needed to display texts in english
Sys.setlocale(category = "LC_ALL", locale = "english")

# Open png device
png("plot4.png", width=480, height=480)

# Combine plots in a 2x2 matrix
par(mfrow=c(2,2))

# Plot Global_active_power vs dataTime (top-left)
plot(hpc$dateTime, hpc$Global_active_power, type="l", xlab="", ylab="Global Active Power")

# Plot Voltage vs dataTime (top-right)
plot(hpc$dateTime, hpc$Voltage,
     type="l",xlab="datetime", ylab="Voltage")

# Plot Energy submetering vs dateTime (bottom-left)
plot(hpc$dateTime, hpc$Sub_metering_1,
     type="l", xlab="", ylab="Energy sub metering")
lines(hpc$dateTime, hpc$Sub_metering_2, col="red")
lines(hpc$dateTime, hpc$Sub_metering_3, col="blue")
legend("topright"
       , col=c("black","red","blue")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       , lty=c(1,1), bty="n", cex=.8)

# Plot Global_reactive_power vs dateTime (bottom-right)
plot(hpc$dateTime, hpc$Global_reactive_power,
     type="l", xlab="datetime", ylab="Global Reactive Power")

# Close device
dev.off()