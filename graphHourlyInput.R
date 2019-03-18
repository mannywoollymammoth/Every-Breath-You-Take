#hourlyYearsInput.R

library(shiny)
library(ggplot2)

source('dataModel.R')


graphHourlyInput <- function(id, state_list, county_list) {

  nameSpace <- NS(id)
  
  state_list = c("Illinois", "Hawaii", "New York", "California",
                 "Washington", "Texas", "Florida", "New Mexico",
                 "Minnesota", "North Carolina", "Alabama")
  county_list = c("Cook", "Hawaii", "New York", "Los Angeles",
                  "King", "Harris", "Miami-Dade", "San Juan",
                  "Hennepin", "Wake", "Dekalb", "Jefferson")
  
  fluidRow(fluidRow(column(6, plotOutput(
    nameSpace("AQIHourlyPlot"),
    height = 1400
  )
  )
  ),
  
  fluidRow(
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
    box(
      h2("Graph Hours Input"),
      width = 4,
      selectInput(nameSpace("state"), "Select a state", state_list, selected = "Illinois"),
      selectInput(
        nameSpace("county"),
        "Select a county",
        county_list,
        selected = "Cook"
      ),   #TODO: fix the county list - needs to be reactive
      
      #TODO: fix this - needs to only choose from available days
      dateInput(nameSpace("date"), "Date input", value = "2018-01-01"),
      
      # TODO: fix this - needs to only choose from available pollutants
      checkboxGroupInput(
        nameSpace("data_selected"),
        "Data to show:",
        c("CO", "SO2", "NO2", "Ozone", "PM10", "PM2.5", "Wind", "Temp"),
        selected = TRUE
      )
    )
    
  ))
  
}

#server logic
graphHourly <- function(input, output, session) {
  hourlyData <- readHourlyData()
  #hourlyData <- c(0:100)
  
  dataSelectedReactive <- reactive(input$data_selected)
  
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
    dataSelected <- dataSelectedReactive()
    
    print(dataSelected)
    
    grouped <-
      setNames(aggregate(
        oneDayData[4],
        list(oneDayData$`Parameter Name`, (oneDayData$`Time GMT`) / 3600),
        mean
      ),
      c("Parameter Name", "Hour", "Measure"))
    
    # initially empty data frame and plot
    df <- data.frame()
    plot <-
      ggplot() + xlab(label = "Hour") + ylab(label = "Measurement") + ggtitle(label = "Meausurements over the Day")
    
    # add other data if they are in the selected list
    
    if ("CO" %in% dataSelected &&
        "Carbon monoxide" %in% grouped$`Parameter Name`) {
      plot <- plot + geom_line(aes(
        x = subset(
          grouped$Hour,
          grouped$`Parameter Name` == "Carbon monoxide"
        ),
        y = subset(
          grouped$Measure,
          grouped$`Parameter Name` == "Carbon monoxide"
        ),
        color = "CO"
      ))
    }
    if ("SO2" %in% dataSelected &&
        "Sulfur dioxide" %in% grouped$`Parameter Name`) {
      plot <- plot + geom_line(aes(
        x = subset(
          grouped$Hour,
          grouped$`Parameter Name` == "Sulfur dioxide"
        ),
        y = subset(
          grouped$Measure,
          grouped$`Parameter Name` == "Sulfur dioxide"
        ),
        color = "SO2"
      ))
    }
    if ("NO2" %in% dataSelected &&
        "Nitrogen dioxide (NO2)" %in% grouped$`Parameter Name`) {
      plot <- plot + geom_line(aes(
        x = subset(
          grouped$Hour,
          grouped$`Parameter Name` == "Nitrogen dioxide (NO2)"
        ),
        y = subset(
          grouped$Measure,
          grouped$`Parameter Name` == "Nitrogen dioxide (NO2)"
        ),
        color = "NO2"
      ))
    }
    if ("Ozone" %in% dataSelected &&
        "Ozone" %in% grouped$`Parameter Name`) {
      plot <- plot + geom_line(aes(
        x = subset(grouped$Hour, grouped$`Parameter Name` == "Ozone"),
        y = subset(grouped$Measure, grouped$`Parameter Name` == "Ozone"),
        color = "Ozone"
      ))
    }
    if ("PM10" %in% dataSelected &&
        "PM10 Total 0-10um STP" %in% grouped$`Parameter Name`) {
      plot <- plot + geom_line(aes(
        x = subset(
          grouped$Hour,
          grouped$`Parameter Name` == "PM10 Total 0-10um STP"
        ),
        y = subset(
          grouped$Measure,
          grouped$`Parameter Name` == "PM10 Total 0-10um STP"
        ),
        color = "PM10"
      ))
    }
    if ("PM2.5" %in% dataSelected &&
        "PM2.5 - Local Conditions" %in% grouped$`Parameter Name`) {
      plot <- plot + geom_line(aes(
        x = subset(
          grouped$Hour,
          grouped$`Parameter Name` == "PM2.5 - Local Conditions"
        ),
        y = subset(
          grouped$Measure,
          grouped$`Parameter Name` == "PM2.5 - Local Conditions"
        ),
        color = "PM2.5"
      ))
    }
    if ("Temp" %in% dataSelected &&
        "Outdoor Temperature" %in% grouped$`Parameter Name`) {
      plot <- plot + geom_line(aes(
        x = subset(
          grouped$Hour,
          grouped$`Parameter Name` == "Outdoor Temperature"
        ),
        y = subset(
          grouped$Measure,
          grouped$`Parameter Name` == "Outdoor Temperature"
        ),
        color = "Temp"
      ))
    }
    if ("Wind" %in% dataSelected &&
        "Wind Speed - Resultant" %in% grouped$`Parameter Name`) {
      plot <- plot + geom_line(aes(
        x = subset(
          grouped$Hour,
          grouped$`Parameter Name` == "Wind Speed - Resultant"
        ),
        y = subset(
          grouped$Measure,
          grouped$`Parameter Name` == "Wind Speed - Resultant"
        ),
        color = "Wind"
      ))
    }
    
    
    plot
    
  })
}