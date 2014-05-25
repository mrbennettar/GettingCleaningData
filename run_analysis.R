#this script assumes that you do not have any of the files in your working directory
#set the location of the desired file on the web
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download the file from the web and put it in your working directory
download.file(fileUrl, destfile="./getdata-projectfiles-UCI HAR Dataset.zip")

#unzip the file into your working directory
unzip("getdata-projectfiles-UCI HAR Dataset.zip")

#change working directory to the newly created folder
setwd("./UCI HAR Dataset")

#get the text files and read them as data frames
#get the feature names
features<-read.table("features.txt", col.names=c("feature_number","feature_title"))
#get the activity names
actLabels<-read.table("activity_labels.txt",col.names=c("activity_number","activity_title"))

#get the test and train data and name the columns with the correct features
testData<-read.table("./test/X_test.txt",col.names=features$feature_title)
trainData<-read.table("./train/X_train.txt",col.names=features$feature_title)

#get the activity and subject information for the training and test data
testActivity<-read.table("./test/y_test.txt",col.names="activity_number")
testSubject<-read.table("./test/subject_test.txt",col.names="subject")
trainActivity<-read.table("./train/y_train.txt",col.names="activity_number")
trainSubject<-read.table("./train/subject_train.txt",col.names="subject")

#combine the subject column, activity column, and data for test and train
testSAD<-cbind(testSubject,testActivity,testData)
trainSAD<-cbind(trainSubject,trainActivity,trainData)

#stack the test and train data to form one data frame
testTrain<-rbind(testSAD,trainSAD)
#join the large data frame with the activity labels data frame to have descriptions of
#activities instead of just numbers
library(plyr)
tTAAct<-join(actLabels, testTrain, by="activity_number")

#get column numbers that have "mean" or "std" in their name
meanstdnames<-grep("mean|std",names(tTAAct))
#subset merged data frame to get only columns with "mean" or "std" in their name
tidy1<-tTAAct[,meanstdnames]

#make the names of tidy1 lowercase
lownames1<-tolower(names(tidy1))
#remove the periods from the names of tidy1
lownames2<-gsub("\\.","",lownames1)

#reassign the new names to tidy1
names(tidy1)<-lownames2

#add the subject and activity columns back into the data frame
finaltidy<-cbind(tTAAct[,3],tTAAct[,2],tidy1)
names(finaltidy)[1:2]<-c("subject","activity")

#melt finaltidy using subject and activity as ids and cast that melted data frame
#using 'mean' as the aggregate function
library(reshape2)
tidymelt<-melt(finaltidy, id=c("subject","activity"))
#tidycast is the desired tidy data set
tidycast<-dcast(tidymelt,subject + activity ~ variable, fun.aggregate=mean)
