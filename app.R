# Runner file
library(shiny)
source('R/server.R')
source('R/ui.R')
# runApp(appDir = './R/')
shinyApp(ui = ui, server = server)