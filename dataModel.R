library(lubridate)
library(DT)
library(jpeg)
library(grid)
library(leaflet)
library(scales)
library(stringr)
library(tidyr)



#data model script
readData <- function(){
  
  temp2 = list.files( pattern = "*.Rdata")
  listedData2 <- lapply(temp2, function(x) {
    load(file = x)
    get(ls()[ls()!= "filename"])
  })
  allData <- do.call(rbind, listedData2)
  allData <- separate(allData, Date, c("Year", "Month", "Day"), sep = "-")
  
  
  
  year_list <- unique(as.vector(allData$Year))
  state_list <- unique(as.vector(allData$`State Name`))
  aqi_list <- c("Good","Moderate", "Unhealthy for Sensitive Groups",
                "Unhealthy","Very Unhealthy","Hazardous")
  pollutant_list <- c("ozone", "SO2", "CO", "NO2", "PM2.5", "PM10")
  
  return(allData)
}

getTop100CountiesfromAQI <- function() {
  oneYearAQI <- oneYearAQIReactive()
  
  #print("from reactive:!!!!!!!!!!!")
  #print(oneYearAQI)
  
  oneYearAQI <- oneYearAQI[order(-oneYearAQI$AQI),]
  
  # get first 100 unique values
  
  print("after sort??")
  print(oneYearAQI)
  
  oneYearAQI
}

getTop100CountiesfromPollutants <- function() {
  oneYearAQI <- oneYearPollutantReactive()
  
  print("from reactive:!!!!!!!!!!!")
  print(oneYearAQI)
  
  oneYearAQI <- oneYearAQI[order(-oneYearAQI$AQI),]
  
  # get first 100 unique values
  
  print("after sort??")
  print(oneYearAQI)
  
  oneYearAQI
}


AQIDataFrom1990to2018 <- function(justOneState, justOneCounty,justOneYear, allData){
  parseByState <-
    subset(allData, allData$`State Name` == justOneState)
  print("parse by state")
  print(parseByState)
  
  parseByCounty <-
    subset(parseByState, parseByState$`county Name` == justOneCounty)
  parseByYear <- subset(parseByCounty, parseByCounty$Year == justOneYear)
  return(parseByYear)
} 






