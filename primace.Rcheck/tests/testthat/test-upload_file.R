libs <- c("writexl", "haven", "readr")
suppressMessages(sapply(libs, library, character.only=T))
data <- data_generator(type="standard")
data_less <- data_generator(type="less")
data_less
data_more <- data_generator(type="more")
data_diff <- data %>% dplyr::rename(differentVar = Clopidogrel)
data_noTarget <- data %>% dplyr::select(-c(Time_to_MACE, First_MACE_bin))
test_that("upload_file csv test 1",{
  shiny::testServer(server, {
    csv <- tempfile(fileext = ".csv")
    
    write.csv(data, csv, row.names = F)
    loadFile_csv <- data.frame(name="sample",size=file.size(csv),type="csv", datapath=csv)
    session$setInputs(loadFile=loadFile_csv)
    expect_equal(class(upload_data(session$input)$survData), "data.frame")
    expect_named(upload_data(session$input)$survData, names(data))
    expect_false(upload_data(session$input)$target)

    write.csv(data_less, csv, row.names = F)
    loadFile_csv <- data.frame(name="sample",size=file.size(csv),type="csv", datapath=csv)
    session$setInputs(loadFile=loadFile_csv)
    expect_equal(upload_data(session$input), "mismatch")
    
    write.csv(data_more, csv, row.names = F)
    loadFile_csv <- data.frame(name="sample",size=file.size(csv),type="csv", datapath=csv)
    session$setInputs(loadFile=loadFile_csv)
    expect_equal(upload_data(session$input), "mismatch")
    
    write.csv(data_diff, csv, row.names = F)
    loadFile_csv <- data.frame(name="sample",size=file.size(csv),type="csv", datapath=csv)
    session$setInputs(loadFile=loadFile_csv)
    expect_equal(upload_data(session$input), "mismatch")
    
    write.csv(data_noTarget, csv, row.names = F)
    loadFile_csv <- data.frame(name="sample",size=file.size(csv),type="csv", datapath=csv)
    session$setInputs(loadFile=loadFile_csv)
    expect_equal(class(upload_data(session$input)$survData), "data.frame")
    expect_true(upload_data(session$input)$target)
    
  })
})
test_that("upload_file xlsx test 2",{
  shiny::testServer(server, {
    xlsx <- tempfile(fileext = ".xlsx")
  
    write_xlsx(data, xlsx)
    loadFile_xlsx <- data.frame(name="sample",size=file.size(xlsx),type="xlsx", datapath=xlsx)
    session$setInputs(loadFile=loadFile_xlsx)
    expect_equal(class(upload_data(session$input)$survData)[1], "tbl_df")
    expect_named(upload_data(session$input)$survData, names(data))
    expect_false(upload_data(session$input)$target)

    write_xlsx(data_less, xlsx)
    loadFile_xlsx <- data.frame(name="sample",size=file.size(xlsx),type="xlsx", datapath=xlsx)
    session$setInputs(loadFile=loadFile_xlsx)
    expect_equal(upload_data(session$input), "mismatch")
    
    write_xlsx(data_more, xlsx)
    loadFile_xlsx <- data.frame(name="sample",size=file.size(xlsx),type="xlsx", datapath=xlsx)
    session$setInputs(loadFile=loadFile_xlsx)
    expect_equal(upload_data(session$input), "mismatch")
    
    write_xlsx(data_diff, xlsx)
    loadFile_xlsx <- data.frame(name="sample",size=file.size(xlsx),type="xlsx", datapath=xlsx)
    session$setInputs(loadFile=loadFile_xlsx)
    expect_equal(upload_data(session$input), "mismatch")
    
    write_xlsx(data_noTarget, xlsx)
    loadFile_xlsx <- data.frame(name="sample",size=file.size(xlsx),type="xlsx", datapath=xlsx)
    session$setInputs(loadFile=loadFile_xlsx)
    expect_equal(class(upload_data(session$input)$survData)[1], "tbl_df")
    expect_true(upload_data(session$input)$target)
  })
})
test_that("upload_file rds test 3",{
  shiny::testServer(server, {
    rds <- tempfile(fileext = ".rds")
    
    write_rds(data, rds)
    loadFile_rds <- data.frame(name="sample",size=file.size(rds),type="rds", datapath=rds)
    session$setInputs(loadFile=loadFile_rds)
    expect_equal(class(upload_data(session$input)$survData)[1], "data.frame")
    expect_named(upload_data(session$input)$survData, names(data))
    expect_false(upload_data(session$input)$target)
    
    
    write_rds(data_less, rds)
    loadFile_rds <- data.frame(name="sample",size=file.size(rds),type="rds", datapath=rds)
    session$setInputs(loadFile=loadFile_rds)
    expect_equal(upload_data(session$input), "mismatch")
    
    write_rds(data_more, rds)
    loadFile_rds <- data.frame(name="sample",size=file.size(rds),type="rds", datapath=rds)
    session$setInputs(loadFile=loadFile_rds)
    expect_equal(upload_data(session$input), "mismatch")
    
    write_rds(data_diff, rds)
    loadFile_rds <- data.frame(name="sample",size=file.size(rds),type="rds", datapath=rds)
    session$setInputs(loadFile=loadFile_rds)
    expect_equal(upload_data(session$input), "mismatch")
    
    write_rds(data_noTarget, rds)
    loadFile_rds <- data.frame(name="sample",size=file.size(rds),type="rds", datapath=rds)
    session$setInputs(loadFile=loadFile_rds)
    expect_equal(class(upload_data(session$input)$survData)[1], "data.frame")
    expect_true(upload_data(session$input)$target)
  })
})
test_that("upload_file sav test 4",{
  shiny::testServer(server, {
    sav <- tempfile(fileext = ".sav")
    
    write_sav(data, sav)
    loadFile_sav <- data.frame(name="sample",size=file.size(sav),type="sav", datapath=sav)
    session$setInputs(loadFile=loadFile_sav)
    expect_equal(class(upload_data(session$input)$survData)[1], "data.frame")
    expect_named(upload_data(session$input)$survData, names(data))
    expect_false(upload_data(session$input)$target)
    
    write_sav(data_less, sav)
    loadFile_sav<- data.frame(name="sample",size=file.size(sav),type="sav", datapath=sav)
    session$setInputs(loadFile=loadFile_sav)
    expect_equal(upload_data(session$input), "mismatch")
    
    write_sav(data_more, sav)
    loadFile_sav <- data.frame(name="sample",size=file.size(sav),type="sav", datapath=sav)
    session$setInputs(loadFile=loadFile_sav)
    expect_equal(upload_data(session$input), "mismatch")
    
    write_sav(data_diff, sav)
    loadFile_sav <- data.frame(name="sample",size=file.size(sav),type="sav", datapath=sav)
    session$setInputs(loadFile=loadFile_sav)
    expect_equal(upload_data(session$input), "mismatch")
    
    write_sav(data_noTarget, sav)
    loadFile_sav <- data.frame(name="sample",size=file.size(sav),type="sav", datapath=sav)
    session$setInputs(loadFile=loadFile_sav)
    expect_equal(class(upload_data(session$input)$survData)[1], "data.frame")
    expect_true(upload_data(session$input)$target)
  })
})
