## Overview of Steps and Application of Regression Discontinuity Analysis

The purpose of this GitHub page is to provide a walkthrough of a Regression Discontinuity (RD) application which is connected to our paper, *Regression Discontinuity Design studies: A guide for health researchers.* The following documents are provided in this repository: 
File Name | Description |  
--- | --- 
[**Online-Appendix.docx**](./Online-Appendix.docx) | This document contains the entire walkthrough of our application, including an overview of our application, the steps for conducting an RD analysis, embedded R code, and a summary of the output and results.
[**RDD-paper-code.R**](./RDD-paper-code.R) | This document contains just the R code required to implement our application.
[**RDD-paper-code.do**](./RDD-paper-code.do) | This document contains just the Stata code required to implement our application.

The teaching/redacted dataset used for this application is based on the Framingham Heart Study and is available upon request via [BioLINCC](https://biolincc.nhlbi.nih.gov/teaching/). Please note that this particular dataset is intended for instructional purposes only, and therefore analyses performed on it should NOT be used for reporting results in a publication.


### RD Application on Framingham dataset (teaching version)
In our application of RD to the Framingham teaching dataset, we seek to estimate the causal effect of antihypertensive medications on cardiovascular disease incidence among individuals in this cohort. In our example, the cutoff for treatment is Systolic Blood Pressure = 140 mmHg, and the treatment is anti-hypertensive medication. The following is a brief data dictionary of relevant variables and their purpose in our walk-through. 

Variable | Description | Type of variable 
--- | --- | --- 
CVD | Cardiovascular Disease in follow-up period (0 = No, 1 = Yes) | Outcome variable (Y)
SYSBP | Systolic Blood Pressure (mmHg) | Running variable (X)
BPMEDS | Use of Anti-hypertensive medication at exam (0 = No, 1 = Yes) | Treatment status variable (D)
AGE | Age at exam (years) | Variable at baseline used to assess covariate balance
