#hourlyYearsInput.R

library(shiny)
library(ggplot2)

source('dataModel.R')


graphHourlyInput <- function(id, state_list, county_list) {

  nameSpace <- NS(id)
  
  state_list = c("Illinois", "Hawaii", "New York", "California",
                 "Washington", "Texas", "Florida", "New Mexico",
                 "Minnesota", "North Carolina", "Alabama")
  
  fluidRow(fluidRow(column(6, plotOutput(
    nameSpace("AQIHourlyPlot"),
    height = 500
  )
  )
  ),
  
  fluidRow(
    
    
    box(
      h2("Graph Hours Input"),
      width = 4,
      selectInput(nameSpace("state"), "Select a state", state_list, selected = "Illinois"),
      selectInput(nameSpace("county"), "Select a county", county_list, selected = "Cook"),
      
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
  
  date_list <- unique(as.vector(hourlyData$`Date GMT`))
  full_data_list <- seq(as.Date("2018-01-01"), as.Date("2018-12-31"), "days")
  no_data_days <- full_data_list[! full_data_list %in% date_list]
  print(no_data_days)
  
  countyReactive <- reactive(input$county)
  dataSelectedReactive <- reactive(input$data_selected)
  
  allHourlyDataForDayReactive <- reactive({
    print(input$state)
    print(countyReactive())
    print(input$date)
    
    subset(
      hourlyData,
      hourlyData$`State Name` == input$state &
        hourlyData$`County Name` == input$county &
        hourlyData$`Date GMT` == toString(input$date)
    )
  })
  
  # ------------------ UI stuff ----------------------------
  
  observeEvent(input$state, {
    
    state_selected <- reactive(input$state)
    state_selected <- state_selected()
    
    county_list <- unique(as.vector( subset(hourlyData$`County Name`, hourlyData$`State Name` == state_selected) ))
    
    updateSelectInput(session, "county", choices = county_list, selected = input$county)
    
    # updateDateInput(session, "date", value = "2018-01-01", dats , datesdisabled = no_data_days)
    
  })
  
  # output$county <- renderUI({
  #   
  #   county_list <-
  #     unique(as.vector(subset(hourlyData$`County Name`, hourlyData$`State Name` == input$state)))
  #   print(county_list)
  #   selectInput(nameSpace("county"), "Select a county: ", county_list, selected = county_list[0])
  # })
  
  # --------------------------------------------------------
  
  output$AQIHourlyPlot <- renderPlot({
    oneDayData <- allHourlyDataForDayReactive()
    print(oneDayData)
    
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