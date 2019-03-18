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
  final_list = list
  for(name in temp) {
    newname = paste("daily_data/", toString(name), sep="")
    final_list <- c(final_list, newname)
  }
  print("the daily data list")
  print(final_list)
  
  final_list[1] <- NULL
  
  # join
  listedData <- lapply(final_list, function(x) {
    load(file = x)
    get(ls()[ls()!= "filename"])
  })
  dailyData <- do.call(rbind, listedData)
  
  dailyData <- separate(dailyData, Date, c("Year", "Month", "Day"), sep = "-", remove = FALSE)
  
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

getTopCountiesfromAQI <- function(daily_data, justOneYear, justManyCounties) {
 

  print("THis is the year")
  print(justOneYear)
  
  daily_data <- subset(daily_data, daily_data$Year == justOneYear)
  daily_data <- daily_data[order(-daily_data$AQI),]
  daily_data$Date <- format(yday(daily_data$Date))
  daily_data$GEOID <- paste(daily_data$`State Code`,sep = "" ,daily_data$`County Code`)
  
  newTable <- aggregate(daily_data$AQI, list(daily_data$GEOID),mean )
  newTable <- newTable[order(-newTable$x),]
  colnames(newTable) <- c("GEOID", "AQI")
  newTable$GEOID <- as.character(newTable$GEOID)
  print(newTable[1:100,])
  
  return(newTable[1:justManyCounties,])
}

getTopCountiesfromPollutants <- function(daily_data, justOneYear, justManyCounties, justOnePollutant) {
  print("THis is the year")
  print(justOneYear)
  
  daily_data <- subset(daily_data, daily_data$Year == justOneYear)
  daily_data <- subset(daily_data, daily_data$`Defining Parameter` == justOnePollutant)
  daily_data <- daily_data[order(-daily_data$AQI),]
  daily_data$Date <- format(yday(daily_data$Date))
  daily_data$GEOID <- paste(daily_data$`State Code`,sep = "" ,daily_data$`County Code`)
  
  newTable <- aggregate(daily_data$AQI, list(daily_data$GEOID),mean )
  newTable <- newTable[order(-newTable$x),]
  colnames(newTable) <- c("GEOID", "AQI")
  newTable$GEOID <- as.character(newTable$GEOID)
  print(newTable[1:100,])
  
  return(newTable[1:justManyCounties,])
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

#returns the data for a specified year from 1990 to 2018
AQIDataForYear <- function(justOneState, justOneCounty, dailyData){
  parseByState <-
    subset(dailyData, dailyData$`State Name` == justOneState)
  #print("parse by state")
  #print(parseByState)
  
  parseByCounty <-
    subset(parseByState, parseByState$`county Name` == justOneCounty)
  
  parseByCounty$index <- seq.int(nrow(parseByCounty))
  return(parseByCounty)
} 




#adds data color columns for graphing 
addAQIColor <- function(daily_data){
  daily_data$Color = "black"
  colorVector <- brewer.pal(n=6,name = 'Set1')
  daily_data$Color[daily_data$`Defining Parameter`=="Ozone"]= colorVector[6]
  daily_data$Color[daily_data$`Defining Parameter`=="SO2"]= colorVector[5]
  daily_data$Color[daily_data$`Defining Parameter`=="CO2"]= colorVector[4]
  daily_data$Color[daily_data$`Defining Parameter`=="NO2"]= colorVector[3]
  daily_data$Color[daily_data$`Defining Parameter`=="PM2.5"]= colorVector[2]
  daily_data$Color[daily_data$`Defining Parameter`=="PM10"]= colorVector[1]
  return(daily_data)
}

yearlyBarChartData <- function(daily_data){

}



