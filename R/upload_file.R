#' @title upload file.
#' @description a function to upload different formats of data for prediction.
#' @details User can import csv, xlsx, sav and rds format of data.
#' @importFrom shiny req
#' @importFrom utils read.csv
#' @importFrom foreign read.spss
#' @importFrom readxl read_excel
#' @param input input set if Shiny
#' @return A list containing dataset named survData and whether target variable is available or not
#' @export
upload_data <- function(input){
    varnames <- dataset <- NULL
    noTarget <- FALSE
    loadedFile <- input$loadFile  # read uploaded file in fileInput section
    if (is.null(loadedFile$datapath)){
      return ('empty')
    }
    ext <- tools::file_ext(loadedFile$datapath) # detect file extension
    req(loadedFile)
    if (!(tolower(ext) %in% c("csv", "rds", "xlsx", "sav"))) {
      return ('nonValid')
    }
    if (tolower(ext) == "rds"){
      dataset <- readRDS(loadedFile$datapath)
    } else if (tolower(ext) == "csv"){
      dataset <- read.csv(loadedFile$datapath)
    } else if (tolower(ext) == "sav") {
      dataset <- read.spss(loadedFile$datapath, to.data.frame = TRUE)
    } else if (tolower(ext) == "xlsx") {
      dataset <- read_excel(loadedFile$datapath)
    } 
    if (!any((names(dataset) %in% varnames[,'varnames']))){
      return("mismatch")
    }
    if (!is.null(loadedFile)){
      if (!"Time_to_MACE" %in% names(dataset) | !"First_MACE_bin" %in% names(dataset)){   
        # creating a random non-used target variable for uploaded data file with no target variable
        # to make preprocessing by `recipe` package `prep` function possible. (a bug in `recipes` package)
        noTarget <- TRUE
        dataset$Time_to_MACE <- 1
        dataset$First_MACE_bin <- 1
      }
      return(list(survData = dataset, target = noTarget))
    }
}