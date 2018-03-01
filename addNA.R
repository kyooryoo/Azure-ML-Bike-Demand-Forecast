set.asPOSIXct <- function(inFrame) { 
  dteday <- as.POSIXct(
    as.integer(inFrame$dteday), 
    origin = "1970-01-01")
  
  as.POSIXct(strptime(
    paste(as.character(dteday), 
          " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S"))
}

char.toPOSIXct <-   function(inFrame) {
  as.POSIXct(strptime(
    paste(inFrame$dteday, " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S")) }

Azure <- FALSE

if(Azure) {
  BikeShare <- maml.mapInputPort(1)
  BikeShare$dteday <- set.asPOSIXct(BikeShare)
} else {
  BikeShare <- read.csv("Bike_Rental.csv", sep=",",
                        header = T, stringsAsFactors = F)
  BikeShare$dteday <- char.toPOSIXct(BikeShare)
}

BikeShare$cnt <- ifelse(BikeShare$cnt < 20, NA, BikeShare$cnt)

if(Azure) maml.mapOutputPort("BikeShare")