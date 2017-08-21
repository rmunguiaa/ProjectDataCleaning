## PROJECT DATA GETTING AND CLEANING COURSE
## DEVELOPER: Roberto Munguia


## I: GET AND MERGE DATA

  ## I.1. Download and unzip the dataset
  ## You have to Install.packages for the next packages: reshape2, data.table

  library(reshape2)
  setwd("C:/Users/Roberto/Documents/Data Science Specialization/C3 Data Cleaning/week 4/Project")

  filename <- "dataset.zip"

  ## Download and unzip the dataset:
    if (!file.exists(filename)){
      fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
      download.file(fileURL, filename, method="curl")
    }  
    if (!file.exists("UCI HAR Dataset")) { 
      unzip(filename) 
    }


  ## I.2. Loading data sets.

    library(plyr)
    library(data.table)

    TabsubjectTrain = read.table('./train/subject_train.txt',header=FALSE)
    TabxTrain = read.table('./train/X_train.txt',header=FALSE)
    TabyTrain = read.table('./train/y_train.txt',header=FALSE)

    TabsubjectTest = read.table('./test/subject_test.txt',header=FALSE)
    TabxTest = read.table('./test/X_test.txt',header=FALSE)
    TabyTest = read.table('./test/y_test.txt',header=FALSE)

  ## I.3. Now we combine and organize raw data sets into one

    xDataSet <- rbind(TabxTrain, TabxTest)head(
    yDataSet <- rbind(TabyTrain, TabyTest)
    subjectDataSet <- rbind(TabsubjectTrain, TabsubjectTest)

## II. EXTRACTION ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DESVIATION FOR EACH MEASUREMENT

    xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
    names(xDataSet_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
    View(xDataSet_mean_std)
    dim(xDataSet_mean_std)

## III. USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET

    yDataSet[, 1] <- read.table("activity_labels.txt")[yDataSet[, 1], 2]
    names(yDataSet) <- "Activity"
    View(yDataSet)

## IV. PUT APPROPRIATE LABEL TO DATA SET WITH DESCRIPTIVE ACTIVITY NAMES

    names(subjectDataSet) <- "Subject"
    summary(subjectDataSet)

  ## IV.1 Organazing and combining all data sets into single one
    singleDataSet <- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)

  ## IV.2 Defining descriptive names for all variables.

    names(singleDataSet) <- make.names(names(singleDataSet))
    names(singleDataSet) <- gsub('Acc',"Acceleration",names(singleDataSet))
    names(singleDataSet) <- gsub('GyroJerk',"AngularAcceleration",names(singleDataSet))
    names(singleDataSet) <- gsub('Gyro',"AngularSpeed",names(singleDataSet))
    names(singleDataSet) <- gsub('Mag',"Magnitude",names(singleDataSet))
    names(singleDataSet) <- gsub('^t',"TimeDomain.",names(singleDataSet))
    names(singleDataSet) <- gsub('^f',"FrequencyDomain.",names(singleDataSet))
    names(singleDataSet) <- gsub('\\.mean',".Mean",names(singleDataSet))
    names(singleDataSet) <- gsub('\\.std',".StandardDeviation",names(singleDataSet))
    names(singleDataSet) <- gsub('Freq\\.',"Frequency.",names(singleDataSet))
    names(singleDataSet) <- gsub('Freq$',"Frequency",names(singleDataSet))
    View(singleDataSet)

## V. CREATEING A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE 
##    FOR EACH ACTIVITY AND EACH SUBJECT

    names(singleDataSet)
    DataSet2<-aggregate(. ~Subject + Activity, singleDataSet, mean)
    DataSet2<-DataSet2[order(DataSet2$Subject,DataSet2$Activity),]
    write.table(DataSet2, file = "tidydata.txt",row.name=FALSE)
