#R SSTUDIO API CODE  #Write code to set WD to directory where your R script is saved
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

#DATA IMPORT
library(tidyverse)

#using four tidy import functions, convert 4 data files with appropriate cols
#use read.delim b/c separated by dash(-), need to specify header false
Adata_tbl <- read_delim("../data/Aparticipants.dat", delim = "-", col_names = 
                          c("casenum", "parnum", "stimver", "datadate", "qs"))
glimpse(Adata_tbl)

#use read.csv b/c comma separated, header auto true
Anotes_tbl <- read_csv("../data/Anotes.csv")

glimpse(Anotes_tbl)

#use read.delim b/c separated by tab (\t), need to specify header false
  ##use paste0 to quick label all the question columns 1-10
Bdata_tbl <- read_delim("../data/Bparticipants.dat", "\t", col_names = 
       c("casenum", "parnum", "stimver", "datadate", paste0("q",1:10)))

glimpse(Bdata_tbl)

#used read.delim b/c without specifying the sep it figures it out on its own
Bnotes_tbl <- read_tsv("../data/Bnotes.txt")

glimpse(Bnotes_tbl)

#DATA CLEANING
#in A data file, using pipes split qs into 5 correct variable names and convert
  ##to numeric
    ##because updating the data file we use assignment operator to save it back
      ###itself

library(magrittr)
##with this library, instead of Adata_tbl <- Adata_tbl %>% you can use format 
    #of Adata_tbl %<>% 
library(lubridate)
#needed for date conversion

Adata_tbl %<>% 
  separate(qs, paste0("q", 1:5), " - ") %>% 
  mutate_at(vars(q1:q5), as.numeric) %>% 
  mutate(datadate = mdy_hms(datadate))

#one pipe per file aggregate across conditions such that participant number and 
##mean scores of q1-q5 across all 4 conditions are saved in two new tbls: 
###Aaggr_tbl and Baggr_tbl i.e., each aggregated table should have 1 row per 
####participant not 4
#need mean for each q across the 4 conditions for each participant
Aaggr_tbl <- Adata_tbl %>% 
  group_by(parnum) %>% 
  summarise_if(is.numeric, mean)

#or alternate (and better) way is...

Aaggr_tbl <- Adata_tbl %>% 
  group_by(parnum) %>% 
  summarise_at(vars(q1:q5), mean)

Baggr_tbl <-  Bdata_tbl %>% 
  group_by(parnum) %>% 
  summarise_at(vars(q1:q5), mean)

#using a join, add participant notes to each of your newly aggregated tables as 
##new column called notes

##any type of join would work b/c have same number of participants
Aaggr_tbl %<>%
  inner_join(Anotes_tbl, by = "parnum")

##better way on less lines
Aaggr_tbl <- inner_join(Aaggr_tbl, Anotes_tbl, by = "parnum")
Baggr_tbl <- inner_join(Baggr_tbl, Bnotes_tbl, by = "parnum")

#using a series of pipes, combine cases from Aaggr_tbl and Baggr_tbl, drop rows
##with research notes, and report the final Ns split by data file source as a
##tibble displayed to the console

bind_rows(A = Aaggr_tbl, B = Baggr_tbl, .id = "dataset") %>% 
  filter(is.na(notes)) %>% 
  group_by(dataset) %>% 
  summarise(n())