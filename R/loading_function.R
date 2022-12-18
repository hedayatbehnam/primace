#' showing progressbar during loading a function
#' @param message message to display in progressbar
#' @importFrom shiny withProgress setProgress
#' @export
loadingFunc <- function(message='Loading ...') { 
  # Creating progress (bottom right of screen)
  withProgress(min=1, max=15, expr={
    for(i in 1:15) {
      setProgress(message,
                  detail = 'This may take a while...',
                  value=i)
      Sys.sleep(0.05)
    }
  })
}
