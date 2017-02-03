################################################################################################
#Course: Introduction to Open Data Science, spring 2017
#Author: Swapnil Potdar
#Assignment 2 : Regression and model validation
################################################################################################
#Read the full learning2014 data from 
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#structure of the dataframe
str(lrn14)
#'data.frame':	183 obs. of  60 variables:

#Dimensions of the dataframe
dim(lrn14)
#[1] 183  60
library(dplyr)
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

#Select strategic learning columns and create averaged column 'stra' 
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

#Columns required
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# selected columns are used to create a new dataframe
learning2014 <- select(lrn14, one_of(keep_columns))

# stucture of the dataframe
str(learning2014)

# subset data with Points > 0
learning2014 <- filter(learning2014, Points > 0) 
str(learning2014)
dim(learning2014)

setwd("C://Swapnil//GitHub//IODS-project//data")

write.csv(learning2014, file = "learning2014.csv",row.names=F)

learnings <- read.csv("learning2014.csv", header = T)

dim(learnings)
head(learnings)

