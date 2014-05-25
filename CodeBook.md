## Code book for Getting and Cleaning Data course project

This code book accompanies the script created for the course project for the Getting and Cleaning Data course on coursera.org. The task was to create one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This code book provides the techniques and rationale used to process the provided data sets and turn them into one, usable tidy data set.

### Downloading the data

It is not necessary for the user to manually download any files before using this script.  The code will download and unzip the data to the user's current working directory.  The script then proceeds to read all the data files into R as data frames.

### Merging and reshaping the data

I used the cbind command to properly construct the data frame that combines the test and train data along with the subject, activity, and features - which are used as the variable names for the final tidy data set.  I used the join command from the plyr library to get descriptive activity labels into the data frame.  This fulfills the requirements in steps 1, 3, and 4.

### Getting only means and standard deviations

I used the grep command to find all the variable names that contained the strings 'mean' or 'std'.  I then subset the data frame to include on the columns with variable containing those strings.  This fulfills the requirement in step 2.

### Updating variable names

To make the variable names just a little easier to read, I converted all the variable names to lower case using the tolower command.  I then removed all the periods from the titles with the gsub command (making sure to escape the '.' using "\\.").  I then replaced the names of the tidy data frame with the newly modified names.

### Producing the final tidy data set

In order to get averages of the means and standard deviations for each avtivity and subject combination, I melted and dcast the data frame using 'activity' and 'subject' as the ids.  The data frame titles 'tidycast' is the desired tidy data set that fufills the requirement of step 5.

### Variable used

The original data were gathered from a Samsung smartphone by the UCICenter for Machine Learning and Intelligent Systems.  THe variables include tri-axial singals representing physical observations of subjects performing 6 different activities. As noted above, the variables included in the final tidy data set are only means and standard deviations of the recorded parameters.  Including the subject and activity columns, the final data set has 180 observations (rows) and 81 variables (columns).  Rather than describe each variable here, I will point you to the features_info.txt file in the 'UCI HAR Dataset' folder that is included in made available once the original file is unzipped.
