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
crash <- read.csv("./data/crashes_clean.csv", stringsAsFactors = FALSE) #all crashes between April 1, 2012 to April 2022
reqs <- read.csv("./data/bike_reqs_clean.csv", stringsAsFactors = FALSE) #Safety requests shared by bikers
