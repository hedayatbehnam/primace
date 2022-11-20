perf_coords <- function(predict_table, best_scores, time){
  predict_table %>% mutate(status_time = case_when(
    time < time & status == TRUE ~ TRUE,
    TRUE ~ FALSE
  )) %>% group_by(status) %>% summarize(mean = mean(crank), n=n()) -> status_crank
  direction <- ifelse(status_crank$mean[status_crank$status==TRUE] > status_crank$mean[status_crank$status==FALSE],
                      "T>F", 
                      "T<F")
  performance_tbl <- as.data.frame(Id=seq(1:nrow(predict_table)), 
                             Score=predict_table$crank,
                             Predict=case_when(
                                predict_table$crank < best_scores$youden
                             )
                             )
}