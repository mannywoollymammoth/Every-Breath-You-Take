library(lubridate)
library(DT)
library(jpeg)
library(grid)
library(leaflet)
library(scales)
library(stringr)
library(tidyr)

#-------------
library(RColorBrewer)

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

#returns the data for a specified year from 1990 to 2018
AQIDataFrom1990to2018 <- function(justOneState, justOneCounty,justOneYear, dailyData){
  parseByState <-
    subset(dailyData, dailyData$`State Name` == justOneState)
  #print("parse by state")
  #print(parseByState)
  
  parseByCounty <-
    subset(parseByState, parseByState$`county Name` == justOneCounty)
  parseByYear <- subset(parseByCounty, parseByCounty$Year == justOneYear)
  parseByYear$index <- seq.int(nrow(parseByYear))
  return(parseByYear)
} 

#adds data color columns for graphing 
addAQIColor <- function(daily_data){
  daily_data$Color = "black"
  colorVector <- brewer.pal(n=6,name = 'RdYlBu')
  daily_data$Color[daily_data$Category=="Good"]= colorVector[6]
  daily_data$Color[daily_data$Category=="Moderate"]= colorVector[5]
  daily_data$Color[daily_data$Category=="Unhealthy for Sensitive Groups"]= colorVector[4]
  daily_data$Color[daily_data$Category=="Unhealthy"]= colorVector[3]
  daily_data$Color[daily_data$Category=="Very Unhealthy"]= colorVector[2]
  daily_data$Color[daily_data$Category=="Hazardous"]= colorVector[1]
  return(daily_data)
}

yearlyBarChartData <- function(daily_data){

}



