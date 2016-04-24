This repo explains how "run_analysis.R" works.

Basically its a simple single script.

Pre-requisite to executing the scripts:
Download and Unzip the "getdata-projectfiles-UCI HAR Dataset.zip" file
Load the required libraries data.table and dplyr
Set the absolute path using setwd() command


Overall Script Logic:
1. Read the Lookup Files
2. Read the Test and Train Files
3. Combine the Test and Train Files, while maintaining the Activity and Subkect code keys
4. Extract the Mean and STD columns. This is done by simply choosing columns which have either phrase "mean()" or "std()"
5. Rollup using Summarize_Each function
6. Validate the rows and columns counts and values independently
7. Successful execution of the script produces an output file "output.txt", which has headers, and space delimited columns

Note:
1. If you use a different path from whats hardcoded in the file, the setwd() command may not work
2. Output file rows are not sorted on any column
3. More information is also found on ==> https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2013-84.pdf
