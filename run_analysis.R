# Importing the libraries            

            library(dplyr)
            library(qdap)

# To load Test and Train data
            traindata<- read.table('./train/X_train.txt')
            testdata<- read.table('./test/X_test.txt')
            trainsubject<- read.table("./train/subject_train.txt")
            testsubject<- read.table("./test/subject_test.txt")

# To name the test and train data
            
            features<- read.table('features.txt')
            names<-features$V2
            names(testdata)<- names
            names(traindata)<- names
            names(testsubject)<- c("SubjectID")
            names(trainsubject)<- c("SubjectID")
# merge dataset
            
            data<- rbind(traindata,testdata)
            subject<- rbind(trainsubject,testsubject)
            dim(data)
            data<- cbind(subject, data)
            dim(data)
            name<-names(data)

# Extract measurements by mean and Std
            
            r<-grepl("\\mean\\()|std()",name)
            final_data<- data[r]
            head(final_data)
            names(final_data)
            dim(final_data)

# Descriptive activity names to name the activities in the data set

            train_activity<- read.table('./train/y_train.txt')
            test_activity<- read.table('./test/y_test.txt')
            activity<- rbind(train_activity,test_activity)
            activity<- cbind(subject, activity)
            activity_labels<- read.table('activity_labels.txt')
            activities<- merge(activity,activity_labels, by='V1', all=F, sort = F)
            final_data<- cbind(final_data, activities)
            final_data
            names(final_data)
            a<- c("tBodyAcc","tGravityAcc","tBodyAccJerk","tBodyGyro","tBodyGyroJerk",
                  "tBodyAccMag","tGravityAccMag","fBodyAcc","fBodyAccJerk","fBodyGyro","fBodyAccMag","fBodyBodyAccJerkMag",
                  "fBodyBodyGyroMag","fBodyBodyGyroJerkMag","-mean()","-std()","V1","V2")
            b<- c("TempBodyAcceleration","TempGravityAcceleration","TempBodyAccelerationJerk",
                  "TempBodyGyroscope","TempBodyGyroscopeJerk","TempBodyAccelerationMagnitude",
                  "TempGravityAcceleration","FrequencyBodyAcceleration","FrequencyBodyAccelerationJerk",
                  "FrequencyBodyGyroscope","FrequencyBodyAccelerationMagnitude","FrequencyBodyAccelerationJerkMagnitude",
                  "FrequencyBodyGyroscopeMagnitude","FrequencyBodyGyroscopeJerk","mean","std","ActivityCode","ActivityName")
            names(final_data)<- mgsub(a,b,names(final_data))
            names(final_data)

# Secondary data frame based on the Average value of each variable

            Mean<-lapply(final_data, mean)
            dataset1<- data.frame(Mean)
            
# Data set based on the average value of the each variable based on the activity

            data_final<- split(final_data,final_data$SubjectID,final_data$ActivityName)
            names(data_final)
            ActivityMean <- sapply(data_final, function(x) colMeans(select_if(x, is.numeric)))
            names(ActivityMean)
            dataset2<- data.frame(ActivityMean)
            head(dataset2)
            names(dataset2)
            dataset2['X30']
            dim(dataset2)
            library(data.table)
            dt<- t(dataset2)
            tidydata<- data.frame(dt)
            head(tidydata)
            names(tidydata)
            write.table(tidydata,"./tidydataset.txt", quote=F, sep="  ", col.names = TRUE, row.names = F)
            
            ?write.table
            