#loading packages
library(lubridate)
library(ggplot2)
library(ggmap)
library(ggthemes)
library(dplyr)
library(data.table)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(maps)
library(DT)
library(leaflet)
theme_set(theme_minimal())
library(vroom) #fast data reading/importing
library(sf) #spatial data
library(tigris) #geojoin
library(htmlwidgets) #interactive map labels

#loading cleaned data sets
crash <- read.csv("./data/crashes_clean.csv", stringsAsFactors = FALSE) #cleaned crash data involving at least one bicycle between 2012-2022
reqs <- read.csv("./data/bike_reqs_clean.csv", stringsAsFactors = FALSE) #Safety requests shared by bikers

#loading shapefiles for wards
wards <- st_read("./data/wards/Wards_from_2022.shp")


##Modifying Raw Data
wards <- wards %>% select(ward=WARD,
                          name=NAME
)