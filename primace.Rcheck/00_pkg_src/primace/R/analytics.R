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
  test_set <- tryCatch({readRDS(here("R/datasets/test_set.RDS"))},
                       error=function(e) print(e))
  test_set <- suppressWarnings(dataset_modification(test_set))
  tabItem(tabName = "analytics",style="overflow:hidden;",
          fluidRow(box(width=12, status="primary",solidHeader = F, id="custom-box",
                       p(span("Analytics", style="font-weight:bold; font-size:24px;")),
                       "Descriptive analysis of latest dataset is provided here",
                       class="usual-box-title")),
          fluidRow(infoBox(title = "Number of Observation", value = nrow(test_set),width = 6),
                   infoBox(title = "Mean Age of Patients", value = round(mean(test_set$Age),2),width = 6)),
          fluidRow(box(id="custom-box",class="usual-box-title",solidHeader = F, status = "primary", width = 6,
                       selectInput(NS(id, "var"), label = "Select Variable", selected = "Age",choices = names(test_set)),
                       selectInput(NS(id, "group"), label = "Select Group", selected = "Gender", choices = names(test_set)))),
          fluidRow(box(height = 500,id="custom-box",class="usual-box-title",solidHeader = F, status = "primary", 
                       width = 6,plotOutput(NS(id, "plotHist"), height=500))))
}
#' Analytics Server
#' Server side of analyticsUI
#' @importFrom forcats fct_collapse fct_drop
#' @param id id of module
#' @noRd
analyticsServer <- function(id){
  moduleServer(id, function(input, output, session){
    test_set <- tryCatch({readRDS(here::here("R/datasets/test_set.RDS"))},
                         error=function(e) readRDS(here::here("primace/R/datasets/test_set.RDS")))
    test_set <- suppressWarnings((dataset_modification(test_set)))
    output$plotHist <- renderPlot({
      ggplot(test_set, aes_string(x=input$var, fill=input$group), height=500) +
        geom_histogram(aes(y=..density..))+
        geom_density(alpha=0.2)+
        theme(plot.margin = margin(0, 2,100,2))
    },height=500, res=96, width="auto")
  })
}


              