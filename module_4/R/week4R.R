#R Studio API Code
  #Write code to set the working directory to the directory where your R 
  ##script is saved
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

#Data Import
install.packages("tidyverse")
library(tidyverse)
# package has conflicts for some functions with existing functions including 
##dplyr filter() and stats filter()
    #to specify which one you want when there's two use full name
    ##dplyr::filter() or stats::filter()

#Import the week4 datafile as a data frame called week4_df using function
  #from tidyverse library, no cleaning, just import, label col
week4_df <- read_delim("../data/week4.dat", "-", col_names = c(
  "casenum", "parnum", "stimver", "datadate", "qs"))
view(week4_df)

#Display a summary of your data frame the tidy way, i.e., don’t use 
  #summary ()
glimpse(week4_df)

#Split qs into the five variables they should be according to tidy 
##philosophy. Remember to use the correct variable names as specified 
###above. Do not change their classes yet. Ensure that the values you 
####create do not contain unnecessary whitespace
week4_df <- separate(week4_df, "qs", c("q1", "q2", "q3", "q4", "q5"), 
                     sep = " - ")
#alternate way from debriefing using paste() so it's in a better format
##to avoid writing out all variable names *can also use paste0("q",1:5)
###which also allows for removing extra spaces so don't repeat sep
week4_df <- separate(week4_df, "qs", c(paste("q",1:5, sep="")), 
                     sep = " - ")
#best way...
week4_df <- separate(week4_df, "qs", c(paste0("q",1:5)), " - ")

#Coerce all five of your new variables into a more appropriate class 
##using sapply()
week4_df[5:9] <- sapply(week4_df[5:9], as.numeric)


#Convert all values of 0 (zero) within these five variables only into 
##missing values.
week4_df[5:9][week4_df[5:9]==0] <- NA

#Convert the datadate column into a class appropriate for datetimes.
week4_df$datadate <- as.POSIXct(week4_df$datadate, format = "%b %d %Y, 
                                %H:%M:%S")
#alternate way from debriefing that is easier when in good format
library(lubridate)
week4_df$datadate <- mdy_hms(week4_df$datadate)
#Data Analysis

#Create a new data frame called q2_over_time_df that contains each 
##participant number on a single row, with values corresponding to each
###version of the stimulus as columns

#like pivot_wider(), takes in data (here specified three columns of
##interest from week4_df), then gets col name from second arg (here
###the stim version), then fills the data for those cols in with 3rd
####argument (here q2 answers)
q2_over_time_df <- spread(week4_df[,c("parnum", "stimver", "q2")], 
                          stimver, q2)

#Using q2_over_time_df, display the proportion of usable cases out of all 
##those collected

##from debriefing but didn't work??? Don't know why not, exactly the same
(nrow(q2_over_time_df) - nrow(q2_over_time_df[is.na(q2_over_time_df), ])) / 100
##or
mean(complete.cases(q2_over_time_df))
###or
sum(complete.cases(q2_over_time_df))/100
