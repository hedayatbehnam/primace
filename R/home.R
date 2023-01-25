#' Home Sidebar
#' UI sidebar of home tab
#' @param id id of module
#' @noRd
homeSidebar <- function(id){
  menuItem("Home", tabName = "home", icon = icon("home"))
}
#' Home UI
#' UI for home
#' @param id id of module
#' @noRd
homeUI <- function(id){
  tabItem(tabName = "home",
          br(),
          fluidRow(column(width=10, offset = 1,box(
            id='custom-box',width=12,  solidHeader = F,status = "primary",
            "PRIMACE Is A Machine Learning Prediction Tool for First Year Survival 
            Following Primary Percutaneous Coronary Intervention", 
            br(),class="title"))), hr(),
          fluidRow(solidHeader = F, column(width = 10, offset=1, align="center",
                   box(id='custom-box', width=12, status = "primary", 
                       solidHeader = F,img(src='logothc.png',align = "center", width=200),br(),
                       p("Tehran Heart Center", class="thc-logo-text"),
                       p("Artificial Intelligence Division",
                         class="thc-logo-subtext"), class='title'))), hr(),
          fluidRow(column(width=5, offset=1,box(width =12, id='custom-box',solidHeader = F, status="primary",
                              "Using Survival Random Forest Machine Learning Model
                              to Predict Outcome with provided data in file format of .RDS, 
                              .csv, .sav, .xlsx ",class="title")),
                   column(width = 5,box(width = 12,id = 'custom-box',solidHeader = F, status = "primary",
                              "An Online Machine Learning Tool to Predict First 
                              Year Major Adverse Cardiovascular Events  
                              Following Primary Percutaneous
                              Coronary Intervention", class="title"))))
}

