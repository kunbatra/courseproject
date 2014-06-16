

## SCript for the course project "Getting n cleaning data - John Hopkins"

##UNZIP file 
if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")){
        stop ("Source data/zip file not present!")
        }else {
                if(!file.exists("UCI HAR Dataset")) {
                        unzip("getdata-projectfiles-UCI HAR Dataset.zip")
                        }
               }

##Create dir if it doesnt exist
if(!file.exists("./mergeddata")) {dir.create("./mergeddata")}

###########Train data
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")

colnames(subjectTrain) <- c("subject")
colnames(yTrain) <- c("activity")
featureColnames <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
colnames(xTrain) <- featureColnames$V2

mergeddatatrain <- cbind(subjectTrain, yTrain, xTrain)

##########Test data
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt") 
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(subjectTest) <- c("subject")
colnames(yTest) <- c("activity")
colnames(xTest) <- featureColnames$V2

mergeddatatest <- cbind(subjectTest, yTest, xTest)


############### Merge Train and Test data into one file
mergeddata <- rbind(mergeddatatrain, mergeddatatest)

#####Extract only mean and std dev columns
mergeddata_select <- mergeddata[,c("subject","activity",
                grep('std\\(|mean\\(', names(mergeddata), value=TRUE))]

#### read activity labels file
actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## merge the activity desc file and the main data file 
## new column with desc introdcued
mergedData_labelled <- merge(mergeddata_select,actLabels, by.x= c("activity"),by.y = c("V1"))

## Change the colname of the new column to "activity-Desc" 
names(mergedData_labelled)[names(mergedData_labelled) == 'V2'] <- 'activity_desc'

## Bring the activity_desc column next to the activity column
mergedData_ordered <- mergedData_labelled[c(1,ncol(mergedData_labelled),3:ncol(mergedData_labelled)-1)]

## Make the variable names sane and label them accordingly
nospecialChars <- gsub("\\(|\\)|-","", names(mergedData_ordered))
meanCap <- gsub("mean","Mean", nospecialChars)
colnames(mergedData_ordered) <- meanCap

## write the tidey data set into target directory
write.table(mergedData_ordered, file = "./mergeddata/tidy_data.txt")

## Final part - reshaping and calculating mean of cols
library(reshape2)

## melt the data with activity and subject as ids
mergeMelt <- melt(mergedData_ordered, 
                  id=c("activity_desc","subject"),
                  measure.vars=
        names(mergedData_ordered)[4:length(names(mergedData_ordered))])

##dcast the tidy melted data set with the mean of each column
mergedcast <- dcast(mergeMelt, formula = activity_desc+subject ~ variable, mean)        
## write final file 
write.table(mergedcast, file = "./mergeddata/mergeddata.txt")

