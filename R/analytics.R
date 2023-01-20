#' @include data.R
NULL
#' Analytics Sidebar
#' UI sidebar for Showing descriptive analysis on current dataset
#' @param id id of module
#' @noRd
analyticsSidebar <- function(id){
  menuItem("Analytics", tabName = "analytics", icon = icon("chart-pie", verify_fa = FALSE))
}
#' Analytics UI
#' UI for Showing descriptive analysis on current dataset
#' @param id id of module
#' @noRd
analyticsUI <- function(id){
  # test_set <- suppressWarnings(dataset_modification(test_set))
  tabItem(tabName = "analytics",style="overflow:hidden;",
          fluidRow(box(title = strong("Descriptive Analysis of Train, Test and Total Data"),width=12, status = "primary", solidHeader = F, id="custom-box",
                       column(3,selectInput(inputId = NS(id,"data_select"),label = "Select Dataset", selected = "Total", choices = c("Total", "Train","Test"))))),
          fluidRow(box(width=12, status="primary",solidHeader = F, id="custom-box",
                       p(span("Analytics", style="font-weight:bold; font-size:24px;")),
                       "Descriptive analysis of latest dataset is provided here")),
          fluidRow(infoBox(title = "Number of Observations", value = textOutput(NS(id, "obs_num")),width = 6, color = "blue"),
                   infoBox(title = "Mean Age of Patients", value = textOutput(NS(id, "age_mean")),width = 6, color = "purple", icon = icon("calendar"))),
          fluidRow(infoBox(title = "Number of MACE", value = textOutput(NS(id, "mace_num")), width = 6, color = "red", icon = icon("skull-crossbones")),
                   infoBox(title = "Mean Time to MACE", value = textOutput(NS(id,"time_mean")),width = 6, icon = icon("clock"),color = "navy")),
          fluidRow(box(id="custom-box",solidHeader = F, status = "primary", width = 6,
                       uiOutput(NS(id,"varnames_num")),
                       uiOutput(NS(id,"varnames_fct")))),
          fluidRow(box(height = 500,id="custom-box",solidHeader = F, status = "primary", 
                       width = 6, plotOutput(outputId = NS(id, "plotHist"), height=500))))
}
#' Analytics Server
#' Server side of analyticsUI
#' @importFrom forcats fct_collapse fct_drop
#' @param id id of module
#' @noRd
analyticsServer <- function(id){
  moduleServer(id, function(input, output, session){
    if (Sys.getenv("s3") != ""){
      print(Sys.getenv("s3"))
      s3 <- Sys.getenv("s3")
      s3_data <- s3$get_object(Bucket = "aiworld", Key = "dataset/dataset.RDS")
      s3_train <-s3$get_object(Bucket = "aiworld", Key = "dataset/train.RDS")
      s3_test <- s3$get_object(Bucket = "aiworld", Key = "dataset/test.RDS")
      data <- "data.rds"
      train <- "train.rds"
      test <- "test.rds"
      writeBin(s3_data$Body,con=data)
      writeBin(s3_train$Body,con=train)
      writeBin(s3_test$Body,con=test)
      data <- readRDS(data)
      train <- readRDS(train)
      test <- readRDS(test)
      total <- c(train,test)
    } else {
      return (NULL)
    }
    dataVar <- reactiveValues()
    observeEvent(input$data_select, {
        req(total)
        if (input$data_select == "Total") dataVar$filter_row <- total else if (input$data_select=="Train") dataVar$filter_row <- train else dataVar$filter_row <- test 
        dataVar$dataset <- data %>% dplyr::slice(dataVar$filter_row)
    })
    output$varnames_num <- renderUI({
        req(dataVar$dataset)
        selectInput(inputId = NS(id, "var"), label = "Select Variable", selected = "Age", choices = names(dataVar$dataset %>% select_if(is.numeric)))
    })
    output$varnames_fct <- renderUI({
        req(dataVar$dataset)
        selectInput(inputId = NS(id, "group"), label = "Select Group", selected = "Gender", choices = names(dataVar$dataset %>% select_if(is.factor)))
    })
    output$plotHist <- renderPlot({
      req(input$var)
      ggplot(dataVar$dataset, aes_string(x=input$var, fill=input$group), height=500) +
        geom_histogram(aes(y=..density..))+
        geom_density(alpha=0.2)+
        theme(plot.margin = margin(0, 2,100,2))
    },height=500, res=96, width="auto")
    output$obs_num <- renderText({if (req(dataVar$dataset)) nrow(dataVar$dataset)})
    output$mace_num <- renderText({req(dataVar$dataset) 
      round(as.numeric(table(dataVar$dataset$First_MACE_bin))[2],3)})
    output$time_mean <- renderText({req(dataVar$dataset) 
      paste(round(mean(dataVar$dataset$Time_to_MACE[dataVar$dataset$First_MACE_bin==1]),2), "days")})
    output$age_mean <- renderText({req(dataVar$dataset) 
      round(mean(dataVar$dataset$Age),2)})
  })
}
              
