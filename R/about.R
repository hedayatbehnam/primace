#' About Sidebar
#' UI sidebar of about tab
#' @param id id of module
#' @noRd
aboutSidebar <- function(id){
  menuItem("About", tabName = "about", icon = icon("info"))
}
#' About UI
#' UI for about
#' @param id id of module
#' @noRd
aboutUI <- function(id){
  tabItem(tabName = "about",
          fluidRow(box(width=12, status="primary",solidHeader = F,id="custom-box",
                       p(span("About", style="font-weight:bold; font-size:24px;")))
          ))
}

