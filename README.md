GettingAndCleaningData
======================

GettingAndCleaningData Coursera Project

The script "run_analysis.R" works as following:

1. Reads in all the necessary files from the UCI HAR Datasets.
2. Merges the training and the test sets.
3. Add columns for subject and activity
4. Removes columns not containing mean or std. deviation (except for columns subject, activity and     activityCode which are kept)
5. Computes mean for every measurement column, grouped by subject and activityCode / activity.
6. Reformats labels and activities with descriptive variable names 
7. Creates a new dataset with only the means from point 5 above. 
8. Sorts the new dataset by subject and activity
9. Stores the new dataset into "tidyData.txt".

The complete list of variables of in tidyData is available in "codeBook.txt".

