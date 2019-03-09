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
source('dataModel.R')

# temp1 = list.files(pattern = "*.Rdata")
# temp1<- lapply(temp1, function(x) {
#   load(file = x)
#   get(ls()[ls()!= "filename"])
# })
# hourly2018 <- do.call(rbind, temp1)
# 
# temp2 = list.files(pattern = "*.csv")
# listedData2 <- lapply(temp2, read.table, sep = ',', header = TRUE)
# allData <- do.call(rbind, listedData2)

allData <- readData()



year_list <- unique(as.vector(allData$Year))
state_list <- unique(as.vector(allData$State))

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
              graphYearsInput("graphyears", year_list, state_list)
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
  
  df <- callModule(graphYears, "graphyears")
  
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