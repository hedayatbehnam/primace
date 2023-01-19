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
  test_set <- readRDS(paste0(Sys.getenv("root_absPath"),"/R/datasets/dataset.RDS"))
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
                       selectInput(inputId = NS(id, "var"), label = "Select Variable", selected = "Age",choices = names(test_set %>% select_if(is.numeric))),
                       selectInput(inputId = NS(id, "group"), label = "Select Group", selected = "Gender", choices = names(test_set %>% select_if(is.factor))))),
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
    data <- readRDS(paste0(Sys.getenv("root_absPath"), "/R/datasets/dataset.RDS"))
    train <- readRDS(paste0(Sys.getenv("root_absPath"), "/R/datasets/train.RDS"))
    test <- readRDS(paste0(Sys.getenv("root_absPath"), "/R/datasets/test.RDS"))
    total <- c(train, test)
    dataVar <- reactiveValues()
    observeEvent(input$data_select, {
        if (input$data_select == "Total") dataVar$filter_row <- total else if (input$data_select=="Train") dataVar$filter_row <- train else dataVar$filter_row <- test 
        dataVar$dataset <- data %>% dplyr::slice(dataVar$filter_row)
    })
    output$plotHist <- renderPlot({
      ggplot(dataVar$dataset, aes_string(x=input$var, fill=input$group), height=500) +
        geom_histogram(aes(y=..density..))+
        geom_density(alpha=0.2)+
        theme(plot.margin = margin(0, 2,100,2))
    },height=500, res=96, width="auto")
    output$obs_num <- renderText({nrow(dataVar$dataset)})
    output$mace_num <- renderText({round(as.numeric(table(dataVar$dataset$First_MACE_bin))[2],3)})
    output$time_mean <- renderText({paste(round(mean(dataVar$dataset$Time_to_MACE[dataVar$dataset$First_MACE_bin==1]),2), "days")})
    output$age_mean <- renderText({round(mean(dataVar$dataset$Age),2)})
  })
}
              
