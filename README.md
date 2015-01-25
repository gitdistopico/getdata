# Getting and Cleaning Data Course Project

First part of the code is basically a setup, it creates some folders and sets the proper file name so it works if we manually download the data to the working directory or if not automatically downloads the needed data file.

### 1. Merges the training and the test sets to create one data set.
Based on the README.txt provided with the data set we can see that the training and test data are included in the files `train/X_train.txt` and `test/X_test.txt` respectively, so we read them to the variables `train.data` and `test.data`.

Also as the column names are located in a different file `features.txt` we also assign the data to the variable `feature.name` so that we can make use this to have proper column names.

The merge of the data, as they have the same column structure is done simply by binding both data frames together with `rbind`, now that we have the complete data set we also set the column names we retrieved from the `features.txt` file.

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Based on the description we see on the `features_info.txt` we can safely assume that the measurements for the mean and standard deviation are the ones which includes the patterns `mean()` and `std()` and as they always appear after the signal name we can use `-mean()` and `-std()` to safely detect those columns, with that in mind we use the `grep` function with the following regular expression `"-mean\\(\\)|-std\\(\\)"` to detect the columns.

With those columns properly detected we restrict the data set to only contain those columns.

### 3. Uses descriptive activity names to name the activities in the data set
As documented on the `README.txt` from the database we have the name of the activities and their respective label in the file `activity_labels.txt`, also we have to retrieve the activity from a different file, as it's not included in the data we've already collected.

Notice also that we include the subject data, as it's done in the very same pattern and the data will be required in a following step.

### 4. Appropriately labels the data set with descriptive variable names. 
To enhance the readability some changes were made to the variable names. Those are the following:
- The type of domain frequency is explicitly set to `"time"` and `"frequency"` instead of the original `t` and `f`.
- On the same page `Acc` and `Gyro` became `Acceleration` and `Velocity`, ideally we should specify that those are the `Linear acceleration` and `Angular velocity`, but given the data those distinctions could be implied.
- `Mag` was also changed to a more meaningful `Magnitude` and the axis `X`, `Y` and `Z` were converted to lowercase.
- Also should be noted that we explicitly separated the possible variables `type`, `domain`, `measure` and `axis` by a `.`.
- The unnecessary parenthesis were also removed.

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Now there were several possible ways to interpret the ambiguity of the phrase and also different ways to consider the data tidy or not, as we don't really now the application we can't for sure decide what are the meaningful variables. Considering the data is tidy based on the problem it tries to solve (see  Hadley Wickham's paper) we will consider that the original columns are the meaningful variables.

With that consideration we use the `dplyr` package to `group_by` and `summarize` the data according to the request and save those to the file.
