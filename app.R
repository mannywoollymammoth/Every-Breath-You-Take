# CS 424 - Project 2
# Fatima Qarni & Manny Martinez

#libraries to include

library(shiny)
library(shinydashboard)
library(ggplot2)
library(lubridate)
library(DT)
library(jpeg)
library(grid)
library(leaflet)
library(scales)

source('graphYearsInput.R')
source('mapYearsInput.R')
source('graphHourlyInput.R')
source('dataModel.R')



#this data gets passed to the graphYears input so that we can dynamically update the list of counties
#when a new state is selected
daily <- load(file = "daily_data/daily_aqi_by_county_1990.Rdata")
NameListData <- get(daily[ls() != "fileName"])


year_list <- c(1990:2018)
state_list <- unique(as.vector(NameListData$`State Name`))
county_list <- unique(as.vector(NameListData$`county Name`))

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "CS 424 - Project 2 - Fatima Qarni & Manny Martinez",
                  
                  tags$li(
                    actionLink("openInfo", label = " Project Info", icon = icon("info")),
                    class = "dropdown"
                  )),
  
  dashboardSidebar(
    disable = FALSE,
    collapsed = FALSE,
    
    sidebarMenu(
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      menuItem("GraphsYears", tabName = "graphsYears"),
      menuItem("GraphsHourly", tabName = "graphsHourly"),
      menuItem("Map", icon = icon("th"), tabName = "mapYears")
    )
    
    
    
    
  ),
  
  
  dynamicBody <- dashboardBody(
    tabItems(
      tabItem(tabName = "graphsYears",
              graphYearsInput("graphyears", year_list, state_list, county_list)
      ),
      tabItem(tabName = "graphsHourly",
              graphHourlyInput("graphhourly", state_list, county_list)
      ),
      tabItem(tabName = "mapYears",
              #mapYearsInput(year_list, state_list)
              mapYearsInput("mapyears",year_list, state_list)
      )
    )
  ),

  dashboardBody(
    #graphYearsInput(year_list)
    dynamicBody
  )
    
    
)

# Define server logic required to draw a charts ----
server <- function(input, output) { 
  
  gy <- callModule(graphYears, "graphyears", NameListData )
  gh <- callModule(graphHourly, "graphhourly")
  my <- callModule(mapYears, "mapyears")
  
}

shinyApp(ui = ui, server = server)