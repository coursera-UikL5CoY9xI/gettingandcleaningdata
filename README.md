# Getting and Cleaning Data 

Starting from data sourced at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
data is tidy'ed and restored.

The following controlled files make up the processing:
* README.md      - This file
* run_analysis.R - The core dataprocessing file
* codebook.txt   - Explanation of data

The program processing the tidying is run_analysis.R, which generates the following derrived files:
* subject_labels.txt 
* subject_data.txt
* average_data.txt

#### subject_labels.txt
This file consists of two columns:
* rowname - index (ID)
* colName - descritive name of the values in the column

#### subject_data.txt
This is the tidyied data from the original source.


#### average_data.txt
This data is averages around each data category, processed by subject by activity.

