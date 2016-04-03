##Getting and Cleaning Data Course Project CodeBook
This file describes the variables, the data, and any transformations or work that I have performed to clean up the data.

The site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The run_analysis.R script performs the following steps to clean the data:

1. Read X_train.txt, y_train.txt and subject_train.txt from the "./train" folder and store them in traindata, trainlabel and trainsubject variables respectively.
2. Read X_test.txt, y_test.txt and subject_test.txt from the "./test" folder and store them in testData, testlabel and testsubject variables respectively.
3. Join testData and trainData to generate a 10299x561 data frame, joindata; join testlabel and trainlabel to generate a 10299x1 data frame, joinlabel; join testsubject to trainsubject to generate a 10299x1 data frame, joinsubject.
4. Read the features.txt file and store the data in a variable called features. Only extract the measurements on the mean and standard deviation. This results in a 66 indices list. Get a subset of joinData with the 66 corresponding columns.
5. Clean the column names of the subset. Remove the "()" and "-" symbols in the names, as well as make the first letter of "mean" and "std" a capital letter "M" and "S" respectively.
6. Read the activity_labels.txt file and store the data in a variable called activity.
7. Clean the activity names in the second column of activity. All names to lower cases. If the name has an underscore between letters, remove the underscore and capitalize the letter immediately after the underscore.
8. Transform the values of joinlabel according to the activity data frame.
9. Combine the joinsubject, joinlabel and joindata by column to get a new cleaned 10299x68 data frame, cleaneddata. Properly name the first two columns, "subject" and "activity". The "subject" column contains integers that range from 1 to 30 inclusive; the "activity" column contains 6 kinds of activity names; the last 66 columns contain measurements that range from -1 to 1 exclusive.
10. Write the cleaneddata out to "merged_data.txt" file in current working directory.
11. Finally, generate a second independent tidy data set with the average of each measurement for each activity and each subject. We have 30 unique subjects and 6 unique activities, which result in a 180 combinations of the two. Then, for each combination, calculate the mean of each measurement with the corresponding combination. So, after initializing the result data frame and performing the two for-loops, we get a 180x68 data frame.
12. Write the result out to "data_with_means.txt" file in current working directory.
