dataset_merge <- function(base_dir="data/uci_har/") {
  # load the libraries
  library(dplyr)
  library(tidyr)
  library(stringr)
  
  # test set processing
  x_test <- read_x_measurements(paste(base_dir, "test/X_test.txt", sep = ""), paste(base_dir, "features.txt", sep = ""))
  y_test <- read.table(paste(base_dir, "test/y_test.txt", sep = ""))
  subject_te <- read.table(paste(base_dir, "test/subject_test.txt", sep = ""))
  names(subject_te) <- "subject"
  names(y_test) <- "activity"
  b_acc_x_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_acc_x_test.txt", sep = ""), "BodyAccX_")
  b_acc_y_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_acc_y_test.txt", sep = ""), "BodyAccY_")
  b_acc_z_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_acc_z_test.txt", sep = ""), "BodyAccZ_")
  b_gyro_x_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_gyro_x_test.txt", sep = ""), "BodyGyroX_")
  b_gyro_y_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_gyro_y_test.txt", sep = ""), "BodyGyroY_")
  b_gyro_z_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_gyro_z_test.txt", sep = ""), "BodyGyroZ_")
  t_acc_x_te <-   read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/total_acc_x_test.txt", sep = ""), "tAccX_")
  t_acc_y_te <-   read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/total_acc_y_test.txt", sep = ""), "tAccY_")
  t_acc_z_te <-   read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/total_acc_z_test.txt", sep = ""), "tAccZ_")
  test_set <- cbind(y_test, subject_te, x_test, b_acc_x_te, b_acc_y_te, b_acc_z_te, b_gyro_x_te, b_gyro_y_te, b_gyro_z_te, t_acc_x_te, t_acc_y_te, t_acc_z_te)
  
  # train set processing
  x_train <- read_x_measurements(paste(base_dir, "train/X_train.txt", sep = ""), paste(base_dir, "features.txt", sep = ""))
  y_train <- read.table(paste(base_dir, "train/y_train.txt", sep = ""))
  subject_tr <- read.table(paste(base_dir, "train/subject_train.txt", sep = ""))
  names(subject_tr) <- "subject"
  names(y_train) <- "activity"
  b_acc_x_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_acc_x_train.txt", sep = ""), "BodyAccX_")
  b_acc_y_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_acc_y_train.txt", sep = ""), "BodyAccY_")
  b_acc_z_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_acc_z_train.txt", sep = ""), "BodyAccZ_")
  b_gyro_x_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_gyro_x_train.txt", sep = ""), "BodyGyroX_")
  b_gyro_y_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_gyro_y_train.txt", sep = ""), "BodyGyroY_")
  b_gyro_z_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_gyro_z_train.txt", sep = ""), "BodyGyroZ_")
  t_acc_x_tr <-   read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/total_acc_x_train.txt", sep = ""), "tAccX_")
  t_acc_y_tr <-   read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/total_acc_y_train.txt", sep = ""), "tAccY_")
  t_acc_z_tr <-   read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/total_acc_z_train.txt", sep = ""), "tAccZ_")
  train_set <- cbind(y_train, subject_tr, x_train, b_acc_x_tr, b_acc_y_tr, b_acc_z_tr, b_gyro_x_tr, b_gyro_y_tr, b_gyro_z_tr, t_acc_x_tr, t_acc_y_tr, t_acc_z_tr)
  
  # bind test set and train set
  final_set <- tbl_df(rbind(test_set, train_set))
  
  # replace activity id with its name
  sb <- read.table(paste(base_dir, "activity_labels.txt", sep = ""))
  names(sb) <- c("id", "activityname")
  final_set <- merge(final_set, sb, by.x = "activity", by.y = "id")
  final_set <- final_set %>% 
    select(-activity) %>% 
    select(c(activityname, subject:tAccZ_std))
  
  # return the result
  tbl_df(final_set)
}

read_measurement_to_mean_and_sd <- function(path, name) {
  temp <- read.table(path)
  temp <- mutate(temp, mean = rowMeans(temp), sd = apply(temp, 1, sd)) %>% select(mean, sd)
  names(temp) <- c(paste(name,"mean",sep = ""), paste(name,"std",sep = ""))
  temp
}

read_x_measurements <- function(path, features_path="data/uci_har/features.txt") {
  temp <- read.table(path)
  features <- read.table(features_path)
  table_names = as.character(features[,2])
  keys <- grepl("mean\\(\\)|std\\(\\)",table_names)
  names(temp) <- sapply(strsplit(table_names, "-"), create_simple_name)
  temp[,keys]
}

create_simple_name <- function(x) {
  x[2] <- substr(x[2], 1, nchar(x[2])-2)
  if (length(x) == 3) {
    x[1] = paste(x[1],x[3],sep = "")
  }
  x <- paste(x[1], x[2], sep = "_")
  x[1]
}

transform <- function(df=dataset_merge()) {
  # load the libraries
  library(dplyr)
  library(tidyr)
  library(stringr)
  # procedure
  df <- df %>% 
    gather(variable, var_value, -(subject:activityname)) %>% 
    group_by(subject, activityname, variable) %>% 
    summarise(mean=mean(var_value))
  vars <- df$variable
  means <- df[grepl("_mean$", vars),]
  stds <- df[grepl("_std$", vars),]
  means$meanAvg <- means$mean
  final <- select(means, -mean)
  final$stdAvg <- stds$mean
  final$variable <- sapply(final$variable, function(x) substr(x, 1, nchar(x)-5))
  final
}