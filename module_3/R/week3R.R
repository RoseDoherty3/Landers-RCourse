#TITLE: Data Import and Cleaning
#load rstudioapi
library(rstudioapi)

#these two lines together will set the working directory to the
##location you currently have week3.R, and you will see no errors/
###output when executing them
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#: Use read.csv to create a data frame called raw_df from the CSV 
##file you downloaded earlier (back track the path with ..)
raw_df <- read.csv("../data/week3.csv")
View(raw_df)

#Recast (i.e., convert and save over itself) timeStart into POSIX format
raw_df$timeStart <- as.POSIXct(raw_df$timeStart)

#Recast timeEnd 
raw_df$timeEnd <- as.POSIXct(raw_df$timeEnd)

#Create a new data frame called clean_df that contains only real 
##participants (those participating after June 2017)
  #my method
clean_df <- subset(raw_df, timeStart > "2017-06-30")

  #debriefing method
clean_df <- subset(raw_df, timeStart >= as.POSIXct("2017-07-01"))

View(clean_df)

#Update clean_df so that it only contains people who were paying 
##attention (those who answered 1 on the attention question num 6)
clean_df <- subset(clean_df, q6 == 1)

#TITLE: Analysis
#Save the total time spent on the study by each participant in seconds 
##into a new variable in clean_df called timeSpent using difftime().
clean_df$timeSpent <- as.numeric((clean_df$timeEnd - clean_df$timeStart)
                                  , units = "secs")

  #defbriefing method
clean_df$timeSpent <- difftime(clean_df$timeEnd, clean_df$timeStart)*60

clean_df$timeSpent <- difftime(clean_df$timeEnd, clean_df$timeStart, 
                               units = "secs")

#Create a histogram of timeSpent. You will need to recast timeSpent as 
##numeric first
hist(as.numeric(clean_df$timeSpent))
    #alternate debriefing method is to use unclass instead of as.numeric

#Using lapply, iterate over the 5th – 14th columns of clean_df and 
##run the function table. Save the result to a variable called 
###frequency_tables_list

frequency_tables_list <- lapply(clean_df[,5:14], table)

frequency_tables_list


#Using lapply, iterate over the frequency_tables_list variable and run 
##the barplot function. If done correctly, you should see 10 bar charts 
###appear in the Plots panel of R Studio

lapply(frequency_tables_list, barplot)


#Participants should have answered q1 with a greater or equal value to 
##what they answered q2 with, and they never should have answered q2 
###with the same value as what they answered q3 with. Display a count of 
####the number of times in clean_df that this actually happened.

sum(clean_df$q1 >= clean_df$q2 & clean_df$q2 != clean_df$q3)
