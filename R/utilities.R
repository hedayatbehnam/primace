#' @title Fake data generator
#' @description To generate fake data for testing
#' @details by generating fake data with proper and improper variables, 
#' we test uploding files and models functions.
#' @param type determines the type of fake data as "standard" for data which has same 
#' class and number of variables, "more" which has more variable other than main data, 
#' "less" which at least lacks one variable compared to standard form
#' "mismatch", which has different class of some variabls compared to standard form.
#' @param rows_num number of observations of fake data
#' @param event whether event variable should be added, default is True
#' @param time whether time variable should be added, default is True
#' @return fake data as data frame
#' @export
data_generator <- function(type="standard", rows_num=12, event=T, time=T){
fake_data <- data.frame(Clopidogrel = integer(),Pain_to_Door = integer(),Ca.ch.A = integer(),
                        Nitrate = integer(),HDL = integer(),LDL = integer(),TG = integer(),BMI = integer(),Cr = double(),
                        Hb = double(),Statines = integer(),COPD = integer(),ASA = integer(),Betablocker = integer(),
                        ACEinh_ARB = integer(),HTN = integer(),DM = integer(),FH = integer(),IHD = integer(),
                        Gender = integer(),Age = integer(),CS = integer(), Block = integer(),Cardiogenicshock = integer(),
                        Door_to_Device = integer(),Opium_bin = integer(),stringsAsFactors = F)
  fake_data <- as.data.frame(apply(fake_data, 2, function(x) sample(c(1,2),rows_num,replace = T)))
  if (type=="less"){
    missed_var <- sample(names(fake_data), floor(runif(1)*10), replace=F)
    fake_data %>% dplyr::select(-missed_var) -> fake_data
  } else if (type=="more"){
    fake_data$fake_var <- 1
  } else if (type=="mismatch"){
    fake_data$Gender <- as.factor(fake_data$Gender)
  } 
  if (event == T) fake_data$First_MACE_bin <- sample(c(0,1), rows_num,replace = T)
  if (time == T) fake_data$Time_to_MACE <-  sample(c(1,365), rows_num,replace = T)
  return (fake_data)
}