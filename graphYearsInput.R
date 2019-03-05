graphYearsInput <- function(year_list, state_list){
  
  absolutePanel(id = "controls", width = 330, height = "auto", bottom = 60,
                
                h2("Graph Years Input"),
                selectInput("year", "Select a year: ", year_list, selected = "2018"),
                selectInput("states", "Select a state", state_list, selected = "illinois")
                #selectInput("counties")
  )
  
}