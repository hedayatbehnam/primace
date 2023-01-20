source("renv/activate.R")
options(warn = 0)
options(shiny.maxRequestSize=30*1024^2)
options(repos =c(CRAN="https://cloud.r-project.org"))
if (!requireNamespace("here", quietly = TRUE))
  install.packages("here")
if (!requireNamespace("paws", quietly = TRUE))
  install.packages("paws")
library("here"); library("paws")
Sys.setenv(root_absPath = here::here())
args <- commandArgs(trailingOnly = T)
tryCatch(Sys.setenv(s3 = paws::s3(config=list(endpoint=paste0("https://",args[1]), 
        access_key_id=args[2], secret_access_key=args[3], region="default"))), 
        error=function(e) invisible())

