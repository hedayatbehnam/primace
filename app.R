library(shiny)
modulesPath <- 'R/'
modules <- c('reactiveVal_output.R', 'styles.R',
             'load_model.R', 'loading_function.R', 'reactiveVal_output.R',
             'upload_file.R','predict_scores.R','survROC.R',
             'final_predict.R','best_point.R','max_perf_calc.R',
             'manual_prediction.R')
invisible(lapply(modules, function(x) source(paste0(modulesPath, x))))
shiny::shinyAppDir("R/")