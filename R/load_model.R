#' @title Model Loader
#' @description Loading trained models on original study
#' @param input input of shinyserver
#' @param rf_model path to survival random forest model
#' @param xgb_model path to xgboost model
#' @return loaded models in rds format
load_model <- function(input, rf_model="models/rfsrc.learner_mod.RDS", 
                       xgb_model="models/xgboost.learner_mod.RDS"){
    if (input$models == "Survival Random Forest"){
      selected_model <- readRDS(rf_model)
    } else if (input$models == "Survival Xgboost"){
      selected_model <- readRDS(xgb_model)
    }
    selected_model
}
