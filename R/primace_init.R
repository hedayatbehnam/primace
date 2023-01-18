#' Runner file
#' initializing app
#' @export
primace_init <- function(){
  devtools::load_all(".")
  shiny::runApp(appDir = paste0(Sys.getenv("root_absPath"),"/R/"),port = 3838, host = "0.0.0.0")
}
  