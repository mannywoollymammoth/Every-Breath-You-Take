library(rgdal)
library(leaflet)

mapYearsInput <- function(year_list, state_list){
  
  aqi_list <- c("Good.Days","Moderate.Days", "Unhealthy.for.Sensitive.Groups.Days",
                "Unhealthy.Days","Very.Unhealthy.Days","Hazardous.Days")
  pollutant_list <- c("ozone", "SO2", "CO", "NO2", "PM2.5", "PM10")
  
  
  #Use of the following links for the map stuff
  #https://rstudio.github.io/leaflet/choropleths.html
  #https://franciscorequena.com/blog/how-to-make-an-interactive-map-of-usa-with-r-and-leaflet/
  us.map.county <- readOGR(dsn= './cb_2017_us_county_20m', layer = "cb_2017_us_county_20m", stringsAsFactors = FALSE)
  leafmap <- us.map.county
  
  
  # map <- leaflet(data = leafmap )  %>% addTiles() %>%
  #  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)
  #   
  # map
  #code from R website
  
  bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
  pal <- colorBin("YlOrRd", domain = c(0:4000), bins = bins)
  
  
  # m <- leaflet(data = leafmap) %>%
  #   setView(-96, 37.8, 4) %>%
  #   addProviderTiles("MapBox", options = providerTileOptions(
  #     id = "mapbox.light",
  #     accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
  # m %>% addPolygons()
  # m
  
  
  leaflet(data = leafmap) %>% 
    addTiles() %>%
    setView(-96, 37.8, 4) %>%
    addPolygons(
                fillOpacity = 0.8,
                color = "#BDBDC3",
                weight = 1
                )
 
  
  # absolutePanel(id = "controls", width = 330, height = "auto", bottom = 60,
  #               
  #               h2("Map Years Input"),
  #               selectInput("Year", "Select a year: ", year_list, selected = "2018"),
  #               selectInput("AQI", "Select a aqi", aqi_list, selected = "Good.Days"),
  #               selectInput("Pollutant", "Select a pollutant", pollutant_list, selected = "ozone")
  #               
  # )
  
  
  
}