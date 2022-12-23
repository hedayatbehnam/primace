library(mlr3extralearners)
library(readr)
test_that("load_model test", {
  path <- tempdir()
  tmp.rf_input <- list(models = "Survival Random Forest")
  tmp.xgb_input <- list(models = "Survival Xgboost")
  tmp.rf_model <- mlr3extralearners::lrn("surv.rfsrc")
  tmp.xgb_model <- mlr3extralearners::lrn("surv.xgboost")
  tmp.rf_file <- tempfile(pattern = "rf_tmp",tmpdir = path, fileext = ".RDS")
  tmp.xgb_file <- tempfile(pattern = "xgb_tmp",tmpdir = path,fileext = ".RDS")
  readr::write_rds(tmp.rf_model,tmp.rf_file)
  readr::write_rds(tmp.xgb_model,tmp.xgb_file)
  expect_equal(class(load_model(input = tmp.rf_input,
                                rf_model = tmp.rf_file))[1],
               "LearnerSurvRandomForestSRC")
  expect_equal(class(load_model(input = tmp.xgb_input,
                                xgb_model = tmp.xgb_file))[1], 
               "LearnerSurvXgboost")
  lapply(X = list(tmp.rf_file, tmp.xgb_file), FUN = file.remove)
})
