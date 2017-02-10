####################################################
##Author: Swapnil Potdar
##Date: 08-Feb-2017
##Data Source :https://archive.ics.uci.edu/ml/machine-learning-databases/00356/
##
###################################################
##Load Commonly used libraries
library(dplyr)
library(ggplot2)
library(GGally)
library(reshape2)

setwd("C:\\Swapnil\\Github\\IODS-project\\Data")

#Read Math
math <- read.table("student-mat.csv",sep= ";" , header=TRUE)

# web address for portuguese class data

por <- read.table("student-por.csv", sep = ";", header = TRUE)

str(math)
str(por)

dim(math)
dim(por)


# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by,suffix=c(".math",".por"))

# see the new column names
colnames(math_por)

# glimpse at the data
glimpse(math_por)

alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
#382 observations of 32 variables. 
glimpse(alc)


#6. define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

#7. Glimpse at the joined and modified data. 

#382 observations of 35 variables. 
glimpse(alc)

#Write the data into the file or table.
# export data as *txt file. 
write.table(alc, file="alc.txt", quote=F)
# export data as *csv file.
write.csv(alc, file = "alc.csv")
