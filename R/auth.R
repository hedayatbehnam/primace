#' authenticated Sidebar
#' 
#' UI sidebar for Showing authenticated page
#' 
#' @param id id of module
#' 
#' @noRd
authSidebar <- function(id){
  menuItem("Advanced", tabName = "advanced", icon = icon("sign-in", verify_fa = FALSE))
}

#' authenticated UI
#' 
#' UI for Showing authenticated page
#' 
#' @param id id of module
#' 
#' @noRd
authUI <- function(id){
    tabItem(tabName = "advanced", "Admin Dashboard")
}

#' authenticated Server
#' 
#' Server side of authUI
#' 
#' @param id id of module
#' 
#' @noRd
authServer <- function(id, cred_stat){
  moduleServer(id, function(input, output, session){
  })
}
              