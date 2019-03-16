#hourlyYearsInput.R

library(shiny)
library(ggplot2)

source('dataModel.R')


graphHourlyInput <- function(id, state_list, county_list) {
  hour_list <- c(0:23)
  pollutant_list <-
    c(
      "Carbon monoxide",
      "Sulfur dioxide",
      "Nitrogen dioxide (NO2)",
      "Ozone",
      "PM10 Total 0-10um STP",
      "PM2.5 - Local Conditions",
      "Outdoor Temperature",
      "Wind Speed - Resultant"
    )
  
  nameSpace <- NS(id)
  
  fluidRow(fluidRow(column(6, plotOutput(
    nameSpace("AQIHourlyPlot")
  ))),
  
  fluidRow(
    box(
      h2("Graph Hours Input"),
      selectInput(nameSpace("state"), "Select a state", state_list, selected = "Illinois"),
      selectInput(
        nameSpace("county"),
        "Select a county",
        county_list,
        selected = "Cook"
      ),
      dateInput(nameSpace("date"), "Date input", value = "2018-01-01"),
      selectInput(
        nameSpace("pollutant"),
        "Select a pollutant",
        pollutant_list,
        selected = "Ozone"
      ),
      selectInput(
        nameSpace("startTime"),
        "Select a start time",
        hour_list,
        selected = 0
      ),
      selectInput(
        nameSpace("stopTime"),
        "Select a stop time",
        hour_list,
        selected = 0
      )
    )
    
  ))
  
}

#server logic
graphHourly <- function(input, output, session, hourlyData) {
  stateSelected <- reactive(input$state)
  countySelected <- reactive(input$county)
  dateSelected <- reactive(input$date)
  
  allHourlyDataForDayReactive <- reactive({
    subset(
      hourlyData,
      hourlyData$`State Name` == input$state &
      hourlyData$`County Name` == input$county &
      hourlyData$`Date GMT` == toString(input$date)
    )
  })
  
  # --------------------------------------------------------
  
  output$AQIHourlyPlot <- renderPlot({
    oneDayData <- allHourlyDataForDayReactive()
    print("this is all the data: ")
    print(oneDayData)
    
    # TODO: ACTUALLY GRAPH THIS
    
    #temp graph
    df <- data.frame(dose = c("D0.5", "D1", "D2"),
                     len = c(4.2, 10, 29.5))
    
    ggplot(data = df, aes(x = dose, y = len, group = 1)) +
      geom_line() +
      geom_point()
    
    #need to change from yearly data to hourly data so that stuff can get output
    #Fatima needs to do thiss
    #yearlyData <- AQIDataFrom1990to2018(justOneState, justOneCounty,justOneYear, dailyData)
    #yearlyData$index <- seq.int(nrow(yearlyData))
    
    
    # ggplot(yearlyData, aes(x = yearlyData$index   )) + labs(title = "AQI Data", x = "Day", y = "Number of Days") +
    #    coord_cartesian(ylim = c(0, 500)) + geom_line(aes(y = yearlyData$AQI, colour = "Median"))
    
    
    #ggplot(yearlyData, aes(x = yearlyData$index, y = yearlyData$AQI )) + geom_point(color="blue") +  labs(title = "AQI Data", x = "Day", y = "Number of Days") +
    #  coord_cartesian(ylim = c(0, 500)) + geom_line()
  })
}