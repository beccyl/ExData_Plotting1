library(data.table)

## read first column of file to determine relevant rows
rows <- fread("household_power_consumption.txt", sep=";", header=TRUE, stringsAsFactors=FALSE, colClasses=c("character",rep("NULL",8)))
indices <- rows[,.I[Date=="1/2/2007" | Date=="2/2/2007"]]

## read data for relevant rows
dataset <- fread("household_power_consumption.txt", sep=";", header=FALSE, skip=indices[1], nrows=length(indices), colClasses=c("character","character",rep("numeric",3), "NULL",rep("numeric",3)))
setnames(dataset,c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Sub_metering_1","Sub_metering_2","Sub_metering_3"))

## convert col 1 to Date
dataset[,Date:=as.Date(dataset[,Date], format="%d/%m/%Y")]
## convert col 2 to DateTime
dataset[,Time:=as.POSIXct(strptime(paste(dataset[,Date],dataset[,Time]),"%Y-%m-%d %H:%M:%S"))]

## construct plot and save to png (480px by 480px)
png(filename="plot4.png", width=480, height=480, units="px", bg="transparent") ## open png device

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
