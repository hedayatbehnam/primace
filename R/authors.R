#' Authors Sidebar
#' UI sidebar of authors tab
#' @param id id of module
#' @noRd
authorsSidebar <- function(id){
  menuItem("Authors", tabName = "authors", icon = icon("pencil-alt"))
}
#' Authors UI
#' UI for authors
#' @param id id of module
#' @noRd
authorsUI <- function(id){
  tabItem(tabName = "authors",
          fluidRow(box(width = 12, id='custom-box',status = "primary",solidHeader = F,
                       p(span("Authors and Affiliations", style="font-weight:bold; 
                    font-size:24px;")),hr(),
                       "Yaser Jenab"," MD", tags$sup("1"),br(),
                       "Behnam Hedayat, MD", tags$sup("2"), br(),
                       "Amirali Karimi, MD", tags$sup("3"), br(),
                       "Sarah Taaghi, MD", tags$sup("4"),br(),
                       "Seyyed Mojtaba Ghorashi, MD", tags$sup("5"),br(),
                       "Hamed Ekhtiari, MD", tags$sup("6"),br(),
                       hr(),
                       "1. Professor of Cardiology, Fellowship of Interventional Cardiology, 
                        Tehran Heart Center, 
                        Tehran University of Medical Sciences", br(),
                       "2. Assistant Professor of Cardiology, 
                        Tehran Heart Center, 
                        Tehran University of Medical Sciences, Tehran, Iran.", br(),
                       "3. School of medicine, Tehran University of Medical Sciences, 
                        Tehran, Iran", br(),
                       "4. Assistant Professor of Cardiology,
                        Rasoul Akram Hospital,
                        Iran University of Medical Sciences,
                        Tehran, Iran",br(),
                       "5. Cardiovascular Disease Research Institute,
                        Tehran Heart Center, 
                        Tehran University of Medical Sciences, Tehran, Iran.",br(),
                       "6. Department of Psychiatry, 
                        University of Minnesota, Minneapolis, MN, USA",
                       br(),hr(),
                       span("Correspondence:", style="font-weight:bold"),br(), 
                       "Sarah Taaghi, ", br(), "Assistant professor of cardiology", 
                       br(),
                       "Rasoul Akram Hospital, ", br(), 
                       "Iran University of Medical Sciences,", br(),
                       "Tehran, Iran.")
          ))
}

