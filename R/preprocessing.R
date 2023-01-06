#' @title Data Preprocessor
#' @description module to preprocess data automatically
#' @details when new dataset is available, this module automatically check its validity and 
#' initiates preprocess as machine learning operationals.
#' @importFrom foreign read.spss
#' @importFrom utils fileSnapshot
#' @param url url of new_dataset file in github located in R/data/new_dataset.RDS. directory
#' @return uploaded new dataset
preprocess_stage <- function(url="https://raw.github.com/hedayatbehnam/primace/main/R/data/dataset.csv"){
  system(paste("wget", url), invisible = T)
  tmpshot <- fileSnapshot(".")
  file_name <- rownames(tmpshot$info[which.max(tmpshot$info$mtime),])
  new_data <- readRDS(file_name)
  return (new_data)
}
