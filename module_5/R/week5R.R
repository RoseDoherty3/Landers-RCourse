#R Studio API Code  #Write code to set WD to directory where your R script is saved
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

#Data Import
library(tidyverse)
Adata_tbl <- read.delum("Aparticipants.dat", delim = "-")