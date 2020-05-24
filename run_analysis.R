# Download and unzip the data to c3data folder

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file (fileUrl, destfile = "c3data.zip")
unzip ("c3data.zip", exdir ="c3data")


# Read the data and variables info into R, and add column names

library(dplyr)

features <- read.table("./c3data/UCI HAR Dataset/features.txt", col.names = c("n", "feature"))
activities <- read.table ("./c3data/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

subject_train <- read.table("./c3data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
y_train <- read.table ("./c3data/UCI HAR Dataset/train/y_train.txt", col.names = "code")
x_train <- read.table ("./c3data/UCI HAR Dataset/train/X_train.txt", col.names = features$feature )

subject_test <- read.table("./c3data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
y_test <- read.table ("./c3data/UCI HAR Dataset/test/y_test.txt", col.names = "code")
x_test <- read.table ("./c3data/UCI HAR Dataset/test/X_test.txt", col.names = features$feature)

# 1. Merges the training and the test sets to create one data set.
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)
merged <- rbind(train, test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_stdv <- select(merged, subject, code, contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set
merged$code <- activities[merged$code, 2]

# 4. Appropriately labels the data set with descriptive variable names.

names(merged)[2] <- "activity"
names(merged) <- gsub("^t", "Time", names(merged))
names(merged) <- gsub("^f", "Frequency", names(merged))
names(merged) <- gsub("Acc", "Accelerometer", names(merged))
names(merged) <- gsub("Gyro", "Gyroscope", names(merged))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity 
#    and each subject.

subAct <- group_by(merged, subject, activity)
tidydata2 <- summarize_all(subAct, mean)
write.table(tidydata2, "tidydata2.txt", row.names=FALSE)

