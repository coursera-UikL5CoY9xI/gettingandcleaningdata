# Data setup
# We assume that the data has been downloaded (Dataset.zip) and extracted in this directory.
# It should have a subdir of "UCI HAR Dataset"
library(dplyr)

# Pull in activity lables so we can map
activity_lables = read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_lables)  <- c("id", "activity")

# Pull in information about column naming
features_src  <- read.table("UCI HAR Dataset/features.txt")
# reduce to table that only has -mean() and -std() entries in V2
# this will be used to reduce dataset to only mean and std deviation, below
features  <- features_src[features_src$V2 %like% "-mean\\()" | features_src$V2 %like% "-std\\()",]
rm(features_src)
# V1 becomes the columns we want to keep, V2 becomes the colNames of the new table
extractColIndex  <- features$V1
features[]  <- lapply(features, as.character) # de-factorize the column names
colNames  <- c("subject", "activity", features$V2)
newmap  <- data.frame(colNames)
rm(colNames)
# Write out new schema column naming.
write.table(newmap, file="subject_labels.txt", col.names = FALSE, quote=FALSE)

loadData  <- function(event) {
    X_file  <- paste("UCI HAR Dataset/", event, "/X_", event, ".txt", sep="")
    Y_file  <- paste("UCI HAR Dataset/", event, "/Y_", event, ".txt", sep="")
    subject_file  <- paste("UCI HAR Dataset/", event, "/subject_", event, ".txt", sep="")

    X  <- read.table(X_file)
    Y  <- read.table(Y_file)
    subj  <- read.table(subject_file)

    # 2. Extract only the measurements on the mean and standard deviation for each measurement.
    t  <- X[,extractColIndex]
    # 3. Use descriptive activity names to name the activities in the data set.
    Y  <- merge(Y, activity_lables, by.x = "V1", by.y="id")
    Y$V1  <- NULL
    t  <- cbind(subj, Y, t)
    #  4. Appropriately label the data set with descriptive variable names.
    colnames(t)  <- newmap$colNames
    return(t)
}


# 1. Merge the training and the test sets to create one data set.
TEST  <- loadData("test")
TRAIN  <- loadData("train")
SD  <- rbind(TEST, TRAIN) # combine sets
rm(TEST, TRAIN, extractColIndex) # remove temporaries
SD  <- SD[order(SD$subject, SD$activity),] # reorder by subject, then activity
rownames(SD)  <- seq_along(1:nrow(SD))  # reset the rownames to be an ordered numbered list
SD  <- group_by(SD, subject, activity)

# 5. From the data set above, create a second, independent tidy data set with the average of
# each variable for each activity and each subject.
AD  <- summarise_each(SD, funs(mean), 3:nrow(newmap))


## Output the final results
write.table(SD, file="subject_data.txt", row.names=FALSE)
write.table(AD, file="average_data.txt", row.names=FALSE)
