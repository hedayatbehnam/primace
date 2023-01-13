test_that("best_point test", {
  shiny::testServer(server, {
    vars <- shiny::reactiveValues()
    vars$time <- 91
    predTbl_pass <- data.frame(time=c(310,175,360,221,16,18,111,212,335,352),
                               status=c(TRUE,TRUE,FALSE,TRUE,TRUE,FALSE,TRUE,TRUE,TRUE,TRUE),
                               marker=c(3,3,12,8,12,3,8,12,3,11))
    vars$predTbl <- predTbl_pass
    vars$surv_roc=survROC(Stime=vars$predTbl$time,status=vars$predTbl$status,marker=vars$predTbl$marker,
                         predict.time=vars$time,span=0.08)
    expect_named(best_point(c = vars$surv_roc$cut.values,se = vars$surv_roc$TPR,
                            sp = vars$surv_roc$Specificity),c("youden", "closest.tl"))
  })
  
})
