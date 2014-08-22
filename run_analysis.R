
# Read test and training subjects into two separate data.frames
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           header = F, sep = "")
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                            header = F, sep = "")

# Read test and training activities into two separate data.frames
testActivities <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                             header = F, sep = "")
trainActivities <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                              header = F, sep = "")

# Read test and training features into two separate data.frames
testFeatures <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                           header = F, sep = "")
trainFeatures <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                            header = F, sep = "")





# Column bind all test e.g. training files in two separate files
# First column = subjects, second = activities, third until end = features (data)
testData <- cbind(testSubjects, testActivities, testFeatures)
trainData <- cbind(trainSubjects, trainActivities, trainFeatures)

# Row bind test and training data into one file
allData <- rbind(testData, trainData)





# Read the variable names for the data columns
featureLabels <- as.vector( read.table("./UCI HAR Dataset/features.txt", 
                                       header = F, sep = "")[,2] )

# Add labels for the subjects and activities to "featureLabels"
columnLabels <- append(as.vector(c("Subject", "Activity")), featureLabels)

# Assigne "columnLabels" to the column names of "allData"
colnames(allData) <- columnLabels

# Create vector which is "TRUE" for all columns containing "-mean()-" or 
# "-std()-" measures, plus "Subject" (first column) and "Activity" (second column)
mean <- grepl("-mean()-", colnames(allData), fixed=T)
std <- grepl("-std()-", colnames(allData), fixed=T)
selectedColumns <- mean | std
selectedColumns[1:2] <- T

# Create subset off "allData" which contains only those columns assigned TRUE 
# by "selectedColumns". 
subData <- allData[,selectedColumns]

# Clean column labels within subData file
colnames(subData) <- gsub("\\()", "", colnames(subData))
colnames(subData) <- gsub("-", "_", colnames(subData))

# Change second column to class "factor" and assigne activity labels
subData$Activity <- factor(subData$Activity, levels = c(1:6), 
                           labels = c("walking", "walking_upstairs", 
                                      "walking_downstairs", "sitting", 
                                      "standing", "laying"))





# Calculate mean values for all columns (except the first two columns, 
# "Subject" and "Activity"). Calculation is grouped by Subject and Activity.
tidyData <- aggregate(subData[,3:length(subData[1,])], 
                      by=list(subData$Subject, subData$Activity), mean)

# Re-assigne column names to tidyData file. 
# This is necessary because of the aggregate function().
# As column 1 and 2 were not aggregated, the column names for them got lost.
colnames(tidyData) <- colnames(subData)

# Write tidyData to working directory
write.table(tidyData, 
            file = "GettingAndCleaningData_CourseProject_tidyData.txt",  
            row.names = FALSE)
