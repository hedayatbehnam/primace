#' @title Packages loader
#' @description  Loading packages and sources
#' @details Not Run in shiny cloud.
#' @importFrom utils globalVariables
#' @return None
load_dependencies <- function(){
  libraries <- c("shiny","shinydashboard","foreign","readxl","dplyr","randomForestSRC", 
                 "pracma","pROC","mlr3proba","mlr3learners","mlr3extralearners","caret",
                 "utils","ggplot2","shinydashboardPlus", "mlr3tuning", "forcats",'here')
  invisible(suppressMessages(lapply(libraries, library, character.only = TRUE)))
}
load_dependencies()
