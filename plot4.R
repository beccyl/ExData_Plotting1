## read the file
conn <- file("household_power_consumption.txt","rt")  ## open file connection
header <- readLines(conn,n=1)  ## read the header
lines <- readLines(conn)  ## read the remaining file
close(conn) ## close file connection

lines <- grep("^[12]/2/2007", lines, value=TRUE)  ## filter only wanted lines
lines <- c(header,lines)  ## add the header back

## read data into a table, and convert col 1 to date
setClass("myDate")
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
dataset <- read.table(textConnection(lines), header=TRUE, sep=";", stringsAsFactors=FALSE, na.strings="?", colClasses=c("myDate", "character", rep("numeric", 7)))

## convert col 2 to DateTime
dataset[,"Time"]<-list(strptime(paste(dataset[,"Date"],dataset[,"Time"]), "%Y-%m-%d %H:%M:%S"))

## construct plot and save to png (480px by 480px)
png(filename="plot4.png", width=480, height=480, units="px") ## open png device

## multiple plots (2 rows, 2 column)
par(mfrow=c(2,2))
with(dataset, {
  ## plot 1
  plot(Time, Global_active_power, xlab="", ylab="Global Active Power", type="l")
  
  ## plot 2
  plot(Time, Voltage, type="l", xlab="datetime")
  
  ## plot 3
  plot(Time, Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
  points(Time, Sub_metering_2, type="l", col="red")
  points(Time, Sub_metering_3, type="l", col="blue")
  legend("topright", col=c("black","red","blue"), cex=0.95,legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty="n", lty=1)
  
  ## plot 4
  plot(Time, Global_reactive_power, type="l", xlab="datetime")
})
dev.off()  ## close the device
