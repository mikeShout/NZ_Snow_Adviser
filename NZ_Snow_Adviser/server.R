# Shiny app to predict snow conditions in New Zealand ski resorts
# pairs(~ avg.SnowFall + month + SumitFT + Lat, data =skiData, pch = 21, upper.panel = NULL, lower.panel = panel.smooth)
#

library(shiny)
library(dplyr)
library(leaflet)

#Get raw data for the regression model and subset it in another cvariable for the map and table 
#setwd("C:/Users/Mike/OneDrive/MOOCs/DataProducts/NZ_Snow_Adviser/NZ_Snow_Adviser")
skiData <- read.csv("NZ_Ski_data.csv")
skiMapSubset <- summarize(group_by(skiData, Resort = Resort), elevation = first(SumitFT), PercentGreen = first(Green), PercentBlue = first(Blue), PercentBlack = first(Black), skiFieldRating = first(SkiFieldRating), Lat = first(Lat), Long = first(Long), month = first(month))

shinyServer(function(input, output) {
  
#Estblish regression models to predict average monthly snow fall and snow base from the elevation, lattitude, and month selected through UI 
snowModel <- lm(avg.SnowFall ~ Lat + SumitFT + month, data = skiData)  
baseModel <- lm(Base ~ Lat + SumitFT + month, data = skiData)
  
# Filter the skiData based on UI 
  filteredSkiFields <- reactive({
    switch(input$airport,
           "Auckland" = skiMapSubset <- filter(skiMapSubset, Lat > -40),
           "Christchurch" = skiMapSubset <- filter(skiMapSubset, Lat < -40 & Lat > -43.9),
           "Queenstown" = skiMapSubset <- filter(skiMapSubset, Lat < -43.9)   
    ) 
    skiMapSubset <- filter(skiMapSubset, skiFieldRating > input$sRating[1] & skiFieldRating < input$sRating[2] )
  })  

  #Predict snow and base values from UI
  snowPredict <- reactive({
    # collect inputs 
    latP <- mean(filteredSkiFields()$Lat)
    elevationP <- mean(filteredSkiFields()$elevation)
    monthP <- input$monthV
    
    # predict results
    predSnow <- predict(snowModel, newdata = data.frame(Lat = latP, SumitFT=elevationP, month=monthP), interval=c("confidence"))
    predSnowCI <- predSnow[3] - predSnow[1]
    paste("Snow-fall: ", round(ifelse(predSnow[1] <= 0, 0, predSnow[1]),1)," inches (+/- ", round(predSnowCI,1), " in.*)")
  })
  
  basePredict <- reactive({
    # collect inputs 
    latP <- mean(filteredSkiFields()$Lat)
    elevationP <- mean(filteredSkiFields()$elevation)
    monthP <- input$monthV
    
    # predict results
    predBase <- predict(baseModel, newdata = data.frame(Lat = latP, SumitFT=elevationP, month=monthP), interval=c("confidence"))
    predBaseCI <- predBase[3] - predBase[1]
    paste("Snow base: ", round(ifelse(predBase[1] <= 0, 0, predBase[1]),1)," inches (+/- ", round(predBaseCI,1), " in.*)")
  })
  
  output$monthP <- renderText(paste("Predictions for the month of ", input$monthV, ":"))
  output$snowP <- renderText(snowPredict())
  output$baseP <- renderText(basePredict())
  
    # display map with filtered list
    output$skiMap <- renderLeaflet({
      leaflet(filteredSkiFields()) %>% addTiles() %>% addMarkers(popup = skiMapSubset$Resort)
    })
    
    # display a table of Ski Fields with selected resorts...    
    output$skiTable <- renderDataTable(filteredSkiFields()[1:6])
  })
