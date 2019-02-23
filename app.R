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

hourly2018 <- load(file = "hourly_42101_2018.Rdata")

temp = list.files(pattern = "*.csv")
listedData <- lapply(temp, read.table, sep = ',', header = TRUE)
allData <- do.call(rbind, listedData)

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
    
    selectInput("year", "Select a year: ", year_list, selected = "2018"),
    uiOutput("states"),
    uiOutput("counties")
    
  ),
  
  dashboardBody()
)

# Define server logic required to draw a charts ----
server <- function(input, output) { 
  
    oneYearCountyReactive <-
    reactive({
      subset(
        allData,
        allData$Year == input$year &
          allData$County == input$county &
          allData$State == input$state
      )
    })
  oneCountyReactive <-
    reactive({
      subset(allData,
             allData$State == input$state &
               allData$County == input$county)
    })
  
  # ------------------------ UI STUFF
  
  output$states <- renderUI({
    state_list <-
      unique(as.vector(allData$State))
    selectInput("state", "Select a state: ", state_list, selected = "Illinois")
  })
  
  output$counties <- renderUI({
    county_list <-
      as.vector(subset(allData$County, allData$State == input$state))
    selectInput("county", "Select a county: ", county_list, selected = county_list[0])
  })

  
    
}

shinyApp(ui = ui, server = server)