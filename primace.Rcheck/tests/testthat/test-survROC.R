test_that("survROC test", {
  shiny::testServer(server, {
    vars <- shiny::reactiveValues()
    vars$time <- 91
    predTbl_pass <- data.frame(time=c(310,175,360,221,16,18,111,212,335,352),
                               status=c(TRUE,TRUE,FALSE,TRUE,TRUE,FALSE,TRUE,TRUE,TRUE,TRUE),
                               marker=c(3,3,12,8,12,3,8,12,3,11))
    
    predTbl_fail <- data.frame(time=c(295,323,113,43,319,120,262,302,117,260),
                               status=c(FALSE, TRUE, TRUE,FALSE,TRUE,TRUE,FALSE,FALSE,TRUE,FALSE),
                               marker=c(11,6,7,9,4,7,2,11,11,9))
  
    vars$predTbl <- predTbl_pass
    expect_named(survROC(Stime=vars$predTbl$time,status=vars$predTbl$status,marker=vars$predTbl$marker,
                         predict.time=vars$time,span=0.08), c("cut.values", "TPR", "FPR", "Specificity",
                                                          "predict.time", "Survival", "AUC"))
    
    vars$predTbl <- predTbl_fail
    expect_error(survROC(Stime=vars$predTbl$time,status=vars$predTbl$status,marker=vars$predTbl$marker,
                         predict.time=vars$time,span=0.08))
    
  })
  
})
