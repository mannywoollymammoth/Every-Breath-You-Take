library(shiny)
library(ggplot2)


source('dataModel.R')


graphYearsInput <- function(id, year_list, state_list, county_list){
  
  print("year list")
  print(year_list)
  
  nameSpace <- NS(id)
  
  fluidRow(
    fluidRow(
      column(6,plotOutput(nameSpace("plot1")))
    ),
    
    fluidRow(
      # absolutePanel(id = "controls", width = 330, height = "auto", bottom = 60,
      #               temp_list <- c("California", "Florida", "Illinois"),
      #               h2("Graph Years Input"),
      #               selectInput(nameSpace("year"), "Select a year: ", year_list, selected = "2018"),
      #               selectInput(nameSpace("states"), "Select a state", temp_list, selected = "illinois")
      #               #selectInput("counties")
      # )
      
      box(
          h2("Graph Years Input"),
          selectInput(nameSpace("year"), "Select a year: ", year_list),
          selectInput(nameSpace("state"), "Select a state", state_list, selected = "Illinois"),
          selectInput(nameSpace("county"), "Select a county", county_list, selected = "Cook")
      )
      
    )
    
    
  )
  
  

  
}

#server logic
graphYears <- function(input, output, session, allData){
  yearSelected <- reactive(input$year)
  stateSelected <- reactive(input$state)
  countySelected <- reactive(input$county)
  

  output$plot1 <- renderPlot({
    justOneState <- stateSelected()
    justOneCounty <- countySelected()
    justOneYear <- yearSelected()
    
    yearlyData <- AQIDataFrom1990to2018(justOneState, justOneCounty,justOneYear, allData)
    yearlyData$index <- seq.int(nrow(yearlyData))
    
    
    print("yearly Data")
    print(nrow(yearlyData))
    
    # ggplot(yearlyData, aes(x = yearlyData$index   )) + labs(title = "AQI Data", x = "Day", y = "Number of Days") +
    #    coord_cartesian(ylim = c(0, 500)) + geom_line(aes(y = yearlyData$AQI, colour = "Median"))


    ggplot(yearlyData, aes(x = yearlyData$index, y = yearlyData$AQI )) + geom_point(color="blue") +  labs(title = "AQI Data", x = "Day", y = "Number of Days") +
      coord_cartesian(ylim = c(0, 500)) + geom_line()
  })
  
  
 
}



