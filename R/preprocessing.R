#' @title Data Preprocessing
#' @description module to perform preprocessing on dataset
#' @importFrom foreign read.spss
#' @importFrom stats median
#' @return uploaded preprocessed dataset
#' @export
preprocessing <- function(){
  dataset <- read_data()
  df_modified <- suppressWarnings(dataset_modification(dataset))
  missing_dataframe <- check_missings(df_modified) 
  dataset_low_miss <- complete_case(missing_dataframe[3])
  dataset_NCC_for_analysis <- as.data.frame(dataset_low_miss[3])
  dataset_ncc_corr <- select(dataset_NCC_for_analysis, -c("Time_to_LastFU","Opiumdurationm","Opium",                                                  "OpiumTypeOfConsumption","First_MACE","My_file","Patient.Code2","Encounter.ID",
                                                          "File247","SmokingPacky","Smokingquittimem",
                                                          "GPIIBIIIA.inf.h" ,"Next_Plan", "TVR", "No",
                                                          "TLR", "CABG", "Mortality", "Death", "MI",
                                                          "Opium_bin_num", "TCH", "PCI_Result"))
  zero_miss_dataset <- missing_impute(dataset_ncc_corr)
  one_year_dataset <- first_year_MACE(zero_miss_dataset)
  
  task <- TaskSurv$new(id = 'if', backend =one_year_dataset, time = 'Time_to_MACE', event = 'First_MACE_bin')
  train_set <- sample(task$nrow, 0.8 * task$nrow)
  test_set <- setdiff(seq_len(task$nrow), train_set)
  inner.rsmp <- rsmp("cv", folds = 10)
  outer.rsmp <- rsmp("cv", folds = 3)
}
