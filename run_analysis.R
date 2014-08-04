# requires all data in directory "UCI HAR Dataset" (under current directory)

# read in all nessicary files:
path <- "UCI HAR Dataset\\"
fname <- paste0(path, "activity_labels.txt")
activities <- read.table(fname)

fname <- paste0(path, "features.txt")
features <- read.table(fname)

fname <- paste0(path, "test\\subject_test.txt")
subject_test <- as.vector(read.table(fname)[[1]])

fname <- paste0(path, "test\\X_test.txt")
X_test <- read.table(fname)

fname <- paste0(path, "test\\y_test.txt")
y_test <- as.vector(read.table(fname)[[1]])

fname <- paste0(path, "train\\subject_train.txt")
subject_train <- as.vector(read.table(fname)[[1]])

fname <- paste0(path, "train\\X_train.txt")
X_train <- read.table(fname)

fname <- paste0(path, "train\\y_train.txt")
y_train <- as.vector(read.table(fname)[[1]])

# combine test and train sets (test is first, then train)
subject <- c(subject_test,subject_train)
y <- c(y_test, y_train) 
X <- rbind(X_test[1:dim(X_test)[1],1:dim(X_test)[2]], X_train[1:dim(X_train)[1],1:dim(X_train)[2]])

# add columns for subject and activity code in data frame
X <- cbind(subject,y,X)
colnames(X)[2] = "activityCode"

X <- merge(X,activities,by.x="activityCode",by.y="V1",all=T)
colnames(X)[564] = "activity"
X <- X[,c(2,1,564,3:563)]

# features data frame holds feature names for each measurement column in X
colnames(X)[4:564] <- as.vector(features[[2]])

# clean up, remove all individual sets no longer needed
remove(subject_test,subject_train,y_test,y_train,X_test,X_train,features,y,subject,fname,path,activities) 

# All data now in X starting with column "subject"
# , then "activityCode", "activity", "tBodyAcc-mean()-X", ..., "angle(Z,gravityMean)"

# Keep only columns of mean or std. deviation (except for subject, activity and activityCode which are kept)
# regex: all strings that contains mean (not followed by F to exclude meanFreq) or std
X<-X[,c(1,2,3,grep("mean[^F]|std",colnames(X)))]

# Compute mean for every column of X, except for subject, act.Code and activity,
# group by subject, activityCode and activity
tidyData <- aggregate(as.matrix(X[4:69])~subject+activityCode+activity,data=X,FUN="mean")


# fix column header names:
n<-names(tidyData)[4:dim(tidyData)[2]]
n<-gsub("^(f|t)", "", n)
n<-gsub("\\(\\)", "", n)
n<-gsub("-", " ", n)

# function capitalize, see http://stackoverflow.com/questions/6364783/capitalize-the-first-letter-of-both-words-in-a-two-word-string
capitalize <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

n<-as.vector(sapply(n,capitalize))
n<-gsub(" ", "_", n)
names(tidyData)[4:dim(tidyData)[2]]<-n


# sort table by subject and activityCode
tidyData <- tidyData[order(tidyData[1],tidyData[2]),]
rownames(tidyData) <- NULL
tidyData[2]<-NULL
write.table(tidyData, "tidyData.txt") 


