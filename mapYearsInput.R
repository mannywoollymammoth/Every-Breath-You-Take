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
  
  yearSelected <- reactive(input$Year)
  sliderSelected <- reactive(input$countySlider)
  pollutantSelected <- reactive(input$Pollutant)
  output$leaf <- renderLeaflet({
    justOneYear <- yearSelected()
    justManyCounties <- sliderSelected()
    justOnePollutant <- pollutantSelected()
    
    if(justOnePollutant == "AQI"){
      topCounties <- getTopCountiesfromAQI(daily_data, justOneYear, justManyCounties)
    }
    else{
      topCounties <- getTopCountiesfromPollutants(daily_data, justOneYear, justManyCounties, justOnePollutant)
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
  
  
}
