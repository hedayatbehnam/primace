#' @title Packages loader
#' @description  Loading packages and sources
#' @details Not Run in shiny cloud.
#' @return None
load_dependencies <- function(){
  libraries <- c("shiny", 
                 "shinydashboard", 
                 "foreign", 
                 "readxl",
                 "dplyr", 
                 "randomForestSRC", 
                 "pracma",
                 "pROC",
                 "mlr3proba",
                 "mlr3learners",
                 "mlr3extralearners",
                 "caret",
                 "utils",
                 "ggplot2")
  invisible(lapply(libraries, library, character.only = TRUE))
}

load_dependencies()
