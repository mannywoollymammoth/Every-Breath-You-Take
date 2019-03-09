library(shiny)
library(ggplot2)


graphYearsInput <- function(id, label = "graph Years Input", year_list, state_list){
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
      # 
      box(
          h2("Graph Years Input"),
          selectInput(nameSpace("year"), "Select a year: ", year_list, selected = "2018"),
          selectInput(nameSpace("states"), "Select a state", c("California", "Florida", "Illinois"), selected = "illinois"))
      )
    
    
    
  )
  
  

  
}

#server logic
graphYears <- function(input, output, session){
  #yearSelected <- reactive(input$year)
  #stateSelected <- reactive(input$state)
  
  output$plot1 <- renderPlot({
    df <- data.frame(dose=c("D0.5", "D1", "D2"),
                     len=c(4.2, 10, 29.5))
    
    p <- ggplot(data=df, aes(x=dose, y=len, group=1)) +
      geom_line()+
      geom_point()
    p
  })
  
  #countySelected <- reactive(input$County)
}



