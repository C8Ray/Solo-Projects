#NYC Wastewater Analysis-----

#Load data and packages
libary(tidyverse)
install.packages("svDialogs")
library(svDialogs)
readme <- read.csv("C:/Users/Caitlin Ray/Documents/Solo-Projects/COVID19_SARS-CoV-2_data_on_wastewater_samples__METADATA_V02.00.csv")
conc <- read.csv("C:/Users/Caitlin Ray/Documents/Solo-Projects/SARS-CoV-2_concentrations_measured_in_NYC_Wastewater.csv")

#1. make this a prompt for most recent download AND #2. remove first row/title
dlg_message(
  "The next pop-up will ask that you choose a .CSV file.
  \nPlease upload a file of the most recent download of the NYC watewater data from 
  \nhttps://data.cityofnewyork.us/Health/SARS-CoV-2-concentrations-measured-in-NYC-Wastewat/f7dc-2q9f/data",
  type = c("ok")
)

wwdata <- read.csv(file.choose(), header=T, skip=1)


#3. convert dates to dates

#4. assign borough as new data is added

#5.display data by treatment plant and by borough in a trended fashion



