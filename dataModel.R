library(lubridate)
library(DT)
library(jpeg)
library(grid)
library(leaflet)
library(scales)
library(stringr)
library(tidyr)

# data model script

readDailyData <- function(){
  
  temp = list.files("daily_data/")
  # append daily_data/ to the beginning of each file name
  temp2 = list
  for(name in temp) {
    newname = paste("daily_data/", toString(name), sep="")
    temp2 <- c(temp2, newname)
  }
  temp2[1] <- NULL
  
  # join
  listedData <- lapply(temp2, function(x) {
    load(file = x)
    get(ls()[ls()!= "filename"])
  })
  dailyData <- do.call(rbind, listedData)
  
  dailyData <- separate(dailyData, Date, c("Year", "Month", "Day"), sep = "-")
  
  year_list <- unique(as.vector(dailyData$Year))
  state_list <- unique(as.vector(dailyData$`State Name`))
  aqi_list <- c("Good","Moderate", "Unhealthy for Sensitive Groups",
                "Unhealthy","Very Unhealthy","Hazardous")
  pollutant_list <- c("ozone", "SO2", "CO", "NO2", "PM2.5", "PM10")
  
  return(dailyData)
}

readHourlyData <- function(){

  temp = list.files("hourly_data/")
  # append daily_data/ to the beginning of each file name
  temp2 = list
  for(name in temp) {
    newname = paste("hourly_data/", toString(name), sep="")
    temp2 <- c(temp2, newname)
  }
  temp2[1] <- NULL

  # join
  listedData <- lapply(temp2, function(x) {
    load(file = x)
    get(ls()[ls()!= "filename"])
  })
  hourlyData <- do.call(rbind, listedData)
  
  print(hourlyData)

  #hourlyData <- separate(hourlyData, Date, c("Year", "Month", "Day"), sep = "-")

  return(hourlyData)
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


AQIDataFrom1990to2018 <- function(justOneState, justOneCounty,justOneYear, dailyData){
  parseByState <-
    subset(dailyData, dailyData$`State Name` == justOneState)
  print("parse by state")
  print(parseByState)
  
  parseByCounty <-
    subset(parseByState, parseByState$`county Name` == justOneCounty)
  parseByYear <- subset(parseByCounty, parseByCounty$Year == justOneYear)
  return(parseByYear)
} 






