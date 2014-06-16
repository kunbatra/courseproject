#Readme file for the Data cleaning course project

## Generating the tidy data set

* The code for the file read and its cleaning and analysis is in run_analysis.R
* The code assumes that the zip file of the raw data "getdata-projectfiles-UCI HAR Dataset.zip" exists in the same directory as the run_analysis.R
* The R code then checks for the existence of the raw data zip file: if file exists, then proceed, otherwise stop
* The R code then creates a subdirectory "mergeddata" for the target files. If the directory already exists, then it moves on to the next line of code.
* The next step is to merge the train and test data into a single data set: mergeddata. This is done after matching the activity names with the dataset and also labelling the subject based on the subject file provided seprately.
* From the merged dataset, select only the columns which have 'mean' or 'std' in their column names, as that is the requirement of this step
* Finally, make the names of the merged dataset such that their readability is better. The steps followed here were: remove the bracket special characters and make the smallcase 'mean' to have uppercase first alphabet "M".
* Generate and write the tidy_data.txt file in the "mergeddata" folder


## Last part: 

* Melt and dcast the merged dataset based on activity and subject. Summarise by Mean of the columns.
* Write the second tidy file which has summary of means as "mergeddata.txt" in the mergeddata folder.
