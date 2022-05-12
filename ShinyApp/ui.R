
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
                        choices = unique(crash$year),
                        multiple = TRUE
          ),
          
          selectInput("inj",
                      "Select an incident type:",
                      choices = c("Minor Injury" = "minor_injury",
                                  "Major Injury" = "major_injury",
                                  "Fatality" = "fatality",
                                  "No Injury" = "no_injury")
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
