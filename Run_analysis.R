setwd("D:/Data Science/3 -Data cleaning/Quiz-4/UCI HAR Dataset")
getwd()

features<-read.table("features.txt")
Features<-features[[2]]

Xtrain<-read.table("train/X_train.txt",col.names = Features)
Xtest<-read.table("test/X_test.txt",col.names = Features)
Ytrain<-read.table("train/y_train.txt",col.names = "Label")
Ytest<-read.table("test/y_test.txt",col.names = "Label")
subjecttrain<-read.table("train/subject_train.txt",col.names = "Subject")
subjecttest<-read.table("test/subject_test.txt",col.names = "Subject")
activities <- read.table("activity_labels.txt", col.names = c("Label", "activity"))

x<-rbind(Xtrain,Xtest)
y<-rbind(Ytrain,Ytest)
z<-rbind(subjecttrain,subjecttest)
masterdata<-cbind(x,y,z)

library(dplyr)
tidydata<-select(masterdata,contains("mean"),contains("std"),contains("subject"), contains("Label"))
dim(tidydata)

tidydata$Label<-activities[tidydata$Label,2]



names(tidydata)[88] = "activity"
names(tidydata)<-gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))

FinalData <- tidydata %>%
  group_by(Subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
