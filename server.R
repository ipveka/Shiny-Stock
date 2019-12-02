  
#---

##### Server

# Packages ----------------------------------------------------------------

library("RSQLite") # Data importing
library("shiny") # Shiny components
library("shinydashboard") # Shiny dashboard
library("shinycssloaders") # Animated CSS loader
library("shinyalert") # Shiny Alerts
library("shinytest") # For testing 
library("shinyjs") # JavaScript
library("quantmod") # Financial data
library("highcharter") # Plotting
library("markdown") # Reporting
library("DT") # Data tables

# Icons: https://fontawesome.com/icons?d=listing
# Hchart: http://jkunst.com/highcharter/index.html

server <- function(input, output) {
  
  ### Funcions i crides:
  
  #---
  
  ### Get data:
  dataInput <- reactive({
    if (input$get == 0)
      return(NULL)
    return(isolate({
      getSymbols(input$symb,src="yahoo", auto.assign = FALSE)
    }))
  })
  
  ### Show data:
  output$table <- DT::renderDataTable(
    dataInput(),
    options = list(scrollX = TRUE,pageLength = 15)
  )
  
  ### Main charts:
  output$chart <- renderHighchart({
    if (input$plot == 0)
      return(NULL)
    return(isolate({
    hc <- hchart(dataInput())
    if (input$stacked != FALSE) {
      hc <- hc %>%
        hc_plotOptions(series = list(stacking = input$stacked))
    }
    if (input$theme != FALSE) {
      theme <- switch(input$theme,
                      null = hc_theme_null(),
                      darkunica = hc_theme_darkunica(),
                      gridlight = hc_theme_gridlight(),
                      sandsignika = hc_theme_sandsignika(),
                      fivethirtyeight = hc_theme_538(),
                      economist = hc_theme_economist(),
                      chalk = hc_theme_chalk(),
                      handdrwran = hc_theme_handdrawn()
      )
      hc <- hc %>% hc_add_theme(theme)
    }
    hc
    }))
  })
  
  ### Alerts
  
  # Currently offline
  
  #observeEvent(input$get, {
  #  shinyalert("Getting data", "Hold on")
  #})
  
  #observeEvent(input$plot, {
  #  shinyalert("Plotting data", "Hold on")
  #})
  
} 


