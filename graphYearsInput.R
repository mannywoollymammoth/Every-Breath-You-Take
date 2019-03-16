library(shiny)
library(ggplot2)


source('dataModel.R')

#---------------------
library(plyr)





graphYearsInput <- function(id, year_list, state_list, county_list) {
  print("year list")
  print(year_list)
  
  nameSpace <- NS(id)
  
  fluidRow(fluidRow(column(6,
                           box(
                             title = "Air Quality",
                             solidHeader = TRUE,
                             status = "primary",
                             width = 12,
                             plotOutput(nameSpace("AQIPlot"))
                           )),
                    
                    column(
                      6,
                      box(
                        title = "Air Quality",
                        solidHeader = TRUE,
                        status = "primary",
                        width = 12,
                        plotOutput(nameSpace("AQIBar"))
                      )
                    )),
           
           fluidRow(
             
             box(
               h2("Graph Years Input"),
               selectInput(nameSpace("year"), "Select a year: ", year_list),
               selectInput(nameSpace("state"), "Select a state", state_list, selected = "Illinois"),
               selectInput(
                 nameSpace("county"),
                 "Select a county",
                 county_list,
                 selected = "Cook"
               )
             )))
  
  
  
  
}

#server logic
graphYears <- function(input, output, session, dailyData) {
  yearSelected <- reactive(input$year)
  stateSelected <- reactive(input$state)
  countySelected <- reactive(input$county)
  
  
  output$AQIPlot <- renderPlot({
    justOneState <- stateSelected()
    justOneCounty <- countySelected()
    justOneYear <- yearSelected()
    
    yearlyData <-
      AQIDataFrom1990to2018(justOneState, justOneCounty, justOneYear, dailyData)
    yearlyData <- addAQIColor(yearlyData)
    
    ggplot(yearlyData, aes(x = yearlyData$index, y = yearlyData$AQI)) + geom_point(color =
                                                                                     yearlyData$Color) +  labs(title = "AQI Data", x = "Day", y = "AQI") +
      coord_cartesian(ylim = c(0, 500)) + geom_line()
  })
  
  
  output$AQIBar <- renderPlot({
    justOneYear <- yearSelected()
    justOneState <- stateSelected()
    justOneCounty <- countySelected()
    
    group = c("CO2",
              "NO2",
              "Ozone",
              "SO2",
              "PM2.5",
              "PM10")
    
    daily_data <-
      AQIDataFrom1990to2018(justOneState, justOneCounty, justOneYear, dailyData)
    AQICounts <- count(daily_data, c("Month", "Category"))
  
    
    ggplot(AQICounts, aes(fill=AQICounts$Category, y=AQICounts$freq, x=AQICounts$Month)) + 
      geom_bar( stat="identity")
    
    
  })
  
  
  #updates the County list when a new state is selected
  observeEvent(input$state, {
    print("In the observer")
    stateSelected <- reactive(input$state)
    stateSelected <- stateSelected()
    print("state selected")
    print(stateSelected)
    parseByState <- subset(dailyData, dailyData$`State Name` == stateSelected)
    print("parse by state")
    print(parseByState)
    parseByCounties <- unique(parseByState$`county Name`)
    
    
    if (is.null(stateSelected))
      stateSelected <- character(0)
    
    
    
    print(input)
    updateSelectInput(session,
                      "county",
                      choices = parseByCounties,
                      selected = input$county
                      
    )
  }, priority = 2)
  
  
  
}
