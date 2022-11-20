final_predict <- function(predict_table, surv_roc, best_scores){
  predict_table %>% mutate(status_time = case_when(
    time < time & status == TRUE ~ TRUE,
    TRUE ~ FALSE)) %>% group_by(status) %>% summarize(mean = mean(crank), n=n()) -> status_crank
  direction <- ifelse(status_crank$mean[status_crank$status==TRUE] > status_crank$mean[status_crank$status==FALSE],
                      "T>F", 
                      "T<F")
  predict_table %>% mutate(predict_youden = case_when(
    direction == "T>F" & crank >= best_scores$youden ~ TRUE,
    direction == "T>F" & crank < best_scores$youden ~ FALSE,
    direction == "T<F" & crank >= best_scores$youden ~ FALSE,
    direction == "T<F" & crank < best_scores$youden ~ FALSE,
    TRUE ~ NA_character_
  ),
    predict_closest_tl = case_when(
      direction == "T>F" & crank >= best_scores$closest_tl ~ TRUE,
      direction == "T>F" & crank < best_scores$closest_tl ~ FALSE,
      direction == "T<F" & crank >= best_scores$closest_tl ~ FALSE,
      direction == "T<F" & crank < best_scores$closest_tl ~ FALSE,
      TRUE ~ NA_character_
  ))  -> predict_table
  return (predict_table)
}