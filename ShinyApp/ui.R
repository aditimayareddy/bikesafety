
library(shiny)

# Define UI for application 
shinyUI(fluidPage(
    # Application title
    titlePanel("BikeAware : Bike Safety in DC"),
    # Sidebar with a date input
    sidebarLayout(
        sidebarPanel(
            h5("#TODO - fill in introduction information here"),
            selectInput("year",
                        "Select a year:",
                        choices = unique(crash$year)
          )
        ),

        # Show three plots - injuries, safety requests, graph
        mainPanel(
          tabsetPanel(
            tabPanel("Incidents", leafletOutput("inci")),
            tabPanel("Safety Requests", leafletOutput("safreq")),
            #tabPanel("Graph", plotOutput("other"))
          )
        )
    )
))
