#' @title Runner file
#' @description initializing app
#' @export
primace_init <- function(){
  libs <- c("shiny", "devtools", "rsconnect")
  suppressMessages(invisible(sapply(libs, library, character.only=T, quietly=T)))
  modulesPath <- 'R/'
  modules <- c('reactiveVal_output.R', 'styles.R',
               'load_model.R', 'loading_function.R', 'reactiveVal_output.R',
               'upload_file.R','predict_scores.R','survROC.R',
               'final_predict.R','best_point.R','max_perf_calc.R',
               'manual_prediction.R')
  invisible(lapply(modules, function(x) source(paste0(modulesPath, x))))
  shiny::runApp(appDir = "R/",port = 3838, host = "0.0.0.0")
}
  
