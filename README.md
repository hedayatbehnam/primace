# PRIMACE Prediction Tool
`PRIMACE` is a web application which can be used to predict major cardiovascular 
events (MACE) in first year following Primary Percutaneous Coronary Intervention (PPCI)  
**PPCI:** Primary Percutaneous Coronary Intervention  
**MACE:** Major Adverse Cardiovascular Events

## Background
We published a related article with title of "Effects of opium use on one-year major adverse cardiovascular events (MACE) in the patients with ST-segment elevation MI undergoing primary PCI: a propensity score matched - machine learning based study" in BMC Cardiovascular Journal.  
ML models were as follows:  
 1. Survival Random Forest
 2. Survival Extreme Gradient Boosting (xgboost)

### The link to online `PRIMACE`:
**[PRIMACE Prediction Tool](https://behnam-hedayat.shinyapps.io/primace)**

## Instructions

### Preparing your dataset
Because preprocessing and training steps were conducted on our dataset, to use the saved models, you should rename your dataset variable to those similar to our study dataset.  
The acceptable variables names are provided in `Prediction Tool` tab under `Variables Name` box.

### Uploading dataset
After renaming variables, you can upload your dataset to the api in `Upload File` box. Acceptable file formats are .rds, .csv, .sav and .xlsx. 
If you do not upload a dataset, by default, a new test test with know target variable has been provided to the app to be used for prediction.

### Selecting models and prediction

In `Upload File` section, you can select among seven models we trained in our study. After selecting a model, push the `Predict...` button to initiates prediction on the dataset. It would take a little time to complete prediction process.

### Dataset with known target variable
If your dataset has a column named `Total_MACE` as target variable, the app would peforms prediction and then assesses its prediction performance by different performance measures.


### Dataset with unknown target variable
If your dataset does not have a column names `Total_MACE` as target variable, the app would just performs prediction, then a table of prediction of observations is provided. It would be applicable for prediction of patients at the time of MDCT.

### Using Prediction of Your Patient
In `Manual Prediction` tab of `Prediction Tool` submenu, you can input your patient's features, then click `Manual Prediction` button to see the result of app prediction.

