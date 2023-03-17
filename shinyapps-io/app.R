library(shiny)

ui <- navbarPage(title = tags$div("PRIMACE Prediction Tool", 
                                  style="font-size:18px; font-weight:bold;"),
      tags$p("Sorry, This web page has been relocated permanantly to https://primace.aikadeh.com",
             style="font-size:18px; font-weight:bold;"), br(),
      tags$p("Click on the link below to redirect to PRIMACE page:"),
      tags$a(href="https://primace.aikadeh.com", "PRIMACE Webapp link", 
             style="font-size:20px; font-weight:bold;")      
)

server <- function(input, output) {

}

shinyApp(ui = ui, server = server)
