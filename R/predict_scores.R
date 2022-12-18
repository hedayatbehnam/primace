#' Main predicting tool of data by saved pre-trained machine learning models
#' @param data provided dataset we want to predict
#' @param model saved model to be used as prediction model
#' @importFrom data.table as.data.table
#' @export
predict_scores <- function(data, model){
  task_new <- mlr3proba::TaskSurv$new(id = "id",backend = data, time = "Time_to_MACE", 
                           event = "First_MACE_bin")
  row_ids <- seq(1, nrow(data))
  predicted <- as.data.table(model$predict(task_new, 
                             row_ids = row_ids))
  return (predicted)
}