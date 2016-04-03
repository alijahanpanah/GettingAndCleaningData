# Step1. Merge the training and the test sets to create one dataset.
trainData <- read.table("./train/X_train.txt")
dim(trainData) # 7352 * 561
head(trainData)
trainLabel <- read.table("./train/y_train.txt")
table(trainLabel)
trainSubject <- read.table("./train/subject_train.txt")
testData <- read.table("./test/X_test.txt")
dim(testData) # 2947 * 561
head(testData)
testLabel <- read.table("./test/y_test.txt")
table(testLabel)
testSubject <- read.table("./test/subject_test.txt")
joindata <- rbind(trainData, testData)
dim(joindata) # 10299 * 561
joinlabel <- rbind(trainLabel, testLabel)
dim(joinlabel) # 10299 * 1
joinsubject <- rbind(trainSubject, testSubject)
dim(joinsubject) # 10299 * 1

# Step2. Extract only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("./features.txt")
head(features)
dim(features) # 561 * 2
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
length(meanStdIndices) # 66
joindata <- joindata[, meanStdIndices]
dim(joindata) # 10299 * 66
names(joindata) <- gsub("\\(\\)", "", features[meanStdIndices, 2]) # remove "()"
names(joindata) <- gsub("mean", "Mean", names(joindata)) # capitalize M
names(joindata) <- gsub("std", "Std", names(joindata)) # capitalize S
names(joindata) <- gsub("-", "", names(joindata)) # remove "-" in column names 

# Step3. Use descriptive activity names to name the activities in the data set

activity <- read.table("./activity_labels.txt")
head(activity)
activity[, 2] <- tolower(gsub("_", "", activity[, 2]))
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
activityLabel <- activity[joinlabel[, 1], 2]
joinlabel[, 1] <- activityLabel
names(joinlabel) <- "activity"

# Step4. Appropriately label the data set with descriptive activity names. 

names(joinsubject) <- "subject"
cleanedData <- cbind(joinsubject, joinlabel, joindata)
dim(cleanedData) # 10299*68
write.table(cleanedData, "merged_data.txt", row.name = FALSE) # write out the 1st dataset

# Step5. Create a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
subjectLen <- length(table(joinsubject)) # 30
activityLen <- dim(activity)[1] # 6
columnLen <- dim(cleanedData)[2]
result <- matrix(NA, nrow=subjectLen*activityLen, ncol=columnLen) 
result <- as.data.frame(result)
colnames(result) <- colnames(cleanedData)
row <- 1
for(i in 1:subjectLen) {
  for(j in 1:activityLen) {
    result[row, 1] <- sort(unique(joinsubject)[, 1])[i]
    result[row, 2] <- activity[j, 2]
    bool1 <- i == cleanedData$subject
    bool2 <- activity[j, 2] == cleanedData$activity
    result[row, 3:columnLen] <- colMeans(cleanedData[bool1&bool2, 3:columnLen])
    row <- row + 1
  }
}
head(result)
write.table(result, "average_data.txt", row.name = FALSE) # write out the 2nd dataset
