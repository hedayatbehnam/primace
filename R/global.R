#' @include mariadb_connect.R
NULL
#' Packages loader
#' Loading packages and sources
#' Not Run in shiny cloud.
#' @importFrom utils globalVariables
#' @return None
load_dependencies <- function(){
  libraries <- c("shiny","shinydashboard","foreign","readxl","dplyr","randomForestSRC",
                 "pracma","pROC","mlr3proba","mlr3learners","mlr3extralearners","caret",
                 "utils","ggplot2","shinydashboardPlus", "mlr3tuning", "forcats","crosstable",
                 "sodium", "DBI")
  invisible(suppressMessages(lapply(libraries, library, character.only = TRUE)))
}
load_dependencies()
source(paste0(Sys.getenv("root_absPath"),"/helper/s3_bucket.R"))
aws_s3 <- connect_s3()

sample_cred <- data.frame(
  username_id = c("usr1", "usr2"),
  passod = sapply(c("pass1", "pass2"), sodium::password_store),
  permissions = c("admin", "standard"),
  stringsAsFactors = F
)

credentials <- tryCatch({mariadb_connect()}, error = function(e) return (sample_cred))
