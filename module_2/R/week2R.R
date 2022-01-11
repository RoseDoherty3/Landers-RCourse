#In R Studio, create a new Project. Use the directory/folder structure
  #discussed in the reading, with subfolders called data, figures, docs, 
  #R, and output.
#Put the CSV file into the data subdirectory
#Create a new R file called week2.R. All work should be in this file
#Save week2.csv to an appropriate location within your project folders

#Import and Labeling
  #create a data frame called rt_df using the csv file
rt_df <- read.csv("module_2/data/week2.csv", header = TRUE)

  #Add labels to condition within rt_df: A should be labelled Control 
    #and B should be labelled Exerimental
rt_df$condition <- factor(rt_df$condition, levels = c("A", "B"), 
                          labels = c("Control", "Experimental"))
  #add labels to gender: Male, Female and Transgender (for M, F, T)
rt_df$gender <- factor(rt_df$gender, levels = c("M", "F", "T"), 
                       labels = c("Male", "Female", "Transgender"))

#Analysis
  #Display mean reaction time across rt_df using the mean() function.
mean(rt_df$rt)

  #Create a new data frame called rt_f_df containing only female cases.
rt_f_df <- subset(rt_df, subset = gender == "Female")

  #Using one command, display frequencies and/or quantitative summaries 
    #of all variables in rt_f_df
summary(rt_f_df)

  #Create a histogram of female reaction times by using the hist() 
    #function with one parameter: the rt column of rt_f_df
hist(rt_f_df$rt)

  #Create a list called datasets containing both rt_df and rt_f_df
datasets <- list(rt_df, rt_f_df)

  #Display the contents of the rt variable from the first dataset 
    #contained within datasets
datasets[[1]][2]
