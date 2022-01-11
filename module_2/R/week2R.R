#In R Studio, create a new Project. Use the directory/folder structure
  #discussed in the reading, with subfolders called data, figures, docs, 
  #R, and output.
#Put the CSV file into the data subdirectory
#Create a new R file called week2.R. All work should be in this file
#Save week2.csv to an appropriate location within your project folders

#Import and Labeling
  #create a data frame called rt_df using the csv file
  #what you want to call the new dataset in R <- read function(file location
    #if the excel sheet/table has headers aready in place = TRUE so can
      #be read by R)
rt_df <- read.csv("module_2/data/week2.csv", header = TRUE)

  #Add labels to condition within rt_df: A should be labelled Control 
    #and B should be labelled Experimental
  #dataset name and specific variable of interest <- factor function(
    #repeat names, current levels, new labels given)
rt_df$condition <- factor(rt_df$condition, levels = c("A", "B"), 
                          labels = c("Control", "Experimental"))

      ##alternate method according to debriefing (worked and changed levels 
        #but didn't alter the variable information?)
levels(rt_df$condition) <- factor(c("Control", "Experimental"))

  #add labels to gender: Male, Female and Transgender (for M, F, T)
  #as before but with different variable and labels
rt_df$gender <- factor(rt_df$gender, levels = c("M", "F", "T"), 
                       labels = c("Male", "Female", "Transgender"))

      ##alternate method according to debriefing (worked and changed levels 
        #but didn't alter the variable information?)
levels(rt_df$gender) <- factor(c("Female", "Male", "Transgender"))

#use to open dataset in R viewer
View(rt_df)

#Analysis
  #Display mean reaction time across rt_df using the mean() function.
mean(rt_df$rt)

  #Create a new data frame called rt_f_df containing only female cases.
  #use subset to grab one part of existing data frame, specify gender
rt_f_df <- subset(rt_df, subset = gender == "Female")

View(rt_f_df)

  #Using one command, display frequencies and/or quantitative summaries 
    #of all variables in rt_f_df
summary(rt_f_df)

  #Create a histogram of female reaction times by using the hist() 
    #function with one parameter: the rt column of rt_f_df
  #save in figures folder as wel in plots window
hist(rt_f_df$rt)

  #Create a list called datasets containing both rt_df and rt_f_df
datasets <- list(rt_df, rt_f_df)

  #Display the contents of the rt variable from the first dataset 
    #contained within datasets
  #extract 1st dataset with double square brackets (single bracket would
    #be subset showing 1st item in the list, double bracket is extraction
      #on data from a list item)
datasets[[1]][2]
