#' Runner file
#' initializing app
#' @export
primace_init <- function(){
  devtools::load_all(".")
  shiny::runApp(appDir = "R/",port = 3838, host = "0.0.0.0")
}
  
