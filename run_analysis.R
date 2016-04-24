## run_analysis.R
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## STEP 1A: LOAD LIBRARY PACKAGES AND ABSOLUTE PATH (ON WINDOWS)
library(dplyr)
library(sqldf)
require(data.table)

## example: setwd("C:/Donald/Personal/Coursera/Data Science Specialization/Course3_Getting and Cleaning Data/Week4/Assignment/getdata-projectfiles-UCI HAR Dataset")

## STEP 1B: LOAD THE LOOKUP DATA FOR ACTIVITY AND FEATURE LABELS
activity_labels   		<- fread("./UCI HAR Dataset/activity_labels.txt", sep = " ", header= FALSE)
colnames(activity_labels) 	<- c("activity_code","activity")
feature_names     		<- fread("./UCI HAR Dataset/features.txt", sep = " ", header= FALSE)

## STEP 1C: READ THE TEST DATA
subject_test   <- fread("./UCI HAR Dataset/test/subject_test.txt", sep = " ", header= FALSE)
activity_test  <- fread("./UCI HAR Dataset/test/y_test.txt", sep = " ", header= FALSE)
variable_test  <- fread("./UCI HAR Dataset/test/X_test.txt", sep = " ", header= FALSE)
test_data      <- cbind(subject_test,activity_test,variable_test)

## STEP 1D: READ THE TRAIN DATA
subject_train  <- fread("./UCI HAR Dataset/train/subject_train.txt", sep = " ", header= FALSE)
activity_train <- fread("./UCI HAR Dataset/train/y_train.txt", sep = " ", header= FALSE)
variable_train <- fread("./UCI HAR Dataset/train/X_train.txt", sep = " ", header= FALSE)
train_data     <- cbind(subject_train,activity_train,variable_train)

## STEP 1D: COMBINE THE TEST AND TRAIN SETS
combined_data           <- rbind(test_data,train_data)

## STEP 4: ASSIGN COLUMN NAMES TO THE COMBINED DATA SET
colnames(combined_data) <- c("subject_code","activity_code",feature_names$V2)

## STEP 2A: EXTRACT ONLY THE MEAN AND STD COLUMNS FROM THE DATA SET (INCLUDING THE ACTIVITY AND SUBJECT)
mean_sd 		<- cbind(
				select(combined_data, as.numeric(subject_code)),
				select(combined_data, as.numeric(activity_code)),
				select(combined_data, contains("mean()")), 
				select(combined_data, contains("std()"))
				)
## STEP 3A: JOIN TABLES TO DERIVE ACTIVITY LABELS
mean_sd_desc		<- inner_join(mean_sd, activity_labels)

## STEP 3A: JOIN TABLES TO DERIVE ACTIVITY LABELS

## STEP 5A: COMPUTE MEAN ON ALL VARIABLES

mean_sd_desc_2		<-  mean_sd_desc %>% group_by(subject_code,activity_code,activity) %>% summarize_each(funs(mean))

mean_sd_desc_3		<-  subset(mean_sd_desc_2,,-activity_code)

## STEP 5B: WRITE BACK DATA SET TO FILE
write.table(mean_sd_desc_3, "output.txt", sep=" ", row.name=FALSE)	
