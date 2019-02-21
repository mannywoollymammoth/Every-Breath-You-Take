library("stringr")
library("readr")
nameList <- list.files(pattern = "*.csv")

counter <- 0
years <- c(1990:2018)
for (name in nameList){
  counter
  print("reading file")
  temp <- read_csv(name)
  name <- str_remove(name, ".csv")
  newFileName <- paste(name, ".Rdata",sep = "")
  print(newFileName)
  print("saving it")
  save(temp, file = newFileName)
  
}

