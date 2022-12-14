#' @title Data Preprocessing
#' @description module to perform preprocessing on dataset
#' @importFrom foreign read.spss
#' @importFrom stats median
#' @importFrom mlr3tuning tnr trm
#' @return uploaded preprocessed dataset
#' @export
preprocessing <- function(){
  dataset <- read_data()
  df_modified <- suppressWarnings(dataset_modification(dataset))
  missing_dataframe <- check_missings(df_modified) 
  dataset_low_miss <- complete_case(missing_dataframe[3])
  dataset_NCC_for_analysis <- as.data.frame(dataset_low_miss[3])
  dataset_ncc_corr <- select(dataset_NCC_for_analysis, -c("Time_to_LastFU","Opiumdurationm","Opium","OpiumTypeOfConsumption",
                                                          "File247","SmokingPacky","Smokingquittimem","First_MACE","My_file",
                                                          "GPIIBIIIA.inf.h" ,"Next_Plan", "TVR", "No","Patient.Code2","Encounter.ID",
                                                          "TLR", "CABG", "Mortality", "Death", "MI",
                                                          "Opium_bin_num", "TCH", "PCI_Result"))
  imp_miss_dataset <- missing_impute(dataset_ncc_corr)
  one_year_dataset <- first_year_MACE(imp_miss_dataset)
  task <- TaskSurv$new(id = 'surv-task', backend =one_year_dataset, time = 'Time_to_MACE', event = 'First_MACE_bin')
  train_set <- sample(task$nrow, 0.8 * task$nrow)
  test_set <- setdiff(seq_len(task$nrow), train_set)
  inner.rsmp <- rsmp("cv", folds = 2)
  outer.rsmp <- rsmp("cv", folds = 2)
  measure <- msr("surv.cindex")
  tuner <- tnr("random_search")
  terminator <- trm("evals", n_evals = 2)
  set.seed(1234)
  ncores <- as.integer(system("nproc --all", intern = T))
  rfsrc.learner<- lrn("surv.rfsrc", ntree = 500, block.size = 1, cores=ncores)
  rfsrc.search_space <- ps(mtry = p_int(lower = 2, upper = 15),
                           nodesize = p_int(lower = 1, upper = 30),
                           nodedepth = p_int(lower = 1, upper = 15))
  rfsrc.instance <- TuningInstanceSingleCrit$new(
    task = task,
    learner = rfsrc.learner,
    resampling = inner.rsmp,
    measure = measure,
    search_space = rfsrc.search_space,
    terminator = terminator)
  tuner$optimize(rfsrc.instance)
  rfsrc_opt <- rfsrc.instance$clone(deep = T)
  best.uhash <- rfsrc_opt$archive$data[which(rfsrc_opt$archive$data$surv.cindex == max(rfsrc_opt$archive$data$surv.cindex))]$uhash
  best.learner <- rfsrc_opt$archive$learner(uhash=best.uhash)
  print(best.learner)
  prev_model <- load_model(input=list(models="Survival Random Forest"),
                           rf_model="R/models/rfsrc.learner_mod.RDS")
  design <- benchmark_grid(
    tasks = task,
    learners = c(prev_model, best.learner),
    resamplings = rsmp("cv", folds = 2)
  )
  bmr <- benchmark(design)
  measure <- msr("surv.cindex")
  tab <- bmr$aggregate(measure)
  # autoplot(bmr)pr
  print(tab)
}
