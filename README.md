DataCleaning
============

Repo for Getting and Cleaning Data class via Coursera

### Run_analysis.R script
Assumptions: Working directory contains the unzipped data folder containing UCI HAR Dataset, which contains train and test folders and all other data

####Required:
* Samsung data from UCI with data folder in working directory
* The reshape2 package

####Output
* "combined" data frame with all data in a frame
* "mean_STD_comb" data frame with only column names that contain the string "std" or "mean("
* "avg_df" data frame which has each activity and subject pair's average reading.

####Procedure:
1. Load the test and train files into six separate data frames
2. Load the titles of the columns into another data frame
3. Load the vector consisting of the labels
4. For each frame in test and train, set the column names
5. Combine the frames to have two sets, train and test
6. Combine the train and test frame to get the full data frame, named combined
7. Clean up the unnecessary data frames, essentially all but combined and labels.
8. Make a new data frame that consists only of the column names with "mean(", "std", "Activity", or "Subject"
9. Rename the Activity name to match what is given in labels
10. Melt the data by Activity and Subject
11. Rename the columns to lower case and no special characters
12. Dcast the data frame with means as element, (activity, subject)-pair as column title and the measure as row title.
13. Change the activity number to activity name.
14. Write outputs to files
