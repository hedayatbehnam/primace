predict_scores <- function(data, model){
  task_new <- mlr3proba::TaskSurv$new(id = "id",backend = data, time = "Time_to_MACE", 
                           event = "First_MACE_bin")
  row_ids <- seq(1, nrow(data))
  predicted <- as.data.table(model$predict(task_new, 
                             row_ids = row_ids))
  return (predicted)
}