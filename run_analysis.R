dataset_merge <- function(base_dir="data/uci_har/") {
  # load the libraries
  library(dplyr)
  library(tidyr)
  
  # test set processing
  # x_test <- read.table(paste(base_dir, "test/X_test.txt", sep = ""))
  x_test <- read_measurement_to_mean_and_sd(paste(base_dir, "test/X_test.txt", sep = ""), "x_")
  y_test <- read.table(paste(base_dir, "test/y_test.txt", sep = ""))
  subject_te <- read.table(paste(base_dir, "test/subject_test.txt", sep = ""))
  names(subject_te) <- "subject"
  names(y_test) <- "activity"
  b_acc_x_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_acc_x_test.txt", sep = ""), "body_acc_x_")
  b_acc_y_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_acc_y_test.txt", sep = ""), "body_acc_y_")
  b_acc_z_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_acc_z_test.txt", sep = ""), "body_acc_z_")
  b_gyro_x_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_gyro_x_test.txt", sep = ""), "body_gyro_x_")
  b_gyro_y_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_gyro_y_test.txt", sep = ""), "body_gyro_y_")
  b_gyro_z_te <- read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/body_gyro_z_test.txt", sep = ""), "body_gyro_z_")
  t_acc_x_te <-   read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/total_acc_x_test.txt", sep = ""), "total_acc_x_")
  t_acc_y_te <-   read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/total_acc_y_test.txt", sep = ""), "total_acc_y_")
  t_acc_z_te <-   read_measurement_to_mean_and_sd(paste(base_dir, "test/Inertial Signals/total_acc_z_test.txt", sep = ""), "total_acc_z_")
  test_set <- cbind(y_test, subject_te, x_test, b_acc_x_te, b_acc_y_te, b_acc_z_te, b_gyro_x_te, b_gyro_y_te, b_gyro_z_te, t_acc_x_te, t_acc_y_te, t_acc_z_te)
  
  # train set processing
  # x_train_0 <- read.table(paste(base_dir, "train/X_train.txt", sep = ""))
  x_train <- read_measurement_to_mean_and_sd(paste(base_dir, "train/X_train.txt", sep = ""), "x_")
  y_train <- read.table(paste(base_dir, "train/y_train.txt", sep = ""))
  subject_tr <- read.table(paste(base_dir, "train/subject_train.txt", sep = ""))
  names(subject_tr) <- "subject"
  names(y_train) <- "activity"
  b_acc_x_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_acc_x_train.txt", sep = ""), "body_acc_x_")
  b_acc_y_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_acc_y_train.txt", sep = ""), "body_acc_y_")
  b_acc_z_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_acc_z_train.txt", sep = ""), "body_acc_z_")
  b_gyro_x_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_gyro_x_train.txt", sep = ""), "body_gyro_x_")
  b_gyro_y_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_gyro_y_train.txt", sep = ""), "body_gyro_y_")
  b_gyro_z_tr <- read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/body_gyro_z_train.txt", sep = ""), "body_gyro_z_")
  t_acc_x_tr <-   read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/total_acc_x_train.txt", sep = ""), "total_acc_x_")
  t_acc_y_tr <-   read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/total_acc_y_train.txt", sep = ""), "total_acc_y_")
  t_acc_z_tr <-   read_measurement_to_mean_and_sd(paste(base_dir, "train/Inertial Signals/total_acc_z_train.txt", sep = ""), "total_acc_z_")
  train_set <- cbind(y_train, subject_tr, x_train, b_acc_x_tr, b_acc_y_tr, b_acc_z_tr, b_gyro_x_tr, b_gyro_y_tr, b_gyro_z_tr, t_acc_x_tr, t_acc_y_tr, t_acc_z_tr)
  
  # bind test set and train set
  tbl_df(rbind(test_set, train_set))
}

read_measurement_to_mean_and_sd <- function(path, name) {
  temp <- read.table(path)
  temp <- mutate(temp, mean = rowMeans(temp), sd = apply(temp, 1, sd)) %>% select(mean, sd)
  names(temp) <- c(paste(name,"mean",sep = ""), paste(name,"sd",sep = ""))
  temp
}

transform <- function(df=dataset_merge()) {
  # load the libraries
  library(dplyr)
  library(tidyr)
  # procedure
  df <- df %>% 
    gather(variable, var_value, -(activity:subject)) %>% 
    group_by(activity, subject, variable) %>% 
    summarise(mean=mean(var_value))
  df
}
