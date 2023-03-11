---
title: PRIMACE Prediction Tool
---

<!-- badges: start -->
[![PRIMACE](man/figures/webapp.svg)](https://primace.aikadeh.com)  


[![Continuous-Deployment](https://github.com/hedayatbehnam/primace/workflows/Continuous-Deployment/badge.svg)](https://github.com/hedayatbehnam/primace/actions) [![Docker-Build-Push](https://github.com/hedayatbehnam/primace/workflows/Docker-Build-Push/badge.svg)](https://github.com/hedayatbehnam/primace/actions)    
[![R-CMD-Check](https://github.com/hedayatbehnam/primace/workflows/R-CMD-Check/badge.svg)](https://github.com/hedayatbehnam/primace/actions) [![S3-Bucket-Connection](https://github.com/hedayatbehnam/primace/workflows/S3-Bucket-Connection/badge.svg)](https://github.com/hedayatbehnam/primace/actions)     
[![Data-Modification-Check](https://github.com/hedayatbehnam/primace/workflows/Data-Modification-Check/badge.svg)](https://github.com/hedayatbehnam/primace/actions) [![Webapp-Availability](https://github.com/hedayatbehnam/primace/workflows/Webapp-Availability/badge.svg)](https://github.com/hedayatbehnam/primace/actions)  

[![GitHub issues](https://img.shields.io/github/issues/hedayatbehnam/primace?color=blue&logo=github)](https://github.com/hedayatbehnam/primace/issues) [![GitHub pull requests](https://img.shields.io/github/issues-pr/hedayatbehnam/primace?color=blue&logo=github)](https://github.com/hedayatbehnam/primace/pulls) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/hedayatbehnam/primace/blob/main/LICENSE.md) 

<!-- badges: end -->

# Overview
`PRIMACE` is a shinyapp web application based on R language shiny package which can be used to predict major cardiovascular events (MACE) in first year following Primary Percutaneous Coronary Intervention (PPCI)  
**PPCI:** Primary Percutaneous Coronary Intervention  
**MACE:** Major Adverse Cardiovascular Events

## Background
We published a related article with title of "Effects of opium use on one-year major adverse cardiovascular events (MACE) in the patients with ST-segment elevation MI undergoing primary PCI: a propensity score matched - machine learning based study" in **BMC Complementary Medicine and Therapies** journal.    
**ML models were as follows**:    
 1. Survival Random Forest  
 2. Survival Extreme Gradient Boosting (xgboost)

#### **Link to Online `PRIMACE`**
[![PRIMACE](man/figures/webapp.svg)](https://primace.aikadeh.com)  
**[PRIMACE Prediction Tool](https://primace.aikadeh.com)**

#### **Link to Original Article** 
[![PRIMACE](man/figures/bmc.jpg)](https://link.springer.com/content/pdf/10.1186/s12906-023-03833-z.pdf)  
**[Original Article in BMC Journal](https://link.springer.com/content/pdf/10.1186/s12906-023-03833-z.pdf)**

## Instructions

### Preparing your dataset
Because preprocessing and training steps were conducted on our dataset, to use the saved models, you should rename your dataset variable to those similar to our study dataset.  
The acceptable variables names are provided in `Prediction Tool` tab under `Variables Name` box.

### Uploading dataset
After renaming variables, you can upload your dataset to the api in `Upload File` box. Acceptable file formats are .rds, .csv, .sav and .xlsx. 
If you do not upload a dataset, by default, a new test test with know target variable has been provided to the app to be used for prediction.

### Selecting models and prediction

In `Upload File` section, you can select among two models (at the moment just random survival forest is available) we trained in our study. After selecting a model, push the `Predict...` button to initiates prediction on the dataset. It would take a little time to complete prediction process.

### Dataset with known target variable
If your dataset have a columns named `First_MACE_bin` as target event variable and `Time_to_MACE` as time of event or censor, the app would peforms prediction and then assesses its prediction performance by different performance measures.


### Dataset with unknown target variable
If your dataset does not have columsn named `First_MACE_bin` as target event variable and `Time_to_MACE` as time of event or censor, the app would just performs prediction, then a table of prediction of observations is provided. It would be applicable for prediction of patients at the time of MDCT.

### Using Prediction of Your Patient
In `Manual Prediction` tab of `Prediction Tool` submenu, you can input your patient's features, then click `Manual Prediction` button to see the result of app prediction.  


