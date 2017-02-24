##############################################
###Author Swapnil Potdar
###Email: swapnil.potdar@helsinki.fi
###Source: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt
###############################################
library(dplyr)
library(ggplot2)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = ")..")

humandev <- rename(hd, HDI.Rank = HDI.Rank, Country = Country, HDI = Human.Development.Index..HDI. , Life.Expectancy = Life.Expectancy.at.Birth , Expected.Education= Expected.Years.of.Education , Education = Mean.Years.of.Education , GNI = Gross.National.Income..GNI..per.Capita , GNI.HDI =GNI.per.Capita.Rank.Minus.HDI.Rank )
#hd$Gross.National.Income..GNI..per.Capita <- str_replace(hd$Gross.National.Income..GNI..per.Capita, pattern=",", replace ="") %>% as.numeric

humandev <- rename(hd, HDIRank = HDI.Rank,
                   Country = Country,
                   HDI = Human.Development.Index..HDI. ,
                   Life.Exp = Life.Expectancy.at.Birth ,
                   Edu.Exp = Expected.Years.of.Education ,
                   Edu = Mean.Years.of.Education ,
                   GNI = Gross.National.Income..GNI..per.Capita ,
                   GNI.HDI =GNI.per.Capita.Rank.Minus.HDI.Rank )
dim(humandev)
str(humandev)
head(humandev)
gender <- mutate(gii, GIIRank = as.integer(GII.Rank),
                 Country = Country, 
                 GII = as.numeric(Gender.Inequality.Index..GII.), 
                 Mat.Mor = as.numeric(Maternal.Mortality.Ratio), 
                 Ado.Birth = as.numeric(Adolescent.Birth.Rate),
                 Parli.F = as.numeric(Percent.Representation.in.Parliament),
                 EduF = as.numeric(Population.with.Secondary.Education..Female.),
                 EduM = as.numeric(Population.with.Secondary.Education..Male.),
                 LabF = as.numeric(Labour.Force.Participation.Rate..Female.) ,
                 LabM = as.numeric(Labour.Force.Participation.Rate..Male.))
gender <- select(gender, one_of(c("GIIRank","Country","GII","Mat.Mor","Ado.Birth","Parli.F","EduF","EduM","LabF","LabM")))
gender <- mutate(gender, Labo.FM = LabF / LabM, Edu2.FM = EduF / EduM)
dim(gender)
str(gender)
head(gender)


human <- inner_join(humandev,gender,by= "Country")
dim(human)
str(human)
##############################
##############################
## Convert into Numeric and replace the commas
human <- mutate(human,GNI=str_replace(human$GNI, pattern=",", replace ="")%>%as.numeric())
##  important columns
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
## Filter important column
human <- select(human, one_of(keep))
head(human)
###Delete missing rows
human=human[complete.cases(human),]
###Delete regions, keep countries
## Last 7 are regions
last <- nrow(human) - 7
# choose everything until the last 7 observations
human <- human[1:last,]


###Countries as Rownames 
rownames(human) <- human$Country
human <- select(human, -Country)
head(human)

###Write to FIle
write.csv(human,file = "human.csv",row.names = TRUE)
test_data <- read.csv(file = "human.csv")
head(test_data)
summary(test_data)
