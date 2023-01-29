#' Abstract Sidebar
#' UI sidebar of abstract tab
#' @param id id of module
#' @noRd
abstractSidebar <- function(id){
  menuItem("Abstract", tabName = "abstract", icon = icon("file"))
}
#' Abstract UI
#' UI for abstract
#' @param id id of module
#' @noRd
abstractUI <- function(id){
  tabItem(tabName = "abstract", 
          fluidRow(box(width=12, status = "primary", solidHeader = F, id='custom-box',
                       p(span("Abstract", style="font-weight:bold; font-size:24px;")), hr(),
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
                  opium's benefits to continue its consumption.", class="custom-box")
          ))
}

