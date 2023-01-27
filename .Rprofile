source("renv/activate.R")
load_dependencies <- function(){
  libraries <- c("shiny","shinydashboard","foreign","readxl","dplyr","randomForestSRC", 
                 "pracma","pROC","mlr3proba","mlr3learners","mlr3extralearners","caret",
                 "utils","ggplot2","shinydashboardPlus", "mlr3tuning", "forcats")
  invisible(suppressMessages(lapply(libraries, library, character.only = TRUE)))
}
load_dependencies()
libs <- c("here", "paws", "zeallot", "paradox")
invisible(sapply(libs, function(x) { if (!requireNamespace(x, quietly = TRUE)) install.packages(x)}))
invisible(sapply(libs,library, character.only=TRUE))
source("helper/s3_bucket.R")

options(warn = 0)
options(shiny.maxRequestSize=30*1024^2)
options(repos =c(CRAN="https://cloud.r-project.org"))
Sys.setenv(root_absPath = here::here())
args <- commandArgs(trailingOnly = T)
# aws_s3 <- connect_s3()
