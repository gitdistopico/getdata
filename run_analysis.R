# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
# Good luck!

require(data.table)
require(dplyr)

# Create directories
if (!file.exists("data")){ dir.create("data") }
if (!file.exists("output")){ dir.create("output") }

# If the data file is not in our working directory
filename <- "./getdata.zip"
if (!file.exists("./getdata.zip")) {
  filename <- "./data/getdata.zip"  
}

if (!file.exists(filename)) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile=filename, method="curl")
}

# 1. Merges the training and the test sets to create one data set.
# Retriving the data
train.data <- read.table(unz(filename, "UCI HAR Dataset/train/X_train.txt"))
test.data <- read.table(unz(filename, "UCI HAR Dataset/test/X_test.txt"))

# Retriving the appropriate name mapping
feature.name <- read.table(unz(filename, "UCI HAR Dataset/features.txt"), sep = ' ')

# Merging training and test dataset
complete.data <- rbind(train.data, test.data)

# Properly name the dataset columns
names(complete.data) <- feature.name$V2

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
measure.col <- feature.name$V1[grep(c("-mean\\(\\)|-std\\(\\)"), feature.name$V2)]
measure.data <- complete.data[measure.col]

# 3. Uses descriptive activity names to name the activities in the data set
# Retriving activities names
activity.name <- read.table(unz(filename, "UCI HAR Dataset/activity_labels.txt"), sep = ' ') 

# Retriving the activity and subjects
train.activity <- read.table(unz(filename, "UCI HAR Dataset/train/y_train.txt"))
train.subject <- read.table(unz(filename, "UCI HAR Dataset/train/subject_train.txt"))

test.activity <- read.table(unz(filename, "UCI HAR Dataset/test/y_test.txt"))
test.subject <- read.table(unz(filename, "UCI HAR Dataset/test/subject_test.txt"))

measure.data$activity <- activity.name$V2[rbind(test.activity, train.activity)$V1]
measure.data$subject <- rbind(test.subject, train.subject)$V1

# 4. Appropriately labels the data set with descriptive variable names. 
# Properly name domains
column.name <- names(measure.data)

column.name <- sub("^t", "time.", column.name)
column.name <- sub("^f", "frequency.", column.name)

column.name <- sub("Acc", "Acceleration", column.name)
column.name <- sub("Gyro", "Velocity", column.name)

column.name <- sub("Mag", "Magnitude", column.name)

column.name <- sub("\\-std\\(\\)", ".std", column.name)
column.name <- sub("\\-mean\\(\\)", ".mean", column.name)

column.name <- sub("-X$", ".x", column.name)
column.name <- sub("-Y$", ".y", column.name)
column.name <- sub("-Z$", ".z", column.name)

names(measure.data) <- column.name

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
avg.data <- tbl_df(measure.data) %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# Write the tidy data file
write.table(avg.data, file="output/avg.data", row.name=FALSE)