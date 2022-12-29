#' @title Final Prediction
#' @description Prediction of each observation according to best points found by youden and closest topleft method.
#' @importFrom dplyr mutate group_by summarize select
#' @param predict_table predicted table of crank scores of observations
#' @param best_scores result of survROC function 
#' @param target whether time and status variables are available
#' @return predicted table according to best cut-off points of youden index and closest top left point
#' @export
final_predict <- function(predict_table, best_scores, target){
  if (target){
    status <- crank <- youden <- closest.topleft <- NULL
    predict_table %>% mutate(status_time = case_when(
      time < time & status == TRUE ~ TRUE,
      TRUE ~ FALSE)) %>% group_by(status) %>% summarize(mean = mean(crank), n=n()) -> status_crank
    direction <- ifelse(status_crank$mean[status_crank$status==TRUE] > status_crank$mean[status_crank$status==FALSE],"T>F","T<F")
    predict_table %>% mutate(id = seq(1,nrow(predict_table)),
      youden = case_when(
        direction == "T>F" & crank >= best_scores$youden ~ "TRUE",
        direction == "T>F" & crank < best_scores$youden ~ "FALSE",
        direction == "T<F" & crank >= best_scores$youden ~ "FALSE",
        direction == "T<F" & crank < best_scores$youden ~ "FALSE",
      TRUE ~ NA_character_),
      closest.topleft = case_when(
        direction == "T>F" & crank >= best_scores$closest.tl ~ "TRUE",
        direction == "T>F" & crank < best_scores$closest.tl ~ "FALSE",
        direction == "T<F" & crank >= best_scores$closest.tl ~ "FALSE",
        direction == "T<F" & crank < best_scores$closest.tl ~ "FALSE",
        TRUE ~ NA_character_)) %>% dplyr::select(id, crank,status, youden, closest.topleft) -> predict_table
  } else {
      predict_table %>% mutate(id = seq(1,nrow(predict_table)),
          youden = case_when(
             crank >= best_scores$youden ~ "TRUE",
             crank < best_scores$youden ~ "FALSE",
             TRUE ~ NA_character_),
          closest.topleft = case_when(
            crank >= best_scores$closest.tl ~ "TRUE",
            crank < best_scores$closest.tl ~ "FALSE",
            TRUE ~ NA_character_)) %>% dplyr::select(id, crank, youden, closest.topleft) -> predict_table
  }
  return (predict_table)
  
}