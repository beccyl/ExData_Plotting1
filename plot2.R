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
png(filename="plot2.png", width=480, height=480, units="px") ## open png device

with(dataset, {
  ## plot
  plot(Time, Global_active_power, xlab="", ylab="Global Active Power (kilowatts)", type="l")
})

dev.off()  ## close the device
