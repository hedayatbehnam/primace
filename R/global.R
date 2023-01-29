#' Packages loader
#' Loading packages and sources
#' Not Run in shiny cloud.
#' @importFrom utils globalVariables
#' @return None
load_dependencies <- function(){
  libraries <- c("shiny","shinydashboard","foreign","readxl","dplyr","randomForestSRC", 
                 "pracma","pROC","mlr3proba","mlr3learners","mlr3extralearners","caret",
                 "utils","ggplot2","shinydashboardPlus", "mlr3tuning", "forcats","crosstable")
  invisible(suppressMessages(lapply(libraries, library, character.only = TRUE)))
}
load_dependencies()
source(paste0(Sys.getenv("root_absPath"),"/helper/s3_bucket.R"))
aws_s3 <- connect_s3()
