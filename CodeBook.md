The following steps (properly documented along the code presented in file "run_analysis.R") were followed in order to obtain the final script.

1.- Setting up libraries to be used.  In this case: dplyr and tidyr

2.- Setting working directory in my PC.

3.- Reading raw data from source, using "read.csv" function.

4.- Preparing the following data sets, before merging them into the required unified data set:

  a) "features" data set:
    a.1) Splitting numbers from labels (using the "separate" function, setting sep = " ") and adding descriptive variable names.
    a.2) Transforming "featurenumber" variable into numbers and "feature" variable into characters, using functions "as.integer" and "as.character".
    a.3) Re-naming activities, without "-", "," nor "()", using the "gsub" function.

  b) "activity labels" data set:
    b.1) Splitting numbers from labels (using the "separate" function, setting sep = " ") into 2 variables, and adding descriptive variable names to each one.
    b.2) Transforming "activitynumer" variable into numbers, using function "as.integer".
    b.3) Re-naming activities, without "_", using the "gsub" function.

  c) "subject" data sets:
    c.1) Re-naming variables with descriptive names, using function "names".
    c.2) Distinguishing each subject set by adding the variable "partitionset" (all values = "test" for the "partitionset" variable in subject_test dataset, and values = " train" for the subject_train dataset).
    c.3) Adding an extra variable with each set's original order (variable "order", with values ranging from 1 to the number of lines of each dataset).  Used the "mutate" function.
    c.4) Re-ordering variables, with order variable on the left of both sets.  Used the "select" function.

  d) "x_test" and "x_train" sets:
    d.1) Naming variables for both sets, from features_final$feature vector (already obtained in previous step a), using "names" function.
    d.2) Adding variable with each set's original order (as in c.3).
    d.3) Re-ordering variables, as in c.4).

  e) "y_test" and "y_train" sets:
    e.1) Naming variables with descriptive name ("activitynumber").
    e.2) Adding variable with each set's original order, as in c.3).
    e.3) Re-ordering variables, as in c.4).

5) Merging previously prepared sets (as described on step 4), to create the required unified data set.

  a) Merging "activity labels" set to "y_test" and "y_train" sets, using "merge" function, by "activitynumber" variable and sort = FALSE.  The resulting sets were named "y_test_final" and "y_train_final".
    a.1) Ordering "y_test_final" and "y_train_final" sets by original values.
    a.2) Re-ordering variables, with "order" variable on the left of both y_test_final and y_train_final sets, using "select" function.

  b) Merging "subject" data sets to "y_test_final" and "y_train_final" sets.
    b.1) Merging by "order" variable, common to all sets, using "merge" function and sort = FALSE.
  c) Merging "y_test_final" and "y_train_final" sets, to "x_test" and "x_train" sets, by the "order" variable (common to all of them).

  d) Finally, binding the resulting sets from 5.c into the required unified data set.  As seen previously, the resulting set includes both activity and subject variables, required for the final tidy data set.

6) Creating second, independent tidy data set.

  a) Creating a vector that identifies variables containing either "mean()" or "std()" strings. Function used: "grep".  Final vector called "idvector".

  b) Selecting the "mean" and "standard deviation" variables, using the "idvector" and the "select" funcion, fron the unified data set obtained in step 5.

  c) Converting to numeric both the "mean" and "std" variables obtained from previous step, using "lapply" combined with "as.numeric" functions.

  d) Grouping the resulting second data set, by "subject" and "activity" variables, using "group_by" function.

  e) Obtaining final second data set, by summarizing it using "summarize_if" function, combined with "mean" function.

  f) Exporting final second data set ("tidydataset.txt") to my pc, using the "write.table" function and row.names = FALSE.