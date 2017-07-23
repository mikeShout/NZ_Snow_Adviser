# NZ Snow Adviser

#### An RStudio Shiny App 

Visit the [shiny app here](https://mikeshout.shinyapps.io/nz_snow_adviser/)

This app was created to fulfil an assignment for the Data Products class that is part of the Data Science Specialization offered by John Hopkins University on Coursera.

The purpose of the app is to predict snow-fall and base (the height of snow comprising the base of a ski field) for ski fields in New Zealand. The predictions are based on which ski field you may visit and during which time of year.

The drop-downs and sliders are reactive variables that filter the prediction to ski field(s) of interest and which month of the (Southern Hemisphere) winter to consider. The features include:

* Location - based on nearby airport
* Difficulty - based on percent of runs that are rated green, blue, and black
* Month

The prediction is the result of two regression models assessing:

* Elevation
* Latitude
* Month
