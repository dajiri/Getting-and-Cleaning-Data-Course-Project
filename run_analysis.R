
#downloading file 
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
#trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
#Content type 'application/zip' length 62556944 bytes (59.7 MB)
#unzip data
unzip(zipfile="./data/Dataset.zip",exdir="./data")
#defining path
path_folder <- file.path("./data" , "UCI HAR Dataset")
list_files <- list.files(path_folder, recursive = T)
list_files
#[1] "activity_labels.txt"                         
#[2] "features.txt"                                
#[3] "features_info.txt"                           
#[4] "README.txt"                                  
#[5] "test/Inertial Signals/body_acc_x_test.txt"   
#[6] "test/Inertial Signals/body_acc_y_test.txt"   
#[7] "test/Inertial Signals/body_acc_z_test.txt"   
#[8] "test/Inertial Signals/body_gyro_x_test.txt"  
#[9] "test/Inertial Signals/body_gyro_y_test.txt"  
#[10] "test/Inertial Signals/body_gyro_z_test.txt"  
#[11] "test/Inertial Signals/total_acc_x_test.txt"  
#[12] "test/Inertial Signals/total_acc_y_test.txt"  
#[13] "test/Inertial Signals/total_acc_z_test.txt"  
#[14] "test/subject_test.txt"                       
#[15] "test/X_test.txt"                             
#[16] "test/y_test.txt"                             
#[17] "train/Inertial Signals/body_acc_x_train.txt" 
#[18] "train/Inertial Signals/body_acc_y_train.txt" 
#[19] "train/Inertial Signals/body_acc_z_train.txt" 
#[20] "train/Inertial Signals/body_gyro_x_train.txt"
#[21] "train/Inertial Signals/body_gyro_y_train.txt"
#[22] "train/Inertial Signals/body_gyro_z_train.txt"
#[23] "train/Inertial Signals/total_acc_x_train.txt"
#[24] "train/Inertial Signals/total_acc_y_train.txt"
#[25] "train/Inertial Signals/total_acc_z_train.txt"
#[26] "train/subject_train.txt"                     
#[27] "train/X_train.txt"                           
#[28] "train/y_train.txt"                           


#Read data from the files into the variables

#Activity
DataActivity_Test  <- read.table (file.path (path_folder, "test" , "Y_test.txt" ), header = F)
DataActivity_Train <- read.table (file.path (path_folder, "train", "Y_train.txt"), header = F)

#Subject
DataSubject_Test  <- read.table ( file.path( path_folder, "test" , "subject_test.txt"), header = F)
DataSubject_Train <- read.table ( file.path( path_folder, "train", "subject_train.txt"), header = F)

#Features
DataFeatures_Test  <- read.table (file.path (path_folder, "test" , "X_test.txt" ), header = F)
DataFeatures_Train <- read.table (file.path (path_folder, "train", "X_train.txt"), header = F)

#Metadata
Features_Names <- read.table(file.path(path_folder, "features.txt"),head=F)
Activity_Labels <- read.table(file.path(path_folder, "activity_labels.txt"),head=F)

#Looking at data
str(DataActivity_Test)
str(DataActivity_Train)
str(DataSubject_Test)
str(DataSubject_Train)
str(DataFeatures_Test)
str(DataFeatures_Train)

#Looking at metadata
str(Features_Names)
str(Activity_Labels)

#Binding data by rows
Data_Activity <- rbind (DataActivity_Train, DataActivity_Test)
Data_Subject <- rbind (DataSubject_Train, DataSubject_Test)
Data_Features <- rbind (DataFeatures_Train, DataFeatures_Test)

#Naming the columns
names(Data_Activity)<- c("Activity")
names(Data_Subject)<-c("Subject")
colnames(Data_Features) <- t(Features_Names[2])

#1)Merging by columns to get all data together in one dataset
Subject_Activity <- cbind (Data_Subject, Data_Activity)
Dataset <- cbind (Data_Features, Subject_Activity)
dim(Dataset)
#[1] 10299   563


