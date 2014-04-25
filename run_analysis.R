# Load in the test and train files. We have the data, the
# response and the subjects

test_main = read.table("data/UCI HAR Dataset/test/X_test.txt")
test_labels = read.table("data/UCI HAR Dataset/test/y_test.txt")
test_sub = read.table("data/UCI HAR Dataset/test/subject_test.txt")
train_main = read.table("data/UCI HAR Dataset/train/X_train.txt")
train_labels = read.table("data/UCI HAR Dataset/train/y_train.txt")
train_sub = read.table("data/UCI HAR Dataset/train/subject_train.txt")

# Load in the titles of the columns. The first column is
# not needed as it is an enumeration
features = read.table("data/UCI HAR Dataset/features.txt")[,2]

# Read in the labels of the factors. The first column is
# not needed as it is an enumeration
labels = as.vector(read.table("data/UCI HAR Dataset/activity_labels.txt")[,2])

# Set the names of the data frame.
names(train_main) = features
names(test_main) = features

names(train_labels) = "Activity"
names(test_labels) = "Activity"

names(test_sub) = "Subject"
names(train_sub) = "Subject"

# Do a column bind of the sample data, the activity and
# the Subject columns to make two big data frames
train = cbind(train_main, train_labels, train_sub)
test = cbind(test_main, test_labels, test_sub)

# Row bind the training and test set to get one full
# data frame
combined = rbind(train, test)

# Clean up
rm(features, train, train_main, train_labels, train_sub, test, test_labels, test_main, test_sub)

# Make a new data frame which consists of the combined
# data frame with column names matching either
# [something]std[something] or 
# [something]mean([something] or
# "Activity" or "Subject", where mean( is the literal
# and [something] means anything. This was done to prevent
# the column meanFreq from showing
mean_STD_comb = combined[colnames(combined[grep(".*std.*|.*mean\\(.*|Activity|Subject", colnames(combined))])]


# For loop to set each enumerated activity to a more useful name
# The names were taken from the labels data frame
# First loop goes throught every element in the activity
# The nested loop loops through all 6 possibilities
# The conditional checks for a match and updates in case
for(i in seq(along=mean_STD_comb$Activity)) {
  for (j in 1:6){
    if (mean_STD_comb$Activity[i] == j) {
      mean_STD_comb$Activity[i] = labels[j]
    }
  }
}



# Melt the combined data frame with id. Then change the
# names to lower and remove special characters
# Decast the frame as a variable with the means
require(reshape2)
comb_melt = melt(combined, id.vars = c("Activity", "Subject"), measure.vars = grep(".*std.*|.*mean\\(.*", colnames(combined)))
names(comb_melt) <- tolower(gsub("\\-|\\(|\\)", "", names(comb_melt)))
avg_df = dcast(comb_melt, variable ~ ..., mean)

# Change the column names to something more readable
# The result of this is a data frame with column names
# [Activity]_[Subject number]
for (l in 1:6) {
  temp = grep(paste("^", l, sep=""), names(avg_df))
  names(avg_df) <- gsub(paste("^", l, sep = ""), labels[l], names(avg_df))
}

# Clean up
rm(i, j, l, temp, comb_melt, labels)

# Write to files
write.table(avg_df, "means_vs_actSub.txt")
write.table(combined, "combined.txt")
write.table(mean_STD_comb, "mean_STD_comb.txt")