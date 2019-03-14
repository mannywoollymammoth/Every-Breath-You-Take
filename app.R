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



allData <- readData()
year_list <- unique(as.vector(allData$Year))
state_list <- unique(as.vector(allData$`State Name`))
county_list <- unique(as.vector(allData$`county Name`))

#have two variables one for hourly read data and one for the yearly read




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
    
    
    menuItem("Graphs", tabName = "Graphs", icon = icon("dashboard"), 
             menuSubItem("Years", tabName = "graphsYears"),
             menuSubItem("Hourly", tabName = "graphsHourly")
             ),
    menuItem("Map", icon = icon("th"), tabName = "Map",
             menuSubItem("Years", tabName = "mapYears"),
             menuSubItem("Hourly", tabName = "mapHourly")
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
              mapYearsInput(year_list, state_list)
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
  
  gy <- callModule(graphYears, "graphyears", allData)
  gh <- callModule(graphHourly, "graphhourly", allData)
  
  
    # oneYearCountyReactive <-
    # reactive({
    #   subset(
    #     allData,
    #     allData$Year == input$year &
    #       allData$County == input$county &
    #       allData$State == input$state
    #   )
    # })
  # oneCountyReactive <-
  #   reactive({
  #     subset(allData,
  #            allData$State == input$state &
  #              allData$County == input$county)
  #   })
  
  # ------------------------ UI STUFF
  # 
  # output$states <- renderUI({
  #   state_list <-
  #     unique(as.vector(allData$State))
  #   selectInput("state", "Select a state: ", state_list, selected = "Illinois")
  # })
  # 
  # output$counties <- renderUI({
  #   county_list <-
  #     as.vector(subset(allData$County, allData$State == input$state))
  #   selectInput("county", "Select a county: ", county_list, selected = county_list[0])
  # })
  # 
  
  
    
}

shinyApp(ui = ui, server = server)