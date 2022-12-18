#' @include styles.R
#' sidebar of main user interface
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("home")),
    menuItem("Authors", tabName = "authors", icon = icon("pencil-alt")),
    menuItem("Abstract", tabName = "abstract", icon = icon("file")),
    menuItem("Prediction Tool", tabName = "prediction", icon = icon("wrench"),
             badgeLabel = "API", badgeColor = "green"),
    menuItem("Contact", tabName = "contact", icon = icon("phone")),
    menuItem("About", tabName = "about", icon = icon("info"))
  )
)
#' body part of main user interface
body <- dashboardBody(
  shinybusy::add_busy_spinner(spin = "half-circle", position = "bottom-right",
                              margins = c("60%", "42%"), width = "70px", height = "70px"),
  style_ref(tags, "style"),
  tags$script(HTML("$('body').addClass('fixed');")),
  tabItems(
    tabItem(tabName = "home", 
            fluidRow(column(12,box(width=12, status = "primary", solidHeader = F,
                column(12, align="center",tags$div("Effects of opium use on one-year major adverse cardiovascular events (MACE) 
                                                   in the patients with ", br(),"ST-segment elevation MI undergoing primary PCI", br()," 
                                                   a propensity score matched - machine learning based study", 
                                                   class="home-title"))))),
            fluidRow(width=12, solidHeader = F,
                column(12, align="center",tags$div(img(src='logothc.png', 
                       align = "center", width=200),br(),
                       p("Tehran Heart Center", class="thc-logo-text"),
                       p("Artificial Intelligence Division", 
                       class="thc-logo-subtext")))),
           
            fluidRow(column(6,box(width=12 , background = "light-blue",
                              tags$div("Using Surviva Random Forest Machine Learning Model
                              to Predict Outcom with provided data in file format of .RDS, 
                              .csv, .sav, .xlsx ",class="home-box-title"))),
                     
                     column(6,box(width=12, background = "teal",
                              column(12, align="center",tags$div("An Online 
                              Machine Learning Tool to Predict First 
                              Year Major Adverse Cardiovascular Events  
                              Following Primary Percutaneous
                              Coronary Intervention", class="home-box-title"))
                              ))
    )),
    tabItem(tabName = "authors",
            fluidRow(box( width = 12, status = "primary",
              div(p(span("Authors and Affiliations", style="font-weight:bold; 
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
                          "Tehran, Iran.", 
                    class="abstract-text"))
    )),
    tabItem(tabName = "abstract", 
            fluidRow(box(width=12, status = "primary",
                  div(p(span("Abstract", style="font-weight:bold; font-size:24px;")), hr(),
                  p(strong("Background:")),"Considerable number of people still 
                  use opium worldwide and many believe in opium's health benefits. 
                  However, several studies proved the detrimental effects of 
                  opium on the body, especially the cardiovascular system. 
                  Herein, we aimed to provide the first evidence regarding the 
                  effects of opium use on one-year major adverse cardiovascular 
                  events (MACE) in the patients with ST-elevation MI (STEMI) who 
                  underwent primary PCI.", hr(),
                  p(strong("Materials and methods:")),"We performed a propensity 
                  score matching of 2:1 (controls: opium users) that yielded 518 
                  opium users and 1036 controls. Then, we performed conventional 
                  statistical and machine learning analyses on these matched cohorts. 
                  Regarding the conventional analysis, we performed multivariate 
                  analysis for hazard ratio (HR) of different variables and MACE 
                  and plotted Kaplan Meier curves. In the machine learning section, 
                  we used two tree-based ensemble algorithms, Survival Random Forest 
                  and XGboost for survival analysis. Variable importance (VIMP), 
                  tree minimal depth, and variable hunting were used to identify 
                  the importance of opium among other variables.", hr(),
                  p(strong("Results:")),"Opium users experienced more one-year 
                  MACE than their counterparts, although it did not reach 
                  statistical significance (Opium: 72/518 (13.9%), Control: 
                  112/1036 (10.8%), HR: 1.27 (95% CI: 0.94-1.71), adjusted 
                  p-value=0.136). Survival random forest algorithm ranked opium 
                  use as 13th, 13th, and 12th among 26 variables, in variable 
                  importance, minimal depth, and variable hunting, respectively. 
                  XGboost revealed opium use as the 12th important variable. 
                  Partial dependence plot demonstrated that opium users had 
                  more one-year MACE compared to non-opium-users.", hr(),
                  p(strong("Conclusion:")), "Opium had no protective effects on 
                  one-year MACE after primary PCI on patients with STEMI. 
                  Machine learning and one-year MACE analysis revealed some 
                  evidence of its possible detrimental effects, although the 
                  evidence was not strong and significant. As we observed no 
                  strong evidence on protective or detrimental effects of opium, 
                  future STEMI guidelines may provide similar strategies for 
                  opium and non-opium users, pending the results of forthcoming 
                  studies. Governments should increase the public awareness 
                  regarding the evidence for non-beneficial or detrimental effects 
                  of opium on various diseases, including the outcomes of primary 
                  PCI, to dissuade many users from relying on false beliefs about 
                  opium's benefits to continue its consumption.", class="abstract-text"))
    )),
    tabItem(tabName = "prediction",
        tabsetPanel(type="tabs", id = "predictTabs",
            tabPanel("Introduction", 
                fluidRow(box(title=p(span("Prediction Tool", style="font-weight:bold; 
                         font-size:24px;")), 
                         width=12,status="primary", collapsible = T, collapsed = F,
                            p("Here a prediction tool is provided based on survival 
                            random forest trained on patients which 
                            underwent primary percutaneous coronary intervention(PCI), 
                            to predict major adverse cardiovascular event (MACE).
                            ", class="predict-text"), 
                            p("You can upload your custom file from file input 
                            box bellow. At the moment Allowed format is *.rds, 
                            *.csv, *.sav and *.xlsx formats.", class="predict-text"),
                            p("Because the models have been trained with specific names 
                            of features, your dataset features names should be 
                            transformed to the names provided in 'Variables Names' 
                            box bellow to enable prediction.", class="predict-text"),
                )), br(),
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
                                choices = c("Survival Random Forest", 
                                          "Survival Xgboost"), 
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
                                                     choiceNames = c("No", "Yes"), choiceValues = c(1,2), 
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
        ),
    ),
    tabItem(tabName = "contact",
            fluidRow(box(width=12, status = "primary",
                         div(p(span("Contact", style="font-weight:bold; 
                                    font-size:24px;")), hr(),
                          strong("Phone: "), "+98-21-88029600", br(),
                          strong("Email: "),"email@thc.tums.ac.ir, 
                          dr.hedayatb@gmail.com", br(),
                          strong("Address: "), "Tehran Heart Center, 
                          Kargar St. Jalal al-Ahmad Cross, Tehran, Iran",br(),
                          strong("Zip Code: "), "1411713138", class="abstract-text"))
    )),
    tabItem(tabName = "about",
            fluidRow(box(width=12, status="primary",
            div(p(span("About", style="font-weight:bold; font-size:24px;")),
                style="width:80%; margin-top:0px; font-size:16px;"))
    ))
  )
)

ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "PRIMACE"),
  sidebar,
  body
)
