#' @title Score Predictor.
#' @description Main predicting tool of data by saved pre-trained machine learning models
#' @import mlr3
#' @import mlr3learners
#' @import mlr3extralearners
#' @import pracma
#' @import randomForestSRC
#' @importFrom mlr3proba TaskSurv
#' @importFrom data.table as.data.table
#' @param data provided dataset we want to predict
#' @param model saved model to be used as prediction model
#' @return predited scores table as datatable.
#' @export
predict_scores <- function(data, model){
  task_new <- mlr3proba::TaskSurv$new(id = "id",backend = data, time = "Time_to_MACE", 
                           event = "First_MACE_bin")
  row_ids <- seq(1, nrow(data))
  predicted <- as.data.table(model$predict(task_new, 
                             row_ids = row_ids))
  return (predicted)
}