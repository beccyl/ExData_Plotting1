library(data.table)

## read first column of file to determine relevant rows
rows <- fread("household_power_consumption.txt", sep=";", header=TRUE, stringsAsFactors=FALSE, colClasses=c("character",rep("NULL",8)))
indices <- rows[,.I[Date=="1/2/2007" | Date=="2/2/2007"]]

## read data for relevant rows
length(indices)
dataset <- fread("household_power_consumption.txt", sep=";", header=FALSE, skip=indices[1], nrows=length(indices), colClasses=c("character","character","numeric", rep("NULL",6)))
setnames(dataset,c("Date","Time","Global_active_power"))

## convert col 2 to DateTime
dataset[,Date:=as.Date(dataset[,Date], format="%d/%m/%Y")]
dataset[,Time:=as.POSIXct(strptime(paste(dataset[,Date],dataset[,Time]),"%Y-%m-%d %H:%M:%S"))]

## construct plot and save to png (480px by 480px)
png(filename="plot2.png", width=480, height=480, units="px") ## open png device

with(dataset, {
  ## plot
  plot(Time, Global_active_power, xlab="", ylab="Global Active Power (kilowatts)", type="l")
})

dev.off()  ## close the device
