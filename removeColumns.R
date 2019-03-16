library("stringr")
library("readr")

hourlyList <- list.files("hourly_data/")
dailyList <- list.files("daily_data/")

# for the hourly data files
for (name in hourlyList){
  name = paste("hourly_data/", toString(name), sep="")
  
  data = load(name)
  temp$`Site Num` = NULL
  temp$`Parameter Code` = NULL
  temp$POC = NULL
  temp$Datum = NULL
  temp$`Date Local` = NULL
  temp$`Time Local` = NULL
  temp$MDL = NULL
  temp$Uncertainty = NULL
  temp$`Method Type` = NULL
  temp$`Method Code` = NULL
  temp$`Method Name` = NULL
  temp$`Date of Last Change` = NULL
  
  temp$`Combined Codes` <- paste(temp$`State Code`, temp$`County Code`, sep = "")
  
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