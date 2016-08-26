# Code Book - Data Getting and Cleaning Course Project 
this file contains: 
* a code book to indicate all the variables and summaries calculated, along with units, and any other relevant information.
* an introduction to the procedure details of data processing, from origin data to final tidy dataset.

## CodeBook
the output data contains 5 column, including 3 dimentions (subject, activityname, variable) and 2 measure (average mean & average standerd deviation). 
* subject - this dimention indicates the index of subject. 
* activityname - this dimention indicates the activity which the subject was doing.
* variable - there are total 84 variables for each activity and subject combination, including 66 variables from the x_test and x_train file, and 18 variables from Inertial Signals data.
* meanAvg - the average value of all the corresponding data's mean value.
* stdAvg - the average value of all the corresponding data's standerd deviation value.

## Procedure Details
* read the files features.txt and activity_labels.txt under the root folder, and all the files under the test and train folder.
* calculate the row mean and standerd deviation of all the dataset under the Inertial Signals folder. total 18 variables (9 mean and 9 std)
* filter the variables in x_test.txt and x_train.txt by the feature info in features.txt file, and retrieve all the mean() and std() items. total 66 vairables (33 mean and 33 std)
* join all the file and calculation result together.
* transform the file to a proper form under the guidance of tidy data standerd, and make their names descriptive.
