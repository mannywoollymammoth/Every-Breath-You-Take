library("stringr")
library("readr")

hourlyList <- list.files("hourly_data/")

# for the hourly data files
for (name in hourlyList) {
  old_name = paste("hourly_data/", toString(name), sep="")
  
  data = load(old_name)
  temp <- subset(temp, (temp$`State Name` == "Illinois" & temp$`County Name` == "Cook") | 
                   (temp$`State Name` == "Hawaii" & temp$`County Name` == "Hawaii") |
                   (temp$`State Name` == "New York" & temp$`County Name` == "New York") |
                   (temp$`County Name` == "Los Angeles" & temp$`State Name` == "California") |
                   (temp$`County Name` == "King" & temp$`State Name` == "Washington") |
                   (temp$`County Name` == "Harris" & temp$`State Name` == "Texas") |
                   (temp$`County Name` == "Miami-Dade" & temp$`State Name` == "Florida") |
                   (temp$`County Name` == "San Juan" & temp$`State Name` == "New Mexico") |
                   (temp$`County Name` == "Hennepin" & temp$`State Name` == "Minnesota") |
                   (temp$`County Name` == "Wake" & temp$`State Name` == "North Carolina") |
                   (temp$`State Name` == "Illinois" & temp$`County Name` == "Dekalb") |
                   (temp$`State Name` == "Alabama" & temp$`County Name` == "Jefferson") )
  
  new_name = paste("12counties_hourly_data/", toString(name), sep="")
  
  save(temp, file = new_name)
}