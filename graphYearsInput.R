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
                             plotOutput(nameSpace("AQIPlot"), height = 700)
                           )),
                    
                    column(
                      6,
                      box(
                        title = "Air Quality",
                        solidHeader = TRUE,
                        status = "primary",
                        width = 12,
                        plotOutput(nameSpace("AQIBar"), height = 700)
                      )
                    )),
           
           fluidRow(
            
            
             
             box(
               h2("Graph Years Input"),
               width = 4,
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
graphYears <- function(input, output, session, NameListData) {
  #dailyData <- readDailyData()
  yearSelected <- reactive(input$year)
  stateSelected <- reactive(input$state)
  countySelected <- reactive(input$county)
  
  output$AQIPlot <- renderPlot({
    justOneState <- stateSelected()
    justOneCounty <- countySelected()
    justOneYear <- yearSelected()
    
    fileName = paste("daily_data/daily_aqi_by_county_",toString(justOneYear), ".Rdata",  sep="")
    print(fileName)
    #dailyData <- loadRData(file= fileName)
    
    daily <- load(fileName)
    dailyData <- get(daily[ls() != "fileName"])
    
    dailyData <- separate(dailyData, Date, c("Year", "Month", "Day"), sep = "-", remove = FALSE)
    print(dailyData)
    

    
    yearlyData <-
      AQIDataForYear(justOneState, justOneCounty, dailyData)
    yearlyData <- addAQIColor(yearlyData)
    
    listOfPollutants = c("Ozone", "SO2", "CO2", "NO2", "PM2.5","PM10")
    colorVector <- brewer.pal(n=6,name = 'Set1')
    
    ggplot(yearlyData, aes(x = yearlyData$index, y = yearlyData$AQI)) + geom_point(aes(color =
                                                                                     yearlyData$Color)) +  labs(title = "AQI Data", x = "Day", y = "AQI") +
      coord_cartesian(ylim = c(0, 500)) + geom_line() + 
      scale_color_manual(labels = listOfPollutants, values = c("#E41A1C", "#377EB8","#4DAF4A","#984EA3","#FF7F00","#FFFF33"))
     
     
    
  })
  
 
  #aes(x = yearlyData$index, y = yearlyData$AQI , color = yearlyData$`Defining Parameter`)
  output$AQIBar <- renderPlot({
    justOneYear <- yearSelected()
    justOneState <- stateSelected()
    justOneCounty <- countySelected()
    
    fileName = paste("daily_data/daily_aqi_by_county_",toString(justOneYear), ".Rdata",  sep="")
    daily <- load(fileName)
    dailyData <- get(daily[ls() != "fileName"])
    dailyData <- separate(dailyData, Date, c("Year", "Month", "Day"), sep = "-", remove = FALSE)
    
    group = c("CO2",
              "NO2",
              "Ozone",
              "SO2",
              "PM2.5",
              "PM10")
    
    
    daily_data <-
      AQIDataForYear(justOneState, justOneCounty, dailyData)
    AQICounts <- count(daily_data, c("Month", "Category"))
    
    
    ggplot(AQICounts, aes(fill=AQICounts$Category, y=AQICounts$freq, x=AQICounts$Month)) + 
      geom_bar( stat="identity")
    
    
  })
  
  
  
  
 
  
  
  
  
  
  
  
  #updates the County list when a new state is selected
  observeEvent(input$state, {
   
    stateSelected <- reactive(input$state)
    stateSelected <- stateSelected()
    
   
    parseByState <- subset(NameListData, NameListData$`State Name` == stateSelected)
   
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
