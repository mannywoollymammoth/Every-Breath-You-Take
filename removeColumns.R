library("stringr")
library("readr")

hourlyList <- list.files("hourly_data/")
dailyList <- list.files("daily_data/")

# for the hourly data files
for (name in hourlyList){
  name = paste("hourly_data/", toString(name), sep="")
  
  data = load(name)
  temp$`State Code` = NULL
  temp$`County Code` = NULL
  temp$Latitude = NULL
  temp$Longitude = NULL
  temp$`Site Num` = NULL
  temp$`Parameter Code` = NULL
  temp$POC = NULL
  temp$Datum = NULL
  temp$`Date Local` = NULL
  temp$`Time Local` = NULL
  temp$MDL = NULL
  temp$Qualifier = NULL
  temp$Uncertainty = NULL
  temp$`Method Type` = NULL
  temp$`Method Code` = NULL
  temp$`Method Name` = NULL
  temp$`Date of Last Change` = NULL
  
  # if this is the winds file, remove all the wind direction data - we only want wind speed
  if(name == "hourly_WIND_2018.Rdata") {
    temp <- subset(temp, temp$`Parameter Name` == "Wind Speed - Resultant")
  }
  
  save(temp, file = name)
}

# for the daily data files
for (name in dailyList){
  name = paste("daily_data/", toString(name), sep="")
  
  data = load(name)
  temp$`Defining Site` = NULL
  temp$`Number of Sites Reporting` = NULL
  
  temp$`Combined Codes` <- paste(temp$`State Code`, temp$`County Code`, sep = "")
  
  save(temp, file = name)
}