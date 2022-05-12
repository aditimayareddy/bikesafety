#loading packages
library(lubridate)
library(ggplot2)
#library(ggmap)
library(ggthemes)
library(dplyr)
library(data.table)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(leaflet)
library(sf) #spatial data package to read ward shapefiles
library(tigris) #geojoin for ward shapefiles
library(htmlwidgets) #interactive map labels

##LOADING DATA
#loading raw data sets
bike_reqs <- read.csv("./data/Vision_Zero_Safety_Bikers.csv", stringsAsFactors = FALSE) #Safety requests shared by bikers
cp_reqs <- read.csv("./data/Vision_Zero_Safety_Cars_Pedestrians.csv", stringsAsFactors = FALSE) #Safety requests shared by pedestrians and drivers
crash <- read.csv("./data/Crashes_in_DC.csv", stringsAsFactors = FALSE) #all crashes between April 1, 2012 to April 2022

#loading shapefiles for wards
wards <- st_read("./data/wards/Wards_from_2022.shp")


##Modifying Raw Data
wards <- wards %>% select(ward=WARD,
                        name=NAME
)

#concatenating safety requests data sets
reqs <- rbind(bike_reqs, cp_reqs)

#cleaning requests data set
#selecting relevant columns
reqs <- reqs %>% select(lat=Y,
                              lon=X,
                              usertype=USERTYPE,
                              rdate=REQUESTDATE,
                              reqtype=REQUESTTYPE,
                              comments=COMMENTS,
)


#formatting date
#formatting date information, adding year and month columns
reqs$rdate <-ymd_hms(reqs$rdate)
reqs$year <-year(reqs$rdate)
reqs$month <-month(reqs$rdate)
reqs$month <-hour(reqs$rdate)

#exporting clean requests data to CSV
write.csv(reqs,"./data/bike_reqs_clean.csv", row.names = FALSE)

#cleaning crash data set
#selecting relevant columns
crash <- crash %>% select(lat=LATITUDE,
                            lon=LONGITUDE,
                            ward=WARD,
                            rdate=REPORTDATE,
                            major_injury=MAJORINJURIES_BICYCLIST,
                            minor_injury=MINORINJURIES_BICYCLIST,
                            unknown_injury=UNKNOWNINJURIES_BICYCLIST,
                            fatality=FATAL_BICYCLIST,
                            total_b=TOTAL_BICYCLES,
                            total_v=TOTAL_VEHICLES,
                            imp_b=BICYCLISTSIMPAIRED,
                            imp_d=DRIVERSIMPAIRED,
                            speeding=SPEEDING_INVOLVED)
#formatting date information, adding year, month, day, hour columns
crash$rdate <-ymd_hms(crash$rdate)
crash$year <-year(crash$rdate)
crash$month <-month(crash$rdate)
crash$hour <-hour(crash$rdate)
crash$day <-day(crash$rdate)

crash.year <- ordered(crash, levels = c(2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022))
is.factor(crash.year)

#filtering for incidents from 2011 onwards, that involved at least one bicycle
crash <- crash %>% filter(year %in% c(2012:2022) & total_b > 0)

#adding categorical variable for injury/fatality
crash$no_injury <- 0.5
col_vec <- c(5,6,7,8,18)

crash$injtype <- names(crash[col_vec])[max.col(crash[col_vec])]

crash.injtype <- ordered(crash, levels = c("fatality", "major_injury", "minor_injury", "unknown_injury", "no_injury"))
is.factor(crash.injtype)

#removing dummy variable columns
#crash <- select(crash, -rdate, -minor_injury, -major_injury, -unknown_injury, -no_injury, -fatality)

#exporting clean crash data to csv
write.csv(crash,"./data/crashes_clean.csv", row.names = FALSE)


m <- leaflet(data = reqs) %>% setView(lng = -77.0369, lat = 38.9072, zoom = 12)
m %>% addTiles() %>%
  addMarkers(~lon, ~lat, popup = ~as.character(comments), label = ~as.character(reqtype),
             clusterOptions = markerClusterOptions(freezeAtZoom = 12))

# Show first 20 rows from the `reqs
leaflet(data = reqs[1:20,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(comments), label = ~as.character(reqtype))

getColor <- function(crash) {
  sapply(crash$injtype, function(injtype) {
    if(injtype == "no_injury") {
      "green"
    } else if(injtype == "minor_injury") {
      "yellow"
    } else if(injtype = "major_injury") {
      "orange"
    } else if(injtype = "major_injury") {
      "red"
    } else if(injtype = "unknown_injury") {
      "tan"
    }
    } )
}

getColor <- function(crash) {
  sapply(crash$injtype, function(injtype) {
    if(injtype == no_injury) {
      "green"
    } else if(injtype == minor_injury | injtype == major_injury | injtype == unknown_injury) {
      "orange"
    } else if(injtype == fatality){
      "red"
    } })
}

icons <- awesomeIcons(
  icon = 'bicycle_outline',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(crash)
)

r <- leaflet(data = crash) %>% setView(lng = -77.0369, lat = 38.9072, zoom = 12)
r %>% addTiles() %>%
  addAwesomeMarkers(~lon, ~lat, icon = icons, popup = ~as.character(rdate), label = ~as.character(injtype),
             clusterOptions = markerClusterOptions())


getColor <- function(crash) {
  sapply(crash$injtype, function(injtype) {
    if(injtype == "no_injury") {
      "green"
    } else if(injtype == "minor_injury" | injtype == "unknown_injury") {
      "yellow"
    } else if(injtype == "major_injury") {
      'Orange'
    } else if(injtype == "fatality"){
      "red"
    } })
}

