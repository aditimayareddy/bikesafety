##BIKESAFETY PROJECT


library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$count <- renderPlot(
    crash %>%
      filter(year == input$year & month == input$month) %>%
      group_by(inj) %>%
      count() %>%
      ggplot(aes(x = inj, y = n)) +
      geom_col(fill = "lightblue") +
      ggtitle("Number of Incidents")
  )
} 
)