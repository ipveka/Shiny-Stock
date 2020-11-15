
##### User Interface

# Encoding: UTF-8

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

### Title:

header <- dashboardHeader(title = "ShinyStock")

### SideBar:

sidebar <- dashboardSidebar(width = 230,
                            
                            sidebarMenu(
                              menuItem("Home", tabName = "home", icon = icon("fas fa-home")),
                              menuItem("Data", tabName = "data",  icon = icon("fas fa-server")),
                              menuItem("Graphics", tabName = "graphics", icon = icon("far fa-chart-bar")),
                              
                              hr(),
                              
                              menuItem("About", tabName = "about", icon = icon("fas fa-user")),
                              
                              hr(),
                              
                              helpText("Developed by ", 
                                       a("Ignasi Pascual", href = "https://github.com/ipveka"),
                                       align = "center")
                            )
)

### Dashboard:
body <- dashboardBody(
  
  # CSS 
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  
  # Tabintes:
  tabItems(
    
    ### TAB 0 = Home:
    tabItem(tabName = "home",
            fluidPage(
              box(width = 12,
                  shiny::includeMarkdown("Home.md")))
            
    ),
    
    ### TAB 1 = Data:
    tabItem(tabName = "data",
            fluidRow(
              column(width = 4,
                     box(width = 12,
                         helpText("Select a stock to examine. Information will be collected from Yahoo Finance."),
                         textInput("symb", "Symbol", "GOOG"),
                         hr(),
                         useShinyalert(),
                         actionButton("get", "Get Stock")
                     )
              ),
              column(width = 7,
                     box(width = 12,
                         title = "Table of content",
                         withSpinner(DT::dataTableOutput("table",width = 700)))
              ))
    ),
    
    ### TAB 2 = Graphics:
    tabItem(tabName = "graphics",
            fluidRow(
              column(width = 4,
                     box(width = 12,
                         helpText("Select plot options."),
                         selectInput("type", label = "Type", width = "100%",
                                     choices = c("line", "column", "bar", "spline")), 
                         selectInput("stacked", label = "Stacked",  width = "100%",
                                     choices = c(FALSE, "normal", "percent")),
                         selectInput("theme", label = "Theme",  width = "100%",
                                     choices = c(FALSE, "fivethirtyeight", "economist",
                                                 "darkunica", "gridlight", "sandsignika",
                                                 "null", "handdrwran", "chalk")),
                         hr(),
                         useShinyalert(),
                         actionButton("plot", "Plot")
                     )
              ),
              column(width = 7,
                     box(width = 12,
                         title = "Graphics",
                         withSpinner(highchartOutput("chart",height = "650px"))))
            )
    ),
    
    ### TAB 3 = About
    tabItem(tabName = "about",
            fluidPage(
              box(width = 12,
                  shiny::includeMarkdown("README.md"))
            )
    )
  )
)

# Styles

ui <- dashboardPage(header, sidebar, body)

#---
