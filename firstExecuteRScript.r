## This file contains the code for the simple filtering
## and ploting of the raw bike rental data. 
## This code is intended to run in an 
## Azure ML Execute R Script module. By changing
## the following vaiable to false the code will run
## in R or RStudio.
Azure <- FALSE

## in R studio, change the working directory if necessary
## getwd()
## setwd("/Users/user/Workspace/Azure-ML-Bike-Demand-Forecast")
## getwd()

## If we are in Azure, source the utilities from the zip
## file. The next lines of code read in the dataset, either 
## in Azure ML or from a csv file for testing purposes.
## when zip the source file, DO NOT put it in a src directory
## Azure will unzip it and put it in its src directory
if(Azure){
  source("src/utilities.R")
  BikeShare <- maml.mapInputPort(1)
  BikeShare$dteday <- set.asPOSIXct(BikeShare)
}else{
  source("utilities.r")
  BikeShare <- read.csv("Bike_Rental.csv", sep = ",", 
                        header = T, stringsAsFactors = F )
  BikeShare$dteday <- char.toPOSIXct(BikeShare)
}

require(dplyr)
print("Before the subset operation the dimensions are:")
print(dim(BikeShare))
BikeShare <- BikeShare %>% filter(cnt > 100)
print("After the subset operation the dimensions are:")
print(dim(BikeShare))

require(ggplot2)
qplot(dteday, cnt, data=subset(BikeShare, hr == 9), geom="line")

if(Azure) maml.mapOutputPort("BikeShare")