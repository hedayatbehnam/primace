## Loading trained models on original study
load_model <- function(input){
    if (input$models == "Survival Random Forest"){
      selected_model <- readRDS("R/models/rfsrc.learner_mod.RDS")
    } else if (input$models == "Survival Xgboost"){
      selected_model <- readRDS("R/models/xgboost.learner_mod.RDS")
    }
    selected_model
}
## upload a sample test set by default when no file data uploaded
studyTest <- readRDS("R/www/test_set.RDS")