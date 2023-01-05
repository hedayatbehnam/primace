#' @title Manual Predictor
#' @description Prediction function for manually provided features
#' @param input input set by Shiny
#' @return a dataframe containing user provided features of a patient
manual_prediction <- function(input){
  manual_features <- data.frame(
    Clopidogrel = input$Clopidogrel,
    Pain_to_Door = input$Pain_to_Door,
    Ca.ch.A = input$Ca.ch.A,
    Nitrate = input$Nitrate,
    HDL = input$HDL,
    LDL = input$LDL,
    TG = input$TG,
    BMI = input$BMI,
    Cr = input$Cr,
    Hb = input$Hb,
    Statines = input$Statines,
    COPD = input$COPD,
    ASA = input$ASA,
    Betablocker = input$Betablocker,
    ACEinh_ARB = input$ACEinh_ARB,
    HTN = input$HTN,
    DM = input$DM,
    FH = input$FH,
    IHD = input$IHD,
    Gender = input$Gender,
    Age = input$Age,
    CS = input$CS, 
    Block = input$Block,
    Cardiogenicshock = input$Cardiogenicshock,
    Door_to_Device = input$Door_to_Device,
    Opium_bin = input$Opium_bin,
    First_MACE_bin = 0, 
    Time_to_MACE = 0
  )
  manual_features %>% mutate_if(is.character, as.numeric) -> manual_features
  return (manual_features)
}