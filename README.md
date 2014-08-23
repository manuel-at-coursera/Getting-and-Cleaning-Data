Getting and Cleaning Data / Course Project
==========================================

The script run_analysis.R assumes that the folder "UCI HAR Dataset" resides in the same directory.

As per the course project description the R script does not include downloading nor unzipping the data set.

The following code can be used for those preparational steps:
___________________________________________________________________________________________________________
* Set the working directory. To do so, replace "foo/bar" by an appropriate path.
  * setwd("foo/bar")

* Create variable with the file URL
  * fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

* Download file to working directory
  * download.file(fileUrl, destfile = "rawData.zip")

* Unzip the downloaded file
  * unzip("rawData.zip")

___________________________________________________________________________________________________________

The run_analysis.R file itself contains a detailed step-by-step description.

In general, it does the following:

1) In total, six data files are loaded with read.table. For test and training each the following three files
   were loaded:
   * A subject file with one column which contains per row the number of the participant to whom that line 
     belongs (from 1 to 30). 
   * An activity file with one column which contains per row a number from 1 to 6, assigning the activity to 
     which that line of data belongs (referring to the feature file).
   * A feature file with many columns, containing the data described in the files "features_info.txt" and 
     "features.txt" within the folder "UCI HAR Dataset".
     
2) The subject, the activity and the feature file were combined column-wise with cbind. 
   This step was done separately for the test and training data.
   The resulting two files (testData and trainData) were combined row-wise with rbind into one file named allData.
   
3) As per the course project description, the tidy data set should contain only those feature columns with 
   mean values or the standard deviation. Via the feature labels those columns are easily identifiable, 
   as they contain "-mean()-" and "-std()-", respectively.
   * Therefore the feature labels were assigned to the column names of the allData file.
   * In addition, the first column was labelled "Subject" and the second column "Activity".
   * Finally, a subData file was extracted, containing only the relevant columns as per above.
   * The subData files contains 50 columns:
     * Two columns for row identification, Subject and Activity.
     * Eight different measurements:
        * tBodyAccMag
        * tGravityAccMag
        * tBodyAccJerkMag
        * tBodyGyroMag
        * tBodyGyroJerkMag
        * fBodyAccMag
        * fBodyBodyAccJerkMag
     * Per each of the eight measurements above six different sub-measures:
        * -mean()-X
        * -mean()-Y
        * -mean()-Z
        * -std()-X
        * -std()-Y
        * -std()-Z
        
4) To assigne the activity labels, the Activity column gets changed to class "factor".

5) Via the aggregate() function the mean is calculated for the columns 3 to 50 of the subData file.
   * The result is called tidyData.
   * During that step the column labels for the first two columns are lost (Subject and Activity).
   * As the column structure is the same, the column names of the  subData file are re-used and assigned
     to the column names of the tidyData file.
     
6) Finally, the tidyData is written to the file "GettingAndCleaningData_CourseProject_tidyData.txt".
