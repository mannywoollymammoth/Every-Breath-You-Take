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
  pollutant_list <- c("ozone", "SO2", "CO", "NO2", "PM2.5", "PM10")
  
  
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
      selectInput("Year", "Select a year: ", year_list, selected = "2018"),
      selectInput("AQI", "Select a aqi", aqi_list, selected = "Good.Days"),
      selectInput("Pollutant", "Select a pollutant", pollutant_list, selected = "ozone")
    )
    
  )))
  
  
  
  # absolutePanel(id = "controls", width = 330, height = "auto", bottom = 60,
  #
  #               h2("Map Years Input"),
  #               selectInput("Year", "Select a year: ", year_list, selected = "2018"),
  #               selectInput("AQI", "Select a aqi", aqi_list, selected = "Good.Days"),
  #               selectInput("Pollutant", "Select a pollutant", pollutant_list, selected = "ozone")
  #
  # )
  
  
  
}


mapYears <- function(input, output, session, dailyData) {
  #Use of the following links for the map stuff
  #https://rstudio.github.io/leaflet/choropleths.html
  #https://franciscorequena.com/blog/how-to-make-an-interactive-map-of-usa-with-r-and-leaflet/
  
  output$leaf <- renderLeaflet({
    us.map.county <-
      readOGR(dsn = './cb_2017_us_county_20m',
              layer = "cb_2017_us_county_20m",
              stringsAsFactors = FALSE)
    leafmap <- us.map.county
    bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
    pal <- colorBin("YlOrRd", domain = c(0:4000), bins = bins)
    
    
    map <- leaflet(data = leafmap) %>%
      addTiles() %>%
      setView(-96, 37.8, 4) %>%
      addPolygons(fillOpacity = 0.8,
                  color = "#BDBDC3",
                  weight = 1)
    
    map
  })
}
