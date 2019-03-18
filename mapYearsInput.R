library(rgdal)
library(leaflet)

source("dataModel.R")


mapYearsInput <- function(id, year_list, state_list) {
  nameSpace <- NS(id)
  aqi_list <-
    c(
      "Good.Days",
      "Moderate.Days",
      "Unhealthy.for.Sensitive.Groups.Days",
      "Unhealthy.Days",
      "Very.Unhealthy.Days",
      "Hazardous.Days"
    )
  pollutant_list <- c("AQI","Ozone", "SO2", "CO", "NO2", "PM2.5", "PM10")
  
  
  #added
  fluidRow(fluidRow(column(
    12,
    box(
      title = "Leaflet Map",
      solidHeader = TRUE,
      status = "primary",
      width = NULL,
      leafletOutput(nameSpace("leaf"))
    )
  )),
  
  fluidRow(column(
    4,
    box(
      title = "Leaflet Map Parameters",
      solidHeader = TRUE,
      status = "primary",
      width = NULL,
      selectInput(nameSpace("Year"), "Select a year: ", year_list, selected = "2018"),
      selectInput(nameSpace("Pollutant"), "Select a pollutant", pollutant_list, selected = "AQI"),
      sliderInput(nameSpace("countySlider"), label = h3("Slider"), min = 0, max = 1000, value = 100)
    )
    
  )))
  
  
}


mapYears <- function(input, output, session) {
  #Use of the following links for the map stuff
  #https://rstudio.github.io/leaflet/choropleths.html
  #https://franciscorequena.com/blog/how-to-make-an-interactive-map-of-usa-with-r-and-leaflet/
  
  #dailyData <- readDailyData()
  
  #we had to use this snippet of code to convert our r data files
  #https://stackoverflow.com/questions/5577221/how-can-i-load-an-object-into-a-variable-name-that-i-specify-from-an-r-data-file
  loadRData <- function(fileName){
    #loads an RData file, and returns it
    load(fileName)
    get(ls()[ls() != "fileName"])
  }
  
  yearSelected <- reactive(input$Year)
  sliderSelected <- reactive(input$countySlider)
  pollutantSelected <- reactive(input$Pollutant)
  
  
  output$leaf <- renderLeaflet({
    justOneYear <- yearSelected()
    justManyCounties <- sliderSelected()
    justOnePollutant <- pollutantSelected()
    
    
    fileName = paste("daily_data/daily_aqi_by_county_",toString(justOneYear), ".Rdata",  sep="")
    print(fileName)
    dailyData <- loadRData(file= fileName)
    dailyData <- separate(dailyData, Date, c("Year", "Month", "Day"), sep = "-", remove = FALSE)
    print(dailyData)
    
    if(justOnePollutant == "AQI"){
      topCounties <- getCountiesfromAQI(dailyData, justManyCounties)
    }
    else{
      topCounties <- getCountiesfromPollutants(dailyData, justManyCounties, justOnePollutant)
    }
    
    
    us.map.county <-
      readOGR(dsn = './cb_2017_us_county_20m',
              layer = "cb_2017_us_county_20m",
              stringsAsFactors = FALSE)
    
    leafmap <- merge(us.map.county, topCounties, by= 'GEOID' )
    bins <- c(0,50, 60, 70, 80, 90, 130, 250, Inf)
    pal <- colorBin("YlOrRd", domain = topCounties$AQI, bins = bins)
   
    #pal <- colorQuantile("YlOrRd", domain = topCounties$AQI, n = 20)
    #pal <- colorNumeric("YlOrRd", c(0,350), na.color = NA)
     
    map <- leaflet(data = leafmap) %>%
      addTiles() %>%
      setView(lng = -87.6298, lat = 41.8781, 4) %>%
      addPolygons(fillOpacity = 0.8,
                  fillColor = ~pal(AQI),
                  color = "#BDBDC3",
                  weight = 1)
    
    map
  })
  
  
  getCountiesfromAQI <- function(daily_data, justManyCounties) {
    
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
  
  getCountiesfromPollutants <- function(daily_data, justManyCounties, justOnePollutant) {
    
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
  
}
