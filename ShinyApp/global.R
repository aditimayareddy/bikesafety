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

#loading cleaned data sets
crash <- read.csv("data/crashes_clean.csv", stringsAsFactors = FALSE) #all crashes between April 1, 2012 to April 2022
reqs <- read.csv("./data/bike_reqs_clean.csv", stringsAsFactors = FALSE) #Safety requests shared by bikers
#w <- read.csv("./data/Wards_from_2022.csv", stringsAsFactors = TRUE)

#getting base map
dcmap <- get_stamenmap(
  bbox = c(left = -77.225, bottom = 38.84 , right = -76.8125 , top = 39.000),
  maptype = "terrain",
  crop = TRUE,
  color = "color",
  zoom = 12
)
#setting base map as dc
dc <- ggmap(dcmap)