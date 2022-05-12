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
theme_set(theme_minimal())

#loading raw data sets
crash <- read.csv(file = "data/Crashes_in_DC.csv", stringsAsFactors = FALSE) #all crashes between April 1, 2012 to April 2022
bike_reqs <- read.csv("/data/Vision_Zero_Safety_Bikers.csv", stringsAsFactors = FALSE) #Safety requests shared by bikers
cp_reqs <- read.csv("/data/Vision_Zero_Safety_Cars_Pedestrians.csv", stringsAsFactors = FALSE) #Safety requests shared by pedestrians and drivers

#concatenating requests data sets
reqs <- rbind(bike_reqs, cp_reqs)

#cleaning requests data set
#selecting relevant columns
reqs <- allreqs %>% select(lat=Y,
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

#exporting clean requests data to CSV
write.csv(bike_reqs,"./data/bike_reqs_clean.csv", row.names = FALSE)

#cleaning crash data set
#selecting relevant columns
crash <- crash %>% select(lat=LATITUDE,
                            lon=LONGITUDE,
                            ward=WARD,
                            rdate=REPORTDATE,
                            major_inj=MAJORINJURIES_BICYCLIST,
                            minor_inj=MINORINJURIES_BICYCLIST,
                            unknown_inj=UNKNOWNINJURIES_BICYCLIST,
                            fatal=FATAL_BICYCLIST,
                            total_b=TOTAL_BICYCLES,
                            total_v=TOTAL_VEHICLES,
                            imp_b=BICYCLISTSIMPAIRED,
                            imp_d=DRIVERSIMPAIRED,
                            speeding=SPEEDING_INVOLVED)
#formatting date information, adding year and month columns
crash$rdate <-ymd_hms(crash$rdate)
crash$year <-year(crash$rdate)
crash$month <-month(crash$rdate)

#filtering for incidents from 2011 onwards, that involved at least one bicycle
crash = crash %>% filter(year %in% 2012:2022 & total_b > 0)

#compressing injury into one variable
for(i in 1:nrow(crash)){
  crash$inj[i] <- NA
  if(crash$major_inj[i]> 0 | crash$minor_inj[i]>0 | crash$unknown_inj[i] >0) { 
    crash$inj[i] <- 1
  } else {
    crash$inj[i] <- 0
  }
}

#removing dummy variable columns
crash <- select(crash, -rdate, -minor_inj, -major_inj, -unknown_inj)

#exporting clean crash data to csv
write.csv(crashes,"./data/crashes_clean.csv", row.names = FALSE)


