
library(shiny)

# Define server logic
shinyServer(function(input, output) {

    year_crash <- reactive({
      yc <- crash %>% filter(year == input$year)
      return(yc)
    })
    
    year_reqs <- reactive({
      yr <- reqs %>% filter(year == input$year)
      return(yr)
    })
    
    
    #FIRST TAB - INCIDENTS MAP
    output$inci <- renderLeaflet({
      r <- leaflet(data = crash) %>% setView(lng = -77.0369, lat = 38.9072, zoom = 12)
      r %>% addTiles() %>%
        addMarkers(~lon, ~lat, popup = ~as.character(rdate), label = ~as.character(injtype),
                   clusterOptions = markerClusterOptions(freezeAtZoom = ) )
    })
    
    
    #SECOND TAB - SAFETY REQUESTS MAP
    output$safreq <- renderLeaflet({
      m <- leaflet(data = reqs) %>% setView(lng = -77.0369, lat = 38.9072, zoom = 12)
      m %>% addTiles() %>%
        addMarkers(~lon, ~lat, popup = ~as.character(comments), label = ~as.character(reqtype),
                   clusterOptions = markerClusterOptions())
    })
    
   
     #POTENTIAL THIRD TAB FOR GRAPHING
    #output$other <- renderPLot({})
                                

    })
