#' for each process one indicator of reactiveValue is created eg. perfMetrics with different
#' values when is non proessessed or complete to change text in each section before and after process
#' @param name name of variable
#' @param value specific value of name input
#' @param content check content of output
#' @param output output set of Shiny
#' @importFrom shiny reactive outputOptions
#' @export
reactiveVal_output <- function(name, value, content, output){
    # Change the values of each reactiveVal indicator
    name[[value]] <- content
    output[[value]] <- reactive({
      return(name[[value]])
    })
    outputOptions(output, value, suspendWhenHidden=F)
}