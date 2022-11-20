library(caret)
max_perf_calc <- function(predict_table){
  conf_matrix_youden <- confusionMatrix(data=as.factor(predict_table$status), 
                        reference = as.factor(predict_table$predict_youden),
                        mode="everything", positive="TRUE")
  conf_matrix_closest <- confusionMatrix(data=as.factor(predict_table$status), 
                         reference = as.factor(predict_table$predict_closest_tl),
                         mode="everthing", positive="TRUE")
  cm_tbl <- as.data.frame(cbind(conf_matrix_youden, conf_matrix_closest))
  colnames(cm_tbl) <- c("youden", "closest_topleft")
  return (cm_tbl)
}