#' @title Best Point Finder
#' @description Finding best point of ROC curve according to youden and closest topleft method.
#' @param c c_rank scores
#' @param se sensitivity
#' @param sp specificity
#' @return A list containing youden index and closest topleft points
best_point <- function(c, se, sp){
  df <- data.frame(Cutoff = c,
                   Se = se,
                   Sp = sp,
                   yI = se+sp-1,
                   ctl = sqrt((1-se)**2 + (1-sp)**2))
  return (list(youden = df$Cutoff[df$yI == max(df$yI)],
          closest.tl = df$Cutoff[df$ctl == min(df$ctl)]))
}