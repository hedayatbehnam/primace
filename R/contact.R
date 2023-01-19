#' Contacts Sidebar
#' UI sidebar of contacts tab
#' @param id id of module
#' @noRd
contactSidebar <- function(id){
  menuItem("Contact", tabName = "contact", icon = icon("phone"))
}
#' Contact UI
#' UI for contacts  tab
#' @param id id of module
#' @noRd
contactsUI <- function(id){
  tabItem(tabName = "contact",
          fluidRow(box(width=12, status = "primary",solidHeader = F, id='custom-box',
                       p(span("Contact", style="font-weight:bold; 
                                    font-size:24px;")), hr(),
                       strong("Phone: "), "+98-21-88029600", br(),
                       strong("Email: "),"email@thc.tums.ac.ir, 
                          dr.hedayatb@gmail.com", br(),
                       strong("Address: "), "Tehran Heart Center, 
                          Kargar St. Jalal al-Ahmad Cross, Tehran, Iran",br(),
                       strong("Zip Code: "), "1411713138")
          ))
}

