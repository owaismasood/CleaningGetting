#REading Activity Labels

featureLabels   <- read.table('activity_labels.txt' , , stringsAsFactors = FALSE)
names(featureLabels) <- c('activity.id','Activity')

#Reading RAW *TEST* DataFiles

rawTestX   <- read.table('test/X_test.txt')
rawTestY   <- read.table('test/y_test.txt')
rawTestSubject <- read.table('test/subject_test.txt')

cumTest <- cbind(rawTestSubject,rawTestY,rawTestX)

#Reading RAW *TRAINING* DataFiles

rawTrainX   <- read.table('train/X_train.txt')
rawTrainY   <- read.table('train/y_train.txt')
rawTrainSubject <- read.table('train/subject_train.txt')

cumTraining <- cbind(rawTrainSubject,rawTrainY,rawTrainX)
combinedDataSet <- rbind(cumTest,cumTraining)

#Reading FEATURE Names

rawFeatureNames  <- read.table('features.txt', stringsAsFactors = FALSE)
rawColNames <- rawFeatureNames[,2]
rawColNames <- c('subject.id','activity.id',rawColNames)

#Assigning Labels to the Entire Data Frame 
names(combinedDataSet) <- rawColNames

#Subsetting the Mean and STd Colums
colIndex <- c(1L,2L,grep(c('mean'),rawColNames),grep(c('std'),rawColNames))
targetData <-  combinedDataSet[,colIndex]

#Consolidating the DATA
consolidated <- aggregate(requireData,by = list(requireData$subject.id,requireData$activity.id), FUN = 'mean')
consolidatedDataSet <- consolidated[,3:83]

#Applying Descritive Activity Names
mergedDataSet <- merge(consolidatedDataSet,featureLabels, all.x = TRUE )
consolidatedDataSet <- mergedDataSet[,c(2,82,3:81)]

#Applying Descriptive Variable Names
temp <-  names(consolidatedDataSet)
temp <- gsub('mean\\(\\)','MEAN',temp)
temp <- gsub('std\\(\\)','STANDARD DEVIATION',temp)
temp <- gsub('meanFreq\\(\\)','MEAN FREQUENCY',temp)
names(consolidatedDataSet) <- temp

#OUTPUTTING the WIDE TIDY DATA SET
write.table(consolidatedDataSet,'tidydata.txt',row.names = FALSE)