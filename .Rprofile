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
liara_s3 <- suppressWarnings(system("printenv LIARA_BUCKET_NAME", intern = T))
if (length(liara_s3) != 0){
    aws_s3 <- paws::s3(
      config = list(
        credentials = list(
          creds = list(
            access_key_id = suppressWarnings(system("printenv LIARA_ACCESS_KEY", intern = T)),
            secret_access_key = suppressWarnings(system("printenv LIARA_SECRET_KEY", intern = T))
          )
        ),
        endpoint = paste0("https://",suppressWarnings(system("printenv LIARA_ENDPOINT", intern = T))),
        region = "default"
      )
    )
} else { invisible(function() return (NULL))}
