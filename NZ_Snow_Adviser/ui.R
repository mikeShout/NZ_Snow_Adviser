library(shiny)
library(leaflet)
library(dplyr)

# UI will consist of three rows...

shinyUI(fluidPage(

  titlePanel("NZ Snow Adviser"),
  h3("The likely snow conditions for New Zealand Ski Fields"),
  br(),
  
    #Top row, two cols
  fluidRow(
    column(4,
           "Details of Visit",
           hr(),
           selectInput("airport", "Nearest AIrport", list("Any", "Auckland", "Christchurch", "Queenstown"), selected ="", multiple = FALSE, selectize = TRUE),
           selectInput("monthV", "Month Visiting", list("Jun", "Jul", "Aug", "Sep", "Oct"), multiple = FALSE, selectize = TRUE),
           sliderInput("sRating",
                       "Ski Field Difficulty (0 = easy to 100 = difficult)",
                       min = min(skiData$SkiFieldRating),
                       max = max(skiData$SkiFieldRating),
                       value = range(skiData$SkiFieldRating),
                       step = 10),
           br()
    ),
    column(8,
           "Predicted Conditions",
           hr(),
           h4(textOutput("monthP")),
           br(),
           h4(tags$li(textOutput("snowP"))),
           h4(tags$li(textOutput("baseP"))),
           br(),
           h5("*with 95% confidence")
    )
  ),
  
  fluidRow(
    column(12,
           "Map of Selected Ski Resorts",
           hr(),
           leafletOutput("skiMap"),
           h5("Click on the marker to see the names of the ski resort"),
           br()
    )
  ),

  #The row to show the table of ski resorts...
  fluidRow(
    column(12,
           "Table of Selected Ski Resorts",
           hr(),
           dataTableOutput("skiTable"),
           br()
    )
  ),
  
  #The row to show the ABout...
  fluidRow(
    column(3,
           "About This App",
           hr(),
           img(src="http://instagram.fsyd4-1.fna.fbcdn.net/t51.2885-15/e35/20066004_1368584033190241_5023317668350918656_n.jpg", width="100%", heght="100%")
           
           
    ),
    
    column(9,
           "",
           br(),
           hr(),
           p("This app was created to fulfil an assignment for the Data Products class that is part of the Data Science Specialization offered by", a("John Hopkins University on Coursera", href="http://www.coursera.org/specializations/jhu-data-science/"), "."),
           p("The purpose of the app is to predict snow-fall and base (the height of snow comprising the base of a ski field) for ski fields in New Zealand. The predictions are based on which ski field you may visit and during which time of year."),
           p("The drop-downs and sliders are reactive variables that filter the prediction to ski field(s) of interest and which month of the (Southern Hemisphere) winter to consider. The features include:"),
           tags$li("Location - based on nearby airport"),
           tags$li("Difficulty - based on percent of runs that are rated green, blue, and black"),
           tags$li("Month"),
           p("The prediction is the result of two regression models assessing:"),
           tags$li("Elevation"),
           tags$li("Latitude"),
           tags$li("Month")           
           
    )
  )
  
  
    
))


#<a href="https://www.instagram.com/p/BWpD1HVDWXp/" 