#2)Extracts only the measurements on the mean and standard deviation
#for each measurement

#Extract the column indices that have either mean or std in them.
Columns_Mean_STD <- grep(".*Mean.*|.*Std.*", names(Dataset), ignore.case=T)

#Add activity and subject columns to the list 
Required_Columns <- c(Columns_Mean_STD, 562, 563)
#Subset the data frame Dataset by requiredColumns
Subset_Data <- Dataset[,Required_Columns]
dim(Subset_Data)
#[1] 10299    88


#3)Uses descriptive activity names to name the activities in the data set

#The activity field in Subset_Data is defined as numeric.
#We have to change its class to character so that it can accept activity names.
#The activity labels are taken from metadata

Subset_Data$Activity <- as.character(Subset_Data$Activity)
for (i in 1:6){
  Subset_Data$Activity[Subset_Data$Activity == i] <- as.character(Activity_Labels[i,2])
}
#We have to factorize the activity variable, once the activity labels are updated.
Subset_Data$Activity <- as.factor(Subset_Data$Activity)

#4)Appropriately labels the data set with descriptive variable names
names(Subset_Data)
#[1] "tBodyAcc-mean()-X"                    "tBodyAcc-mean()-Y"                   
#[3] "tBodyAcc-mean()-Z"                    "tBodyAcc-std()-X"                    
#[5] "tBodyAcc-std()-Y"                     "tBodyAcc-std()-Z"                    
#[7] "tGravityAcc-mean()-X"                 "tGravityAcc-mean()-Y"                
#[9] "tGravityAcc-mean()-Z"                 "tGravityAcc-std()-X"                 
#[11] "tGravityAcc-std()-Y"                  "tGravityAcc-std()-Z"                 
#[13] "tBodyAccJerk-mean()-X"                "tBodyAccJerk-mean()-Y"               
#[15] "tBodyAccJerk-mean()-Z"                "tBodyAccJerk-std()-X"                
#[17] "tBodyAccJerk-std()-Y"                 "tBodyAccJerk-std()-Z"                
#[19] "tBodyGyro-mean()-X"                   "tBodyGyro-mean()-Y"                  
#[21] "tBodyGyro-mean()-Z"                   "tBodyGyro-std()-X"                   
#[23] "tBodyGyro-std()-Y"                    "tBodyGyro-std()-Z"                   
#[25] "tBodyGyroJerk-mean()-X"               "tBodyGyroJerk-mean()-Y"              
#[27] "tBodyGyroJerk-mean()-Z"               "tBodyGyroJerk-std()-X"               
#[29] "tBodyGyroJerk-std()-Y"                "tBodyGyroJerk-std()-Z"               
#[31] "tBodyAccMag-mean()"                   "tBodyAccMag-std()"                   
#[33] "tGravityAccMag-mean()"                "tGravityAccMag-std()"                
#[35] "tBodyAccJerkMag-mean()"               "tBodyAccJerkMag-std()"               
#[37] "tBodyGyroMag-mean()"                  "tBodyGyroMag-std()"                  
#[39] "tBodyGyroJerkMag-mean()"              "tBodyGyroJerkMag-std()"              
#[41] "fBodyAcc-mean()-X"                    "fBodyAcc-mean()-Y"                   
#[43] "fBodyAcc-mean()-Z"                    "fBodyAcc-std()-X"                    
#[45] "fBodyAcc-std()-Y"                     "fBodyAcc-std()-Z"                    
#[47] "fBodyAcc-meanFreq()-X"                "fBodyAcc-meanFreq()-Y"               
#[49] "fBodyAcc-meanFreq()-Z"                "fBodyAccJerk-mean()-X"               
#[51] "fBodyAccJerk-mean()-Y"                "fBodyAccJerk-mean()-Z"               
#[53] "fBodyAccJerk-std()-X"                 "fBodyAccJerk-std()-Y"                
#[55] "fBodyAccJerk-std()-Z"                 "fBodyAccJerk-meanFreq()-X"           
#[57] "fBodyAccJerk-meanFreq()-Y"            "fBodyAccJerk-meanFreq()-Z"           
#[59] "fBodyGyro-mean()-X"                   "fBodyGyro-mean()-Y"                  
#[61] "fBodyGyro-mean()-Z"                   "fBodyGyro-std()-X"                   
#[63] "fBodyGyro-std()-Y"                    "fBodyGyro-std()-Z"                   
#[65] "fBodyGyro-meanFreq()-X"               "fBodyGyro-meanFreq()-Y"              
#[67] "fBodyGyro-meanFreq()-Z"               "fBodyAccMag-mean()"                  
#[69] "fBodyAccMag-std()"                    "fBodyAccMag-meanFreq()"              
#[71] "fBodyBodyAccJerkMag-mean()"           "fBodyBodyAccJerkMag-std()"           
#[73] "fBodyBodyAccJerkMag-meanFreq()"       "fBodyBodyGyroMag-mean()"             
#[75] "fBodyBodyGyroMag-std()"               "fBodyBodyGyroMag-meanFreq()"         
#[77] "fBodyBodyGyroJerkMag-mean()"          "fBodyBodyGyroJerkMag-std()"          
#[79] "fBodyBodyGyroJerkMag-meanFreq()"      "angle(tBodyAccMean,gravity)"         
#[81] "angle(tBodyAccJerkMean),gravityMean)" "angle(tBodyGyroMean,gravityMean)"    
#[83] "angle(tBodyGyroJerkMean,gravityMean)" "angle(X,gravityMean)"                
#[85] "angle(Y,gravityMean)"                 "angle(Z,gravityMean)"                
#[87] "Subject"                              "Activity" 

