library(data.table)

## read first column of file to determine relevant rows
rows <- fread("household_power_consumption.txt", sep=";", header=TRUE, stringsAsFactors=FALSE, colClasses=c("character",rep("NULL",8)))
indices <- rows[,.I[Date=="1/2/2007" | Date=="2/2/2007"]]
length(indices)

## read data for relevant rows
dataset <- fread("household_power_consumption.txt", sep=";", header=FALSE, skip=indices[1], nrows=length(indices), colClasses=c("character","character","numeric", rep("NULL",6)))
setnames(dataset,c("Date","Time","Global_active_power"))

## convert col 1 to Date
dataset[,Date:=as.Date(dataset[,Date], format="%d/%m/%Y")]
## convert col 2 to DateTime
dataset[,Time:=as.POSIXct(strptime(paste(dataset[,Date],dataset[,Time]),"%Y-%m-%d %H:%M:%S"))]

## construct plot and save to png (480px by 480px)
png(filename="plot1.png", width=480, height=480, units="px") ## open png device

with(dataset, {
  ## create histogram: global active power versus frequency
  hist(Global_active_power, xlab="Global Active Power (kilowatts)", main="Global Active Power", col="red")
})

dev.off()  ## close the device
