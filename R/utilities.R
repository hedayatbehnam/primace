#' @title Fake data generator
#' @description To generate fake data for testing
#' @details by generating fake data with proper and improper variables, 
#' we test uploding files and models functions.
#' @importFrom stats runif
#' @param type determines the type of fake data as "standard" for data which has same 
#' class and number of variables, "more" which has more variable other than main data, 
#' "less" which at least lacks one variable compared to standard form
#' "mismatch", which has different class of some variabls compared to standard form.
#' @param rows_num number of observations of fake data
#' @param event whether event variable should be added, default is True
#' @param time whether time variable should be added, default is True
#' @return fake data as data frame
data_generator <- function(type="standard", rows_num=12, event=T, time=T){
  fake_data <- data.frame(Clopidogrel = integer(),Pain_to_Door = integer(),Ca.ch.A = integer(),
                          Nitrate = integer(),HDL = integer(),LDL = integer(),TG = integer(),BMI = integer(),Cr = double(),
                          Hb = double(),Statines = integer(),COPD = integer(),ASA = integer(),Betablocker = integer(),
                          ACEinh_ARB = integer(),HTN = integer(),DM = integer(),FH = integer(),IHD = integer(),
                          Gender = integer(),Age = integer(),CS = integer(), Block = integer(),Cardiogenicshock = integer(),
                          Door_to_Device = integer(),Opium_bin = integer(),stringsAsFactors = F)
  fake_data <- as.data.frame(apply(fake_data, 2, function(x) sample(c(1,2),rows_num,replace = T)))
  if (type=="less"){
    missed_var <- sample(names(fake_data), floor(runif(1)*10)+1, replace=F)
    fake_data %>% dplyr::select(-all_of(missed_var)) -> fake_data
  } else if (type=="more"){
    fake_data$fake_var <- 1
  } else if (type=="mismatch"){
    fake_data$Gender <- as.factor(fake_data$Gender)
  } 
  if (event == T) fake_data$First_MACE_bin <- sample(c(0,1), rows_num,replace = T)
  if (time == T) fake_data$Time_to_MACE <-  sample(c(1,365), rows_num,replace = T)
  return (fake_data)
}
#' @title New Data Reader
#' @description module to read new data automatically from github repo
#' @details when new dataset is available, this module automatically reads it as entry point for machine learning operationals.
#' @importFrom foreign read.spss
#' @importFrom utils fileSnapshot
#' @param url url of new_dataset file in github located in R/data/new_dataset.RDS. directory
#' @return uploaded new dataset
read_data <- function(url="https://raw.github.com/hedayatbehnam/primace/main/R/datasets/dataset.RDS"){
  tryCatch({
    system(paste("wget", url), invisible = T)
    tmpshot <- fileSnapshot(".")
    file_name <- rownames(tmpshot$info[which.max(tmpshot$info$mtime),])
    new_data <- readRDS(file_name)
    return (new_data)
  }, error = function(e) cat("No new dataset has been uploaded."))
}
#' @title Dataset Modifier 
#' @description module to peform some preprocessing steps automatically on new dataset privided by read_data function
#' @importFrom forcats fct_collapse fct_drop
#' @param dataset dataset read by read_data function
#' @return modified dataset
dataset_modification <- function(dataset) {
  # merge clopidogrel & plavix: Clopidogrel
  dataset$Clopidogrel <- ifelse(dataset$Plavix == 1 | dataset$Clopidogrel == 1, 1, 0)  
  #merge metformin and Insulin to DM (0,1,2)
  dataset$Metformin <- dataset$Insulin <- NULL
  # GPIIbIIIainhibitors merging to single variable
  dataset$GPIIbIIIainhibitors <- ifelse(    
    dataset$GPIIbIIIainhibitorsAbciximab == 1 | 
      dataset$GPIIbIIIainhibitorsTirofiba ==1 |
      dataset$GPIIbIIIainhibitorsEptifibatide == 1 , 1, 0)
  # ommit all GPIIBIIIA variables(subcategory)
  dataset$GPIIbIIIainhibitorsGPIIaIIIbinhibitors<-dataset$GPIIbIIIainhibitorsAbciximab<-dataset$GPIIbIIIainhibitorsMode0<- 
    dataset$GPIIbIIIainhibitorsTirofiban<-dataset$GPIIbIIIainhibitorsEptifibatide<-NULL
  # GPIIBIIA infusion hours to numeric
  dataset$GPIIbIIIainhibitorsIFbolusinfiusiongtHour <- as.numeric(dataset$GPIIbIIIainhibitorsIFbolusinfiusiongtHour)
  dataset$GPIIbIIIainhibitorsIFbolusinfiusiongtHour <- ifelse(!is.na(dataset$GPIIbIIIainhibitorsIFbolusinfiusiongtHour) , 
                                                              dataset$GPIIbIIIainhibitorsIFbolusinfiusiongtHour, 0)
  # Cardiogenic shock merging to single variable
  dataset$Cardiogenicshock <- ifelse(  
    (!(is.na(dataset$Cardiogenicshock)) & dataset$Cardiogenicshock == 1) |
      (!(is.na(dataset$CardiogenicshockatthestartofPCI)) & dataset$CardiogenicshockatthestartofPCI == 1) | 
      (!(is.na(dataset$CardiogenicshockduringPCI)) & dataset$CardiogenicshockduringPCI == 1) |
      (!(is.na(dataset$CardiogenicshockafterPCI)) & dataset$CardiogenicshockafterPCI == 1),1,0)
  # ommit all Cardiogenic shock variables(subcategory)
  dataset$CardiogenicshockatthestartofPCI <- dataset$CardiogenicshockduringPCI <- dataset$CardiogenicshockafterPCI <- NULL
  #IABP empty cells to 0("No")
  dataset$IABP <- ifelse(dataset$IABP == 1, 1, 0)
  dataset$Procedute_Mortality_Distance_M <- ifelse(dataset$Mortality == 1,dataset$Procedute_Mortality_Distance_M,0)
  dataset$PostProcedure_Complication <- dataset$Intraprocedure_Complication <- NULL
  dataset$Plavix <- NULL
  #Factoring binary pred.var (factor to Yes, No) 
  for (i in colnames(dataset)){        
    if (i %in% c("GPIIbIIIainhibitors", "IABP", "Cardiogenicshock", "ASA", "Ca.ch.A", "Clopidogrel", "Betablocker", "Statines", "ACEinh", "Nitraten", "ARB", "COPD")){
      #making factor levels("No", "Yes") for binary vars
      dataset[,i] <- factor(dataset[, i], levels = c(0,1), labels = c("No", "Yes"))
    }
  }
  # <-- Time handling
  #date of outcomes and baseline
  dataset$First_Contact <- as.Date(as.character(dataset$PPCIDate), format = "%Y/%m/%d")
  dataset$MACE_Date <- as.Date(as.character(dataset$MACE_Date), format = "%Y/%m/%d")
  dataset$Last_FU <- as.Date(as.character(dataset$Last_contact), format = "%Y/%m/%d")
  dataset$Mortality_date <- as.Date(as.character(dataset$Mortality_date), format = "%Y/%m/%d")
  #Time difference
  dataset$Time_to_MACE <- dataset$MACE_Date - dataset$First_Contact
  dataset$Time_to_LastFU <- dataset$Last_FU - dataset$First_Contact
  #Time to MACE modification
  dataset$Time_to_MACE <- ifelse(!is.na(dataset$Time_to_MACE), dataset$Time_to_MACE, dataset$Time_to_LastFU)
  #negative date to zero
  dataset$Time_to_MACE <- ifelse(dataset$Time_to_MACE < 0, 0, dataset$Time_to_MACE) 
  dataset$Time_to_MACE <- dataset$Time_to_MACE + 1
  dataset$Time_to_LastFU <- ifelse(is.na(dataset$Time_to_LastFU), "", dataset$Time_to_LastFU)
  dataset$Time_to_LastFU <- as.numeric(dataset$Time_to_LastFU)
  #Clearing time variables
  dataset$PPCIDate <- dataset$Last_contact <- dataset$MACE_Date <- dataset$Mortality_date <- dataset$Last_FU <-
    dataset$First_Contact <- NULL
  # --------End of time handling>
  
  # <------ Data type handling 
  #factored data
  dataset$MI_site <- as.factor(dataset$MI_site)
  dataset$Block <- lapply(dataset$Block, as.character)
  dataset$Block <- unlist(dataset$Block)
  dataset$Block <- replace(dataset$Block, is.na(dataset$Block), "No")
  dataset$Block <- factor(dataset$Block)
  dataset$FinalTIMI2 <- ifelse(dataset$FinalTIMI2 == ".", NA, dataset$FinalTIMI2)
  dataset$InitialTIMI2 <- as.factor(dataset$InitialTIMI2)
  dataset$FinalTIMI2 <- as.factor(dataset$FinalTIMI2)
  dataset$Opium_bin <- ifelse((!is.na(dataset$Opium)) & dataset$Opium %in% c("Former", "Current"), "Yes", "No")
  dataset$Opium_bin <- as.factor(dataset$Opium_bin)
  dataset$CS <- ifelse((!is.na(dataset$CS)) & dataset$CS %in% c('No'), 'No', 'Yes')
  dataset$CS <- as.factor(dataset$CS)
  dataset <- dataset %>%                                          
    mutate(Culprit_Vessel = fct_collapse(Culprit_Vessel, #collapsing lcx and rca territory
                                         LM_LADp = c('LM','LAD(Prox)',"LAD(Ostial)"),
                                         LADnp = c('LAD(Lo miss)',"LAD(Nonprox)","Diaginal"),
                                         non.LAD = c('RCA', 'PDA', 'PLB', 'LCX', 'OM', 'Ramus'))) 
  dataset$ACEinh_ARB <- ifelse(dataset$ACEinh == "Yes" | dataset$ARB == "Yes", "Yes", "No") 
  dataset$ACEinh_ARB <- as.factor(dataset$ACEinh_ARB)
  dataset$ACEinh <- dataset$ARB <- NULL
  dataset$Culprit_Vessel <- fct_drop(dataset$Culprit_Vessel)      #drop SVG with no obs
  dataset$Opium_bin_num <- ifelse(dataset$Opium_bin == "Yes",1,0)
  dataset <- dataset %>%
    mutate(PCI_Result = fct_collapse(PCI_Result,
                                     Successful = c('Successful'),
                                     Unacceptable = c('Acceptable', 'Unacceptable', 'Fail to pass Guide wire', 'Fail to pass Ballon','Fail to pass Stent')))
  # Excluding rescue PCI and cardiogenic shock as reason for PCI
  dataset <- filter(dataset, Primery_PCI == "Immediate PCI")
  # ommitting primery_pci variable
  dataset$Primery_PCI <- NULL
  #opium type & duration
  dataset$OpiumTypeOfConsumption <- as.character(dataset$OpiumTypeOfConsumption)
  dataset$OpiumTypeOfConsumption <- ifelse(is.na(dataset$OpiumTypeOfConsumption) &  dataset$Opium != "Former", 0, dataset$OpiumTypeOfConsumption)
  dataset$OpiumTypeOfConsumption <- as.factor(dataset$OpiumTypeOfConsumption)
  dataset$Opiumdurationm <- ifelse(is.na(dataset$Opiumdurationm) & !(dataset$Opium %in% c("Former", "Current")), 0,dataset$Opiumdurationm)
  #smoke p/y & quit time
  dataset$SmokingPacky <- ifelse(is.na(dataset$SmokingPacky) & !(dataset$CS %in% c("Former", "Current")), 0, dataset$SmokingPacky)
  dataset$Smokingquittimem <- ifelse(is.na(dataset$Smokingquittimem) & dataset$CS !=  "Former", 0, dataset$Smokingquittimem)
  #numeric data type
  dataset$LabtestsTroponinT0ngml <- as.numeric(dataset$LabtestsTroponinT0ngml)
  dataset$LabtestsTroponinT1ngml <- as.numeric(dataset$LabtestsTroponinT1ngml)
  dataset$LabtestsTroponinT2ngml <- as.numeric(dataset$LabtestsTroponinT2ngml)
  dataset$First_MACE_bin <- ifelse(dataset$First_MACE != "No", 1, 0)
  dataset$FinalTIMI2 <- ifelse(dataset$FinalTIMI2 != 3, 0,1)
  dataset$FinalTIMI2 <- as.factor(dataset$FinalTIMI2)
  # Making subgroups of MACE 
  for (i in 1:length(levels(dataset$First_MACE))){
    dataset[levels(dataset$First_MACE)[i]] <- lapply(dataset['First_MACE'],function(x) ifelse(x == levels(dataset$First_MACE)[i], 1, 0))
  }
  #Clearing unnecesary variables
  dataset$PreviousPCI <- dataset$Previous.CABG <- dataset$Previous.valve.Surgery <- dataset$Procedure_Last.Contact_Distance <-
    dataset$Procedure_MACE_Distance_M <- dataset$Procedute_Mortality_Distance_M <- dataset$Height <- dataset$Weight <- NULL 
  dataset <- dataset %>%
    dplyr::rename(GPIIBIIIA.inf.h = GPIIbIIIainhibitorsIFbolusinfiusiongtHour,
                  Door_to_Device = Distance.Door.to.Device2,
                  Pain_to_Door = Distance.Pain.to.Door2)
  # ------------- end of data type handling>
  return(dataset)
}
#' @title Check Missing Values
#' @description check missing values percentage and their patterins
#' @param data_file dataset for checking its missing values
#' @return returns a list containing total count of missing values, variables with low missing values,
#' a dataset with less than 10% missing values, variables vector with less than 10 percent missing values,
#' variables vector with high missing values, missing patterns.
check_missings <- function(data_file){
  missing_var_count <- miss_count <- var_name <- percent <- missing_var_percent <- star_above_10 <- variable_below_10 <- 
    df_b10_miss <- variable_low_mis_name <- NULL
  return_list <- list()
  for (i in 1:length(data_file)){
    miss_count[i] <- length(data_file[,i][is.na(data_file[,i])])
    var_name[i] <- colnames(data_file[i])
    missing_var_percent[i] <- round(miss_count[i]/nrow(data_file),4) * 100
    if (missing_var_percent[i] < 10){
      star_above_10[i] <-  " "
      variable_below_10[i] <- colnames(data_file[i])
    } else if (missing_var_percent[i] > 20) {
      star_above_10[i] <-  "**"
    } else {
      star_above_10[i] <- "*"
    }
  }
  missing_var_count <- data.frame(Variable = var_name, Missed = miss_count, Percent = missing_var_percent, Above10p = star_above_10)
  missing_var_count <- missing_var_count[with(missing_var_count, order(-Missed)),]
  variable_below_10 <- variable_below_10[!is.na(variable_below_10)]
  variable_low_mis <- subset(missing_var_count, Percent < 10, select = c("Variable", 
                                                                         "Missed","Percent"))
  variable_high_mis_df <- subset(missing_var_count, Percent >= 10, select = c("Variable", "Missed","Percent"))
  variable_low_mis_name <- variable_low_mis[,1]
  variable_high_mis_vector <- names(variable_high_mis_df)
  var_ID <- names(variable_low_mis) %in% c("File247", "My_file", "Encounter.ID","Patient.Code")
  df_b10_miss <- subset(data_file, select = variable_low_mis_name)
  df_b10_miss <- df_b10_miss[!var_ID]
  return_list <- list(missing_var_count, variable_low_mis, df_b10_miss, variable_below_10, variable_high_mis_vector)
  return(return_list)
}
#' @title Complete Case Dataset
#' @description creating a dataset with no missing values
#' @importFrom stats complete.cases
#' @param low_miss_dataframe returned dataset with less than ten percent missing values from check_missing function, ie. missing_data function third value
#' @return a list containing complete case dataset and included variables in complete case
complete_case <- function(low_miss_dataframe){
  df_low_miss <- var_names_excluded <- prepared_dataset <- prepared_dataset_CC <- included_dataset <- return_list <- NULL
  df_low_miss <- low_miss_dataframe
  df_low_miss <- as.data.frame(df_low_miss)
  var_names_excluded <- names(df_low_miss) %in% c("My_file", "File247", "First_Contact","Encounter.ID")
  # prepared_dataset <- df_low_miss[!var_names_excluded]
  prepared_dataset <- df_low_miss
  included_dataset <- names(prepared_dataset)
  prepared_dataset_CC <- prepared_dataset[complete.cases(prepared_dataset),]
  return_list <- list(prepared_dataset_CC, included_dataset, prepared_dataset)
  return(return_list)
}
#' @title get mode of a vector
#' @description to find mode of a vector of items
#' @param v vetor of items
#' @return mode of vector
getmode <- function(v){         #function to find mode
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v,uniqv)))]
}
#' @title mode and median missing imputation
#' @description replacing missing values by mode for categorical variable and median for numerical variables 
#' @param dataset dataset to be imputed
#' @return imputed dataset
missing_impute <- function(dataset){
  for (i in seq_along(names(dataset))){
    if (class(dataset[,i]) == "factor"){
      dataset[,i][dataset$Opium_bin == "Yes"][is.na(dataset[,i][dataset$Opium_bin == "Yes"])] <- getmode(dataset[,i][dataset$Opium_bin == "Yes"])
      dataset[,i][dataset$Opium_bin == "No"][is.na(dataset[,i][dataset$Opium_bin == "No"])] <- getmode(dataset[,i][dataset$Opium_bin == "No"])
    }
    else if (class(dataset[,i]) %in% c("numeric")){
      dataset[,i][dataset$Opium_bin == "Yes"][is.na(dataset[,i][dataset$Opium_bin == "Yes"])] <- median(dataset[,i][dataset$Opium_bin == "Yes"], na.rm = T)
      dataset[,i][dataset$Opium_bin == "No"][is.na(dataset[,i][dataset$Opium_bin == "No"])] <- median(dataset[,i][dataset$Opium_bin == "No"], na.rm = T)
    }
  }
  return (dataset)
}
#' @title First Year MACE
#' @description creating data for one year survival, by correcting event for time less than a year ie 365.25 days.
#' @param dataset dataset to be provided.
#' @return dataset with MACE and censor time modfied for less than 365.25 days.
first_year_MACE <- function(dataset){
  for (i in seq_len(nrow(dataset))){
    if (dataset[i,'First_MACE_bin'] == 1 & dataset[i,'Time_to_MACE'] > 365.25){
      dataset[i,'First_MACE_bin'] <- 0
      dataset[i,'Time_to_MACE'] <- 365.25
    }     
    if (dataset[i,'First_MACE_bin'] == 0 & dataset[i,'Time_to_MACE'] > 365.25){
      dataset[i,'Time_to_MACE'] <- 365.25
    }  
  }
  return (dataset)
}

