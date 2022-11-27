max_perf_calc <- function(predict_table){
  conf_matrix_youden <- confusionMatrix(data=as.factor(predict_table$status), 
                        reference = as.factor(predict_table$youden),
                        mode="everything", positive="TRUE")
  conf_matrix_closest <- confusionMatrix(data=as.factor(predict_table$status), 
                         reference = as.factor(predict_table$closest.topleft),
                         mode="everything", positive="TRUE")
  cm_tbl <- as.data.frame(cbind(Measure=names(conf_matrix_youden$byClass),
                                youden=conf_matrix_youden$byClass, 
                                closest_topleft=conf_matrix_closest$byClass))
  return (cm_tbl)
}