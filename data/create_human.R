library(dplyr)
library(ggplot2)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = ")..")


humandev <- rename(hd, HDI.Rank = HDI.Rank, Country = Country, HDI = Human.Development.Index..HDI. , Life.Expectancy = Life.Expectancy.at.Birth , Expected.Education= Expected.Years.of.Education , Education = Mean.Years.of.Education , GNI = Gross.National.Income..GNI..per.Capita , GNI.HDI =GNI.per.Capita.Rank.Minus.HDI.Rank )

dim(humandev)
str(humandev)


gender <- mutate(gii, GIIRank = as.integer(GII.Rank), 
                 GII= as.numeric(Gender.Inequality.Index..GII.), 
                 Mort = as.numeric(Maternal.Mortality.Ratio), 
                 BR = as.numeric(Adolescent.Birth.Rate),
                 Rep = as.numeric(Percent.Representation.in.Parliament),
                 EduF = as.numeric(Population.with.Secondary.Education..Female.),
                 EduM = as.numeric(Population.with.Secondary.Education..Male.),
                 LabF = as.numeric(Labour.Force.Participation.Rate..Female.) ,
                 LabM = as.numeric(Labour.Force.Participation.Rate..Male.))
gender <- select(gender, one_of(c("GIIRank","Country","GII","Mort","BR","Rep","EduF","EduM","LabF","LabM")))
gender <- mutate(gender, LabRatio = LabF / LabM, EduRatio = EduF / EduM)
dim(gender)
str(gender)

human <- inner_join(humandev,gender,by= "Country")
dim(human)
str(human)

write.csv(x = human,file = "human.csv")
rm(gender,gii,human,humandev,hd)

test_data <- read.csv(file = "human.csv",row.names = "X")
summary(test_data)