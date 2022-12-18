#' The Shiny App Server.
#' options(shiny.maxRequestSize=30*1024^2)
#' Installing non-CRAN dependencies -----------------------------------------
#' This part is run for the first time during building process of shinyapps.
#' devtools::install_github(repo = "mlr-org/mlr3proba")
#' devtools::install_github("alan-turing-institute/distr6")
#' devtools::install_github("xoopR/param6")
#' devtools::install_github("xoopR/set6")
#' devtools::install_github("RaphaelS1/survivalmodels")
#' install.packages("randomForestSRC")
#' install.packages("pracma")
#' Uploading packages  -----------------------------------------------------
#' library(shiny); library(shinydashboard); library(foreign); library(readxl)
#' library(tools); library(pROC); library(ggplot2); library(dplyr); library(randomForestSRC)
#' library(pracma); library(xgboost); library(mlr3learners); library(mlr3extralearners)
#' library(mlr3proba); library(caret)
#' Import custom modules ---------------------------------------------------
#' source('R/modules/load_model.R', local = T); source('R/modules/loading_function.R', local=T)
#' source('R/modules/reactiveVal_output.R', local=T); source('R/modules/upload_file.R', local= T)
#' source('R/modules/predict_scores.R', local= T); source('R/modules/survROC.R', local= T)
#' source('R/modules/final_predict.R', local= T); source('R/modules/best_point.R', local= T)
#' source('R/modules/max_perf_calc.R', local= T); source('R/modules/manual_prediction.R')
#' @param input input set by Shiny.
#' @param output output set by Shiny.
#' @param session session set by Shiny.
#' @importFrom pROC ggroc roc
#' @importFrom ggplot2 xlab ylab geom_segment aes
#' @importFrom shiny reactiveValues renderDataTable observeEvent renderPlot
#' @export
server <- function(input, output, session) {
  varnames <- status <- crank <- NULL
  rv <- reactiveValues()
  rv$varnameComplete <- rv$perfMetrics <- rv$predMetrics <- FALSE
  reactiveVal_output(rv, 'perfMetrics', 'empty', output)
  reactiveVal_output(rv, 'predMetrics', 'empty', output)
  output$tableVarNames <- renderDataTable({ 
    varnames <<- readRDS("www/varnames.RDS")
    as.data.frame(varnames)
  }, options = list(pageLength=10, scrollX=TRUE) 
  )
  vars <- reactiveValues()
  observeEvent(input$predict_btn,{
    vars$model <- load_model(input)
    vars$data <- upload_data(input)
    vars$time <- case_when(
      input$time_select == "3rd Month" ~ 91,
      input$time_select == "6th Month" ~ 182,
      input$time_select == "9th Month" ~ 273,
      input$time_select == "12th Month" ~ 365.25
    )
    if (is.character(vars$data)){
      if (vars$data == "empty"){
        reactiveVal_output(rv, 'predMetrics', 'empty', output)
        reactiveVal_output(rv, 'perfMetrics', 'empty', output)
      } else if (vars$data == 'nonValid') {
        reactiveVal_output(rv, 'predMetrics', 'nonValid', output)
        reactiveVal_output(rv, 'perfMetrics', 'nonValid', output)
      } else if (vars$data == 'mismatch'){
        reactiveVal_output(rv, 'predMetrics', 'mismatch', output)
        reactiveVal_output(rv, 'perfMetrics', 'mismatch', output)
      }
    } else {
      reactiveVal_output(rv, 'predMetrics', 'complete', output)
      vars$predTbl <- predict_scores(data=vars$data$survData, model=vars$model)
      vars$surv_roc <- survROC(Stime=vars$predTbl$time, 
                               status=vars$predTbl$status,
                               marker=vars$predTbl$crank,
                               predict.time=vars$time,
                               span=0.08)
      vars$bestPoints <- best_point(c = vars$surv_roc$cut.values,
                                    se = vars$surv_roc$TPR,
                                    sp = vars$surv_roc$Specificity)
      vars$final_predict <- final_predict(predict_table = vars$predTbl, 
                                          best_scores = vars$bestPoints)
      if (!vars$data$target){
        vars$performance_result <- max_perf_calc(predict_table = vars$final_predict)
        loadingFunc(message = "initializing ROC plot...")
        reactiveVal_output(rv, 'perfMetrics', 'complete', output)
      } else {
        reactiveVal_output(rv, 'perfMetrics', 'noTarget', output)
      }
    }
  })
  output$predict_tbl <- renderDataTable({
    vars$final_predict %>% dplyr::select(-status)
  })
  output$performance <- renderDataTable({
    vars$performance_result
  })
  output$predict_plot <- renderPlot({
      ggroc(roc(vars$df$Total_MACE, vars$pred$Yes,
                ci=T, smooth=T, smooth.n=10,
                auc=T), legacy.axes = T, color="red") + 
        xlab("1-Specificity") + ylab("Sensitivity")+
        geom_segment(aes(x=0,y=0,xend = 1, yend = 1),
                     linetype = 2,col='black',
                     lwd=0.05)
  }, width="auto", height = 500, res = 96)
  observeEvent(input$man_predict_btn, {
    vars$man_df <- manual_prediction(input)
    vars$man_predict <- predict_scores(data=vars$man_df, model=load_model(input))
  })
  output$manual_predict_tbl <- renderDataTable({
    if(!is.null(vars$man_predict)){
    vars$man_predict %>% mutate_if(is.numeric, round, 3) %>% 
               dplyr::select(crank)}
  }, options = list(scrollX=TRUE, dom='t'))
}