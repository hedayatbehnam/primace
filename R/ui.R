#' @include global.R styles.R analytics.R authors.R abstract.R home.R
NULL
#' User Interface
#' Main user interface of primace app
#' Using shinydashboard package to create a dashboard like tabbed UI
#' sidebar of main user interface
#' @noRd
sidebar <- dashboardSidebar(
  sidebarMenu(
    homeSidebar('home'),
    analyticsSidebar("analytics"),
    authorsSidebar("authors"),
    abstractSidebar('abstract'),
    menuItem("Prediction Tool", tabName = "prediction", icon = icon("wrench"),
             badgeLabel = "API", badgeColor = "purple"),
    contactSidebar('contacts'),
    aboutSidebar('about')
  )
)
#' body of main user interface
#' @noRd
body <- dashboardBody(
  shinybusy::add_busy_spinner(spin = "half-circle", position = "bottom-right", color="black",
                              margins = c("60%", "42%"), width = "70px", height = "70px"),
  style_ref(tags, "style"),
  # tagList(
  # tags$head(
  #   tags$link(rel="stylesheet", type="text/css",
  #             href=".css"))),
  tags$script(HTML("$('body').addClass('fixed');")),
  tabItems(
    homeUI('home'),
    analyticsUI("analytics"),
    authorsUI('authors'),
    abstractUI('abstract'),
    tabItem(tabName = "prediction",
        tabsetPanel(type="tabs", id = "predictTabs",
            tabPanel("Introduction", 
                fluidRow(box(title=strong("Prediction Tool"),solidHeader = F,
                         width=12,status="primary", collapsible = T, collapsed = F,
                            "Here a prediction tool is provided based on survival 
                            random forest trained on patients which 
                            underwent primary percutaneous coronary intervention(PCI), 
                            to predict major adverse cardiovascular event (MACE).",br(),
                            "You can upload your custom file from file input 
                            box bellow. At the moment Allowed format is *.rds, 
                            *.csv, *.sav and *.xlsx formats.",br(),
                            "Because the models have been trained with specific names 
                            of features, your dataset features names should be 
                            transformed to the names provided in 'Variables Names' 
                            box bellow to enable prediction.")), br(),
                # conditionalPanel(condition = "output.varnameComplete",
                       fluidRow(box(title=strong("Variables Names"),
                                    id="varnames",width=12,
                                    status="primary", collapsible = T, collapsed = F,
                                    dataTableOutput("tableVarNames")))
                # ),
                # conditionalPanel(condition = "!output.varnameComplete",
                #        fluidRow(box(title=strong("Variables Names"),
                #                     id="varnames",width=12,
                #                     status="primary", collapsible = T, collapsed = F,
                #                     "Loading variables, It
                #                     may take a while..."))
                # ),
            ),
            tabPanel("Data Prediction",
                fluidRow(box(title=strong("Upload File"),width=12, 
                         status = "primary",
                         collapsible = T, collapsed = F,
                         p("You can upload your data with *.rds, *.csv, *.sav or 
                          *.xlsx formats. Please wait untill `Upload complete` 
                          appears in blue bar under file input box. Based on 
                          network connection and file volume, it may takes
                          some times for uploading file to be completed.
                          If you do not have a file to upload, you can download 
                           sample new test set available in git repository of 
                           primace app in git@github.com:hedayatbehnam/primace.git", 
                          class="predict-text"),
                         "If you do not upload a file, a default sample test set with
                         known target vriable would be used instead for analysis",
                         hr(),
                         fileInput("loadFile", label = "Please Upload Your Data:",
                                   width="300px"),
                         column(6,selectInput("models", "Please Select a Model", 
                                choices = c("Survival Random Forest"), 
                                selected = "Survival Random Forest", width = '200px'),
                                p(strong("Click predict... button bellow to initiate 
                                  prediction")),
                                
                                actionButton("predict_btn", label = "Predict...", 
                                             width = "100px")),
                         column(6, selectInput("time_select", "Please Select a Prediction Time",
                                               choices = c("3rd Month", "6th Month", 
                                                           "9th Month", "12th Month"),
                                               selected = "12th Month", width='200px')))),
                # fluidRow(uiOutput("performanceState")),
                conditionalPanel(condition = "output.perfMetrics == 'complete'",
                    fluidRow(box(id="perfmet", title=strong("Performance Metrics"),  
                             width=12,
                             status="primary", 
                             collapsible = T, 
                             collapsed = F,
                             dataTableOutput('performance'))),
                ),
                conditionalPanel(condition = "output.perfMetrics == 'noTarget'",
                                 fluidRow(box(title=strong("Performance Metrics"),
                                              width=12,
                                              status="primary", collapsible = T,
                                              collapsed = F,
                                              "Because your data file does not contains target variable called 
                                               Total_MACE, no performance assessment was conducted."))
                ),
                conditionalPanel(condition = "output.perfMetrics == 'noPerf'",
                                 fluidRow(box(title=strong("Performance Metrics"),
                                              width=12,
                                              status="primary", collapsible = T,
                                              collapsed = F,
                                              "Prediction columns has just one level, so confusin matrix is not provided."))
                ),
                conditionalPanel(condition = "output.perfMetrics == 'empty'",
                                 fluidRow(box(title=strong("Performance Metrics"),
                                              width=12,
                                              status="primary", collapsible = T,
                                              collapsed = F,
                                              "Please upload a data file..."))
                ),
                conditionalPanel(condition = "output.perfMetrics == 'nonValid'",
                                 fluidRow(box(title=strong("Performance Metrics"),
                                              width=12,
                                              status="primary", collapsible = T,
                                              collapsed = F,
                                              p("Uploaded file shoud be in 
                                                .csv, .rds, .xlsx or .sav format",
                                                class="alarm")))
                ),
                conditionalPanel(condition = "output.perfMetrics == 'mismatch'",
                                 fluidRow(box(title=strong("Performance Metrics"),
                                              width=12,
                                              status="primary", collapsible = T,
                                              collapsed = F,
                                              p("At least one variable in uploaded dataset is 
                                              not in original training dataset", 
                                                class="alarm")))
                )
            ),
            tabPanel("Predicted Table",
                     fluidRow(box(title=strong("Prediction Ouput Table"), width=12, 
                                  status="primary", collapsible = T, collapsed = F,
                                  p("Here, Prediction table with probability of 
                             'No' event and 'Yes' event are provided. 
                             Final prediction of First_MACE_bin is provided in first
                             column.
                             If your data file contains target variable named 
                             First_MACE_bin, the cutoff for discriminating MACE-No vs
                             MACE-Yes is calculated by Youden's index and closest topleft 
                             method in training set by default.
                             If your data file does not contain target variable, 
                             The cutoff for defining MACE vs No-MACE is calcluated
                             by our study cutoff Youden's index and closest topleft 
                             value of each model in original training set.",
                                    "You can define which metrics should be used for 
                             threshold assignment.", class="predict-text"))),
                     fluidRow(box(title = strong("Metrics"), 
                                  "Please Select a Metric for Classification Threshold",
                                  width=12, status = "primary",
                                  collapsible = T, collapsed = F, 
                                  selectInput("metrics_input", label = " ",
                                              choices = c("Youden's index", "Closest Top Left",
                                                          "F1 score", "Accuracy",
                                                          "Precision", "recall", "Specificity",
                                                          "TNR", "FNR", "FPR",
                                                          "TPR"), selected = "Youden's index", 
                                              width = '200px')),
                     ),
                     conditionalPanel(condition = "output.predMetrics == 'complete'",
                                      fluidRow(box(title=strong("Table"),  
                                                   id="predictTable",width=12,
                                                   status="primary", collapsible = T, 
                                                   collapsed = F,
                                                   dataTableOutput("predict_tbl")))
                     ),
                     conditionalPanel(condition = "output.predMetrics == 'empty'",
                                      fluidRow(box(title=strong("Predictions"),
                                                   id="predictTable",width=12,
                                                   status="primary", collapsible = T,
                                                   collapsed = F,
                                                   "Please upload a data file..."))
                     ),
                     conditionalPanel(condition = "output.predMetrics == 'nonValid'",
                                      fluidRow(box(title=strong("Predictions"),
                                                   id="predictTable",width=12,
                                                   status="primary", collapsible = T,
                                                   collapsed = F,
                                                   p("Uploaded file should be in 
                                                .csv, .rds, .xlsx or .sav format",
                                                     class="alarm")))
                     ),
                     conditionalPanel(condition = "output.predMetrics == 'mismatch'",
                                      fluidRow(box(title=strong("Predictions"),
                                                   id="predictPlot",width=12,
                                                   status="primary", collapsible = T,
                                                   collapsed = F,
                                                   p("At least one variable in uploaded dataset is 
                                              not in original training dataset", 
                                                     class="alarm")))
                     )
            ),
            tabPanel("Manual Prediction",
                     fluidRow(box(title=strong("Manual Prediction"), width=12,
                                  status="primary", collapsible = T, collapsed = F,
                                  "You can enter features of a patient manually to predict his/her
                                  first year MACE", br(),br(), 
                                  "Click manual prediction button to predict 
                                  your patient MACE with customized features you selected in 'Features' box. ",
                                  "predicton result will be printed in 'Prediction Result' tab.",br(), br(),
                                  actionButton(inputId = "man_predict_btn", label = "Manual Prediction",
                                               width="150px", class="predict-text")),
                              box(title=strong("Prediction Result"), width=12,
                                  status = "primary", collapsible = T, collapsed = F,
                                  "Prediction result would be provided here...",
                                  dataTableOutput("manual_predict_tbl")),
                              box(title=strong("Features"), width=12,
                                  status="primary", collapsible = T, collapsed = F,
                                  column(6,
                                        radioButtons(inputId = "Clopidogrel", label = "Clopidogrel",
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1, inline = T),
                                        radioButtons(inputId = "Ca.ch.A", label = "Calcium Channel Blocker", 
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1,inline = T),
                                        radioButtons(inputId = "Nitrate", label = "Nitrate",
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1,inline = T),
                                        radioButtons(inputId = "Statines", label="Statines", 
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1, inline=T),
                                        radioButtons(inputId = "COPD", label="COPD", choiceNames = c("No", "Yes"), 
                                                     choiceValues = c(1,2), selected = 1, inline=T),
                                        radioButtons(inputId = "ASA", label="ASA", choiceNames = c("No", "Yes"), 
                                                     choiceValues = c(1,2), selected = 1, inline = T),
                                        radioButtons(inputId = "Betablocker", label="Beta Blocker",
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1, inline = T),
                                        radioButtons(inputId = "ACEinh_ARB", label="ACE inhibitor or ARB", 
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1, inline = T),
                                        radioButtons(inputId = "HTN", label = "Hypertension",
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1, inline = T),
                                        radioButtons(inputId = "DM", label = "Diabetes Mellitus(Type 1 or 2)",
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1,inline = T),
                                        radioButtons(inputId = "FH", label = "Family History",
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1,inline = T),
                                        radioButtons(inputId = "IHD", label = "Ischemic heart disease",
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1,inline = T),
                                        radioButtons(inputId = "CS", label = "Cigarrete Smoking", choiceNames = c("No", "Yes"), 
                                                     choiceValues = c(1,2),selected = 1,inline = T),
                                        radioButtons(inputId = "Block", label = "Block",
                                                     choiceNames = c("First degree AVB", "LBBB", "No", "RBBB"), 
                                                     choiceValues = c(1,2,3,4), 
                                                     selected = 3,inline = T),
                                        radioButtons(inputId = "Gender", label = "Gender",
                                                     choiceNames = c("Female", "Male"), choiceValues = c(1,2), 
                                                     selected = 1,inline = T),
                                        radioButtons(inputId = "Cardiogenicshock", label = "Cardiogenic Shock",
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1,inline = T),
                                        radioButtons(inputId = "Opium_bin", label = "Opium",
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
                                                     selected = 1,inline = T)),
                                  column(6, 
                                        numericInput(inputId = "Pain_to_Door", label = "Pain to door",
                                                      value = 100,min = 0, max = 20000, 
                                                      step = 1,width = "200px"),
                                        numericInput(inputId = "HDL", label = "HDL", value = 40, 
                                                      min = 0,max = 100,step = 1,width = "200px"),
                                        numericInput(inputId = "LDL", label = "LDL", 
                                                      value = 100, min = 0, max = 2000,
                                                      step = 1, width="200px"),
                                        numericInput(inputId = "TG", label = "Triglyceride", 
                                                      value = 100, min = 0, max = 2000,step = 1,
                                                      width="200px"),
                                        numericInput(inputId = "Age", label = "Age", 
                                                     value = 50, min = 18, max = 120,step = 1,
                                                     width="200px"),
                                        numericInput(inputId = "BMI", label = "BMI", 
                                                      value = 20, min = 15, max = 50,
                                                      step = 1, width = "200px"),
                                        numericInput(inputId = "Cr", label = "Creatinine", 
                                                      value = 0.8, min = 0.4, max = 20, 
                                                      step = 1, width = "200px"),
                                        numericInput(inputId = "Hb", label = "Hb", 
                                                      value = 13, min = 3, max = 25, 
                                                      step = 1, width = "200px"),
                                        numericInput(inputId = "Door_to_Device", 
                                                      label = "Door to Device", 
                                                      value = 100, min = 0, max = 1000,
                                                      step = 1, width = "200px"))
                              ))),
            # tabPanel("Plots", 
            #     fluidRow(box(title=strong("Performance Plots"), width=12,
            #                  status="primary", collapsible = T, collapsed = F,
            #                  "If your dataset contains target variable named
            #                  Total_MACE, ROC curve would be provided.",
            #                  class="predict-text")
            #     ),
            #     conditionalPanel(condition = "output.perfMetrics == 'complete'",
            #     fluidRow(box(title=strong("Plot"),  
            #                 id="predictPlot",width=12,
            #                 height = 650,
            #                 status="primary", collapsible = T, 
            #                 collapsed = F,
            #                 column(12, align="center", 
            #                 plotOutput("predict_plot"))))
            #     ),
            #     conditionalPanel(condition = "output.perfMetrics == 'noTarget'",
            #                      fluidRow(box(title=strong("Plot"),
            #                                   id="predictPlot",width=12,
            #                                   status="primary", collapsible = T,
            #                                   collapsed = F,
            #                                   "Because your data file does not contains target variable called 
            #                                    Total_MACE, no performance assessment was conducted."))
            #     ),
            #     conditionalPanel(condition = "output.perfMetrics == 'empty'",
            #                      fluidRow(box(title=strong("Plot"),
            #                                   id="predictPlot",width=12,
            #                                   status="primary", collapsible = T,
            #                                   collapsed = F,
            #                                   "Please upload a data file..."))
            #     ),
            #     conditionalPanel(condition = "output.perfMetrics == 'nonValid'",
            #                      fluidRow(box(title=strong("Plot"),
            #                                   id="predictPlot",width=12,
            #                                   status="primary", collapsible = T,
            #                                   collapsed = F,
            #                                   p("Uploaded file shoud be in 
            #                                     .csv, .rds, .xlsx or .sav format",
            #                                     class="alarm")))
            #     ),
            #     conditionalPanel(condition = "output.perfMetrics == 'mismatch'",
            #                      fluidRow(box(title=strong("Plot"),
            #                                   id="predictPlot",width=12,
            #                                   status="primary", collapsible = T,
            #                                   collapsed = F,
            #                                   p("At least one variable in uploaded dataset is 
            #                                   not in original training dataset", 
            #                                     class="alarm")))
            #     )
            # ),
        )
    ),
    contactsUI('contact'),
    aboutUI('about')
  ),br(),
  tags$footer(align = "center",
                fluidRow(column(6,fluidRow(icon("github","fa-1x"), strong("PRIMACE")), fluidRow(tagList(a("Github Repo", href="https://github.com/hedayatbehnam/primace")))), 
                         column(6,fluidRow(img(src="bmc.svg", style="margin:0; padding:1; background-color:black;")), 
                                fluidRow(tagList(a("Published Article", href="https://link.springer.com/content/pdf/10.1186/s12906-023-03833-z.pdf")), style="margin:0; padding:0;")),
                  style="height:100%;padding-top:15px; padding-bottom:15px;bottom:0;"), style="bottom:0;height:50px;margin-top:10px; border-top:solid 1px black;")
)
#' header of main ui
#' @noRd
CustomHeader <- dashboardHeader(title ="PRIMACE", userOutput("user"))
# CustomHeader$children[[3]]$children <- list(
#   div(class="login-box",icon("user"),"Login"))
#' ui composite
#' @noRd
ui <- dashboardPage(
  skin = "purple",
  header = CustomHeader,
  sidebar = sidebar,
  body = body
)
