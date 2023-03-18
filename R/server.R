#' The Shiny App Server.
#' An app to predict first year survival following primary percutaneous coronary intervention.
#' This app can be used to predict and assess performance of user's provided datasets,
#' based of containing target variables, it also provides manual prediction tool to predict a patient,
#' according to its features selected online.
#' @importFrom pROC ggroc roc
#' @importFrom ggplot2 xlab ylab geom_segment aes
#' @importFrom shiny reactiveValues renderDataTable observeEvent renderPlot
#' @importFrom utils globalVariables
#' @import shinydashboard
#' @import shinybusy
#' @import dplyr
#' @param input input set by Shiny.
#' @param output output set by Shiny.
#' @param session session set by Shiny.
#' @noRd
server <- function(input, output, session) {
  analyticsServer("analytics")
  status <- crank <- NULL
  rv <- reactiveValues()
  rv$varnameComplete <- rv$perfMetrics <- rv$predMetrics <- FALSE
  reactiveVal_output(rv, 'perfMetrics', 'empty', output)
  reactiveVal_output(rv, 'predMetrics', 'empty', output)
  vars <- reactiveValues()
  
  login <- FALSE
  USER <- reactiveValues(login = login)
  
  observe({ 
    if (USER$login == FALSE) {
      if (!is.null(input$login)) {
        if (input$login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          db <- suppressWarnings(system("printenv MARIADB_DB", intern = T))
          usr <- suppressWarnings(system("printenv MARIADB_USR", intern = T)) 
          tbl <- suppressWarnings(system("printenv MARIADB_TBL", intern = T)) 
          pass <- suppressWarnings(system("printenv MARIADB_PW", intern = T))
          host <- suppressWarnings(system("printenv MARIADB_HOST", intern = T))
          port <- suppressWarnings(system("printenv MARIADB_PORT", intern = T))
          
          tryCatch({conn <- dbConnect(RMariaDB::MariaDB(), user=usr, password=pass,
                            dbname=db, host= host, port=port)}, error=function(e) print(e))
          
          credentials <- tryCatch({mariadb_connect()}, error = function(e) return (sample_cred))
          
          if(length(which(credentials$username_id==Username))==1) { 
            pasmatch  <- credentials["passod"][which(credentials$username_id==Username),]
            pasverify <- password_verify(pasmatch, Password)
            if(pasverify) {
              rm(credentials)
              USER$login <- TRUE
            } else {
              shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
              shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
            }
          } else {
            shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
            shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
          }
        } 
      }
    }    
  })
  
  output$login_btn <- renderUI({
      actionButton(inputId = 'login_action', label = "Login", icon = icon("user"))
  })
  
  observeEvent(input$login_action, {showModal(modalDialog(
    title = "Login",easyClose = T, footer = modalButton("Cancel"), size="m",
      div(id = "loginpage", style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
          wellPanel(
            textInput("userName", placeholder="Username", label = tagList(icon("user"), "Username")),
            passwordInput("passwd", placeholder="Password", label = tagList(icon("unlock-alt"), "Password")),
            br(),
            div(
              style = "text-align: center;",
              actionButton("login", "SIGN IN", style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"),
              shinyjs::hidden(
                div(id = "nomatch",
                    tags$p("Incorrect username or password!",
                           style = "color: red; font-weight: 600; 
                                            padding-top: 5px;font-size:16px;", 
                           class = "text-center")))
            ))
      )

  ))
  })
  
  observeEvent(input$login,{
    if (USER$login) removeModal()
  })
  
  output$logbtn <- renderUI({
    if (USER$login) {
      tags$div(span(input$userName, class="log-btn-span"),actionButton(inputId = "logout", label="Logout", icon=icon("sign-out"), class="log-btn"))
    } else {
      tags$div(actionButton(inputId = 'login_action', label = "Login", icon = icon("user"),
                            class="log-btn"))
    }
  })
  
  shinyjs::onclick("logout", {
    shinyjs::runjs("javascript:window.location.reload(true)")
  })
  
  output$tableVarNames <- renderDataTable({ 
    primace::varnames
  }, options = list(pageLength=10, scrollX=TRUE) 
  )
  observeEvent(input$predict_btn,{
    vars$model <- load_model(input,
                             rf_model=paste0(Sys.getenv("root_absPath"),"/R/models/rfsrc.learner_mod.RDS"),
                             xgb_model=paste0(Sys.getenv("root_absPath"),"/R/models/xgboost.learner_mod.RDS"))
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
        shinybusy::notify_failure("Uploaded file should be in
                                                .csv, .rds, .xlsx or .sav format",
                                  position = "center-center",
                                  shinybusy::config_notify(clickToClose=T,width = '400px', fontWeight="bold",
                                                           fontSize = "16px", textColor = "white"))
      } else if (vars$data == 'mismatch'){
        reactiveVal_output(rv, 'predMetrics', 'mismatch', output)
        reactiveVal_output(rv, 'perfMetrics', 'mismatch', output)
        shinybusy::notify_failure("At least one variable in uploaded dataset is
                                              not in original training dataset.",
                                  position = "center-center",
                                  shinybusy::config_notify(clickToClose=T,width = '400px', fontWeight="bold",
                                                           fontSize = "16px", textColor = "white"))
      }
    } else {
      reactiveVal_output(rv, 'predMetrics', 'complete', output)
      vars$predTbl <- predict_scores(data=vars$data$survData, model=vars$model)
      if (!vars$data$target){
        vars$surv_roc <- survROC(Stime=vars$predTbl$time,
                                 status=vars$predTbl$status,
                                 marker=vars$predTbl$crank,
                                 predict.time=vars$time,
                                 span=0.08)
        vars$bestPoints <- best_point(c = vars$surv_roc$cut.values,
                                      se = vars$surv_roc$TPR,
                                      sp = vars$surv_roc$Specificity)
        vars$final_predict <- final_predict(predict_table = vars$predTbl,
                                            best_scores = vars$bestPoints,
                                            target=T)
        tryCatch({
          vars$performance_result <- max_perf_calc(predict_table = vars$final_predict) %>% 
            mutate_at(c("youden", "closest_topleft"), as.numeric) %>% 
            mutate_if(is.numeric, round , 3)
          loadingFunc(message = "initializing ROC plot...")
          reactiveVal_output(rv, 'perfMetrics', 'complete', output)
        }, error=function(e){
          shinybusy::notify_failure("Prediction columns has just one level, so confusin matrix is not provided.",
                                    position = "center-center",
                                    shinybusy::config_notify(clickToClose=T,width = '400px', fontWeight="bold",
                                                             fontSize = "16px", textColor = "white"))
          reactiveVal_output(rv, 'perfMetrics', 'noPerf', output)
        })
      } else {
        reactiveVal_output(rv, 'perfMetrics', 'noTarget', output)
        shinybusy::notify_failure("Because your data file does not contains target variable called
                                  Total_MACE, no performance assessment was conducted.",
                                  position = "center-center",
                                  shinybusy::config_notify(clickToClose=T,width = '400px', fontWeight="bold",
                                                           fontSize = "16px", textColor = "white"))
        bestScore <- list(youden=8, closest.tl=8)
        vars$final_predict <- final_predict(predict_table = vars$predTbl,
                                            best_scores = bestScore, target=F)
      }
    }
  })
  output$predict_tbl <- renderDataTable({
    vars$final_predict %>% dplyr::select(-all_of(status)) %>% mutate_if(is.numeric, round,3)
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
      bestScore <- list(youden=7.5, closest.tl=8)
      vars$final_predict <- final_predict(predict_table = vars$man_predict,
                                          best_scores = bestScore, target=F)
      tail(vars$final_predict, n=1) %>% mutate_if(is.numeric, round, 3)
    }
  }, options = list(scrollX=TRUE, dom='t'))
}
