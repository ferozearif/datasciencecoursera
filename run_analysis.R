df_xtrain = read.table("X_train.txt")
df_ytrain = read.table("y_train.txt")
df_xtest = read.table("X_test.txt")
df_ytest = read.table("y_test.txt")
df_features = read.table("features.txt")
df_subject_test = read.table("subject_test.txt")
df_subject_train = read.table("subject_train.txt")
df_activity <- read.table("activity_labels.txt")
#Setting the Column Names to Features
colnames(df_xtrain) <- df_features$V2
colnames(df_xtest) <- df_features$V2
#Adding the activity column to the dataset
df_xtrain1 <- cbind(df_ytrain, df_xtrain)
df_xtest1 <- cbind(df_ytest, df_xtest)
#Setting the column name to activity
colnames(df_xtrain1)[1] = "activity"
colnames(df_xtest1)[1] = "activity"
#Adding the subject column to the dataset
df_xtrain1 <- cbind(df_subject_train, df_xtrain1)
df_xtest1 <- cbind(df_subject_test, df_xtest1)
#Setting the column name to subject
colnames(df_xtrain1)[1] = "subject"
colnames(df_xtest1)[1] = "subject"
#Combining the training and test datasets
df_merged <- rbind(df_xtest1, df_xtrain1)
#Selecting fields that are mean or std deviations
df_selfeatures <- subset(df_features, grepl("mean|std", tolower(df_features$V2)), sel = V2)
df_selfeatures$V2 <- as.character(df_selfeatures$V2)
df_selfeatures <- rbind("subject", "activity", df_selfeatures) #Including the subject and activity columns
#subsetting to get a dataframe with selected columns
df_mergedsub <- subset(df_merged, TRUE, sel = df_selfeatures$V2)
library(plyr)
#Calculating summary of each feature per user per activity
df_merged_grouped_sub <- ddply(df_mergedsub, .(subject, activity), colwise(mean))
#Replacing integer activity with activity descriptions
df_merged_grouped_sub$activity <- df_activity$V2[df_merged_grouped_sub$activity]
#Creating the tidy dataset
write.table(df_merged_grouped_sub, file = "tidy.txt", sep = ",", row.names=FALSE)