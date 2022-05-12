##BIKESAFETY PROJECT

library(shiny)
crash <- read.csv(file = "./data/crashes_clean.csv")
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Bike Injury Traffic Incidents"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput(inputId = "year",
                     label = "Year",
                     choices = unique(crash$year)),
      selectizeInput(inputId = "month",
                     label = "Month",
                     choices = unique(crash$month))
    ),
    mainPanel(plotOutput("count"))
  )
)
)