# Getting and Cleaning Data 

Starting from data sourced at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
data is tidyied and restored.

The following controlled files make up the processing:

* README.md      : This file
* run_analysis.R : The core dataprocessing file
* codebook.txt   : Explanation of data

The program processing the tidying is run_analysis.R, which generates the following derrived files:

* subject_labels.txt 
* subject_data.txt
* average_data.txt

#### subject_labels.txt
This file consists of two columns:

* rowname : index (ID)
* colName : descritive name of the values in the column

#### subject_data.txt
This is the tidyied data from the original source.


#### average_data.txt
This data is averages around each data category, processed by subject by activity.



## run_analysis.R
The data is imported by type (TEST/TRAIN), then processed.
3 components of the processing are done in this step:

1. Extract relevant columns. This is accomplished by progromatically
extracting the target column names and determining their index
locations. The list of extract column indexes is then used for the
extraction.
1. Map activity names into the dataset. This information is pulled
in from a support file.
1. Appropriately label the data columns. This information is pulled
from data supplied in step 1.

After this procedure is performed on each of the (TEST/TRAIN) sets,
the data is merged. The merge occurs after processing to reduce
load on the system.

Data is reordered to group subject(primary) and activity(secondary) rows.
The index is reset for output.

For summary processing to "average_data.txt", explicit group_by is set
equivalent to the above ordering (subject, activity).

Summarisation of remaining columns (3:68) are then processed for all rows
matching each subject:activity tuple.

Please note, not all subjects have engaged in every activity.

