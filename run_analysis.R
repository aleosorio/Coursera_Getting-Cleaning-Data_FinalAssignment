## CALLING LIBRARIES TO BE USED

library(dplyr)
library(tidyr)

## SETTING WORKING DIRECTORY

setwd("C:/Users/lenovo/Documents/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/data")

## READING RAW DATA FROM SOURCE DIRECTORY IN PC, INTO WORKING DIRECTORY, WITH OBJECTS NAMED AFTER FILE NAMES

        ## FROM SOURCE
        activity_labels_raw <- read.csv2("~/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/activity_labels.txt", header = FALSE)
        features <- read.csv2("~/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/features.txt", header = FALSE)

        ## FROM SOURCE/ TEST
        subject_test <- read.csv2("~/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/test/subject_test.txt", header = FALSE)
        x_test <- read.csv2("~/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/test/X_test.txt", sep = "", header = FALSE)
        y_test <- read.csv2("~/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/test/y_test.txt", header = FALSE)

        ## FROM SOURCE/ TRAIN
        subject_train <- read.csv2("~/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/train/subject_train.txt", header = FALSE)
        x_train <- read.csv2("~/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/train/X_train.txt", sep = "", header = FALSE)
        y_train <- read.csv2("~/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/train/y_train.txt", header = FALSE)

## PREPARING SETS BEFORE MERGING

        ## PREPARING FEATURES SET

                ## Splitting numbers from labels and adding descriptive variable names
                features <- separate(features, "V1", c("featurenumber", "feature"), sep = " ")

                ## Transforming variables into numbers and characters
                features[,1] <- as.integer(features[,1])
                features[,2] <- as.character(features[,2])

                ## Re-naming activities, without "-", "," nor "()"
                features_final <- features
                features_final[,2] <- gsub("-", "", features_final[,2])
                features_final[,2] <- gsub(",", "", features_final[,2])
                features_final[,2] <- gsub("\\(", "", features_final[,2])
                features_final[,2] <- gsub("\\)", "", features_final[,2])

        ## PREPARING ACTIVITY LABELS SET

                ## Splitting numbers from labels and adding descriptive variable names
                activity_labels <- separate(activity_labels_raw, "V1", c("activitynumber", "activity"), sep = " ")

                ## Transforming activitynumer from characters into numbers
                activity_labels[,1] <- as.integer(activity_labels[,1])

                ## Re-naming activities, without "_"
                activity_labels[,2] <- gsub("_", "", activity_labels[,2])

        ## PREPARING SUBJECT SETS

                ## Renaming variables with descriptive names
                names(subject_test) <- "subjectnum"
                names(subject_train) <- "subjectnum"

                ## Distinguishing each subject set by adding the variable "partitionset"
                subject_test <- mutate(subject_test, partitionset = "test")
                subject_train <- mutate(subject_train, partitionset = "train")

                ## Adding variable with each set's original order
                subject_test <- mutate(subject_test, order = 1:nrow(subject_test))
                subject_train <- mutate(subject_train, order = 1:nrow(subject_train))

                ## Re-ordering variables, with order variable on the left of both sets
                subject_test <- select(subject_test, 3,1:2)
                subject_train <- select(subject_train, 3,1:2)

        ## PREPARING X_TEST AND X_TRAIN SETS

                ## Naming variables after features set
                names(x_test) <- features_final$feature
                names(x_train) <- features_final$feature

                ## Adding variable with each set's original order
                x_test <- cbind(x_test, order = 1:nrow(x_test))
                x_train <- cbind(x_train, order = 1:nrow(x_train))

                ## Re-ordering variables, with order variable on the left of both sets
                x_test <- x_test[, c(562, 1:561)]
                x_train <- x_train[, c(562, 1:561)]

        ## PREPARING Y_TEST AND Y_TRAIN SETS

                ##Naming variables with descriptive names
                names(y_test) <- "activitynumber"
                names(y_train) <- "activitynumber"

                ## Adding variable with each set's original order
                y_test <- mutate(y_test, order = 1:nrow(y_test))
                y_train <- mutate(y_train, order = 1:nrow(y_train))

                ## Re-ordering variables, with order variable on the left of both sets
                y_test <- select(y_test, 2:1)
                y_train <- select(y_train, 2:1)

## MERGING SETS REQUIRED TO CREATE UNIFIED DATA SET

        ## MERGING ACTIVITY LABELS SET TO Y_TEST AND Y_TRAIN SETS

                ## Merging by "activitynumber" variable, common to all sets
                y_test_final <- merge(y_test, activity_labels, by = "activitynumber", sort = FALSE)
                y_train_final <- merge(y_train, activity_labels, by = "activitynumber", sort = FALSE)

                ## Ordering y_test_final and y_train_final sets by original values
                y_test_final <- y_test_final[order(y_test_final$order),]
                y_train_final <- y_train_final[order(y_train_final$order),]

                ## Re-ordering variables, with order variable on the left of both y_test_final and y_train_final sets
                y_test_final <- select(y_test_final, 2:1,3)
                y_train_final <- select(y_train_final, 2:1,3)

        ## MERGING SUBJECTS SETS TO Y_TEST_FINAL AND Y_TRAIN_FINAL SETS

                ## Merging by "order" variable, common to all sets
                y_test_final <- merge(subject_test, y_test_final, by = "order", sort = FALSE)
                y_train_final <- merge(subject_train, y_train_final, by = "order", sort = FALSE)

        ## MERGING Y_TEST_FINAL AND Y_TRAIN_FINAL SETS TO X_TEST AND X_TRAIN SETS

                ## Merging by "order" variable, common to all sets
                test_final <- merge(y_test_final, x_test, by = "order", sort = FALSE)
                train_final <- merge(y_train_final, x_train, by = "order", sort = FALSE)

## BINDING SETS INTO REQUIRED UNIFIED DATA SET

        ## BINDING TEST_FINAL AND TRAIN_FINAL SETS
        unified_data <- bind_rows(test_final, train_final)

        ## ELIMINATING REDUNDANT "ORDER" VARIABLE FROM UNIFIED DATA SET
        unified_data <- select(unified_data, -1)

## CREATING SECOND, INDEPENDENT TIDY DATA SET

        ## CREATING VECTOR THAT IDENTIFIES "MEAN()" AND "STD()" VARIABLES TO SELECT FROM UNIFIED DATA SET
        idvector_mean <- grep("mean()", features[,2], fixed = TRUE)
        idvector_std <- grep("std()", features[,2], fixed = TRUE)
        idvector <- c(idvector_mean, idvector_std)
        idvector <- sort(idvector) + 4

        ## SELECTING MEAN AND STANDARD DEVIATION VARIABLES FROM UNIFIED DATA SET
        second_data <- select(unified_data, 1:4,idvector)

        ## CONVERTING TO NUMERIC BOTH "MEAN" AND "STD" VARIABLES OF SECOND_DATA SET
        second_data[,5:70] <- lapply(second_data[,5:70], as.numeric)

        ## GROUPING SECOND DATA SET BY SUBJECT AND ACTIVITY VARIABLES
        second_data_final <- group_by(second_data, subjectnum, activitynumber, activity)

        ## OBTAINING FINAL SECOND DATA SET BY SUMMARIZING IT BY REMAINING NUMERIC VARIABLES
        second_data_final <- summarize_if(second_data_final, .predicate = function(x) is.numeric(x), .funs = funs(mean="mean"))

## EXPORTING FINAL SECOND DATA SET TO MY PC

write.table(second_data_final, "~/MAO/Pega/Aprendizaje/R/Getting Cleaning Data/PeerGradedAssignment_Dataset/data/tidydataset.txt", row.names = FALSE)