#By examining Subset_Data,  the following abbreviations can be replaced for:
  
#"Acc" can be replaced with Acceleration
#"Gyro" can be replaced with AngularVelocity
#"BodyBody" can be replaced with Body
#"Mag" can be replaced with Magnitude
#"f" can be replaced with Frequency
#"t" can be replaced with Time

names(Subset_Data)<-gsub("Acc", "Acceleration-", names(Subset_Data))
names(Subset_Data)<-gsub("Gyro", "Angular-Velocity-", names(Subset_Data))
names(Subset_Data)<-gsub("BodyBody", "Body-", names(Subset_Data))
names(Subset_Data)<-gsub("Mag", "Magnitude-", names(Subset_Data))
names(Subset_Data)<-gsub("^t", "Time-", names(Subset_Data))
names(Subset_Data)<-gsub("^f", "Frequency-", names(Subset_Data))
names(Subset_Data)<-gsub("tBody", "Time-Body-", names(Subset_Data))
names(Subset_Data)<-gsub("-mean()", "Mean-", names(Subset_Data), ignore.case = T)
names(Subset_Data)<-gsub("-std()", "Standard-Desviation-", names(Subset_Data), ignore.case = T)
names(Subset_Data)<-gsub("-freq()", "Frequency-", names(Subset_Data), ignore.case = T)
names(Subset_Data)<-gsub("angle", "Angle-", names(Subset_Data))
names(Subset_Data)<-gsub("gravity", "Gravity-", names(Subset_Data))

names(Subset_Data)

#5)From the data set in step 4, creates a second, independent 
#tidy data set with the average of each variable for each activity
#and each subject


install.packages("dplyr")
library(dplyr)
#We create tidyData as a dataset with average for each activity and subject.
#Then, we order the entities in tidyData and write it into data file called Tidy.txt 
#that contains the processed data.
Tidy_Data <- aggregate(. ~Subject + Activity, Subset_Data, mean)
Tidy_Data <- Tidy_Data[order(Tidy_Data$Subject,Tidy_Data$Activity),]
dim(Tidy_Data)
#[1] 180  88
write.table(Tidy_Data, file = "tidydata.txt", row.name=FALSE)


