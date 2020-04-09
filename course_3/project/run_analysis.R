# Title     : Getting and Cleaning Data
# Objective : Coursera project
# Created by: sachaliguori
# Created on: 09/04/2020

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load Packages and get the Data
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
setwd(file.path(getwd(), 'course_3/project'))
path <- file.path(getwd(), 'data')
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "data.zip"))
unzip(zipfile = "data.zip")

# Load activity labels + features
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
  , col.names = c("classLabels", "activityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
  , col.names = c("index", "featureNames"))
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresWanted, featureNames]
measurements <- gsub('[()]', '', measurements)

# Load train datasets
trainDS <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(trainDS, colnames(trainDS), measurements)
trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
  , col.names = c("Activity"))
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
  , col.names = c("SubjectNum"))
trainDS <- cbind(trainSubjects, trainActivities, trainDS)

# Load test datasets
testDS <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(testDS, colnames(testDS), measurements)
testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
  , col.names = c("Activity"))
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
  , col.names = c("SubjectNum"))
testDS <- cbind(testSubjects, testActivities, testDS)

# merge datasets
merged <- rbind(trainDS, testDS)

# Convert classLabels to activityName basically. More explicit.
merged[["Activity"]] <- factor(merged[, Activity]
  , levels = activityLabels[["classLabels"]]
  , labels = activityLabels[["activityName"]])

merged[["SubjectNum"]] <- as.factor(merged[, SubjectNum])
merged <- reshape2::melt(data = merged, id = c("SubjectNum", "Activity"))
merged <- reshape2::dcast(data = merged, SubjectNum + Activity ~ variable, fun.aggregate = mean)

data.table::fwrite(x = combined, file = "tidydata.txt", quote = FALSE)
