library(mlr3extralearners); library(readr)
test_that("predict_score test", {
  fake_data <- data.frame(Clopidogrel = integer(),Pain_to_Door = integer(),Ca.ch.A = integer(),
    Nitrate = integer(),HDL = integer(),LDL = integer(),TG = integer(),BMI = integer(),Cr = double(),
    Hb = double(),Statines = integer(),COPD = integer(),ASA = integer(),Betablocker = integer(),
    ACEinh_ARB = integer(),HTN = integer(),DM = integer(),FH = integer(),IHD = integer(),
    Gender = integer(),Age = integer(),CS = integer(), Block = integer(),Cardiogenicshock = integer(),
    Door_to_Device = integer(),Opium_bin = integer(),Time_to_MACE = integer(),stringsAsFactors = F)
  fake_data <- as.data.frame(apply(fake_data, 2, function(x) sample(c(1,2),10,replace = T)))
  fake_data$First_MACE_bin <- sample(c(0,1), 10, replace=T)
  task <- mlr3proba::TaskSurv$new(id="id", backend=fake_data, time="Time_to_MACE", event="First_MACE_bin")
  train_set <- sample(task$nrow, 0.6 * task$nrow)
  test_set <- setdiff(seq_len(task$nrow), train_set)
  learner <- mlr3extralearners::lrn("surv.rfsrc")
  learner$train(task, row_ids = train_set)
  expect_equal(class(predict_scores(data = fake_data[test_set,], model = learner)), c("data.table", "data.frame"))
  rm(c(fake_data, task, train_set, test_set, learner))
})
