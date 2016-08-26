# data science on Coursera
it's a r project, used to challenge the data science work on Coursera. 

## Getting and Cleaning Data
this repository contain some files which belone to this project. The are listed as below.
* run_analysis.R - the R code which performs the data cleaning job.
* CodeBook.md - the code book for this process and output dataset.
* final_dataset.csv - the final output dataset.

code explanation of the R file (run_analysis.R above), listed by function:
* <code>dataset_merge(base_dir="data/uci_har/")</code> - this function is used to merge the training and testing datasets, change the column names and output a initial dataset for further processing. it has one argument which indicates the path of UCI HAR folder.
* <code>read_measurement_to_mean_and_sd(path, name)</code> - this function helps the function above, to create a simple data.frame from the origin file. it has two arguments. the 'path' indicates the origin file path, and the 'name' gives the name of output data.frame and its columns. 
* <code>transform(df=dataset_merge())</code> - this function will create the final tidy dataset from the inital dataset, which created by the first function. it has one parameter, and it will call the first function to generate the input dataset by default. 

###  - Aug 26, 2016
