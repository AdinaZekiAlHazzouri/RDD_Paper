## Overview of Steps and Application of Regression Discontinuity Analysis

This repository contains a walkthrough of an RD application which is connected with our paper, "Regression Discontinuity Design in the Health and Medical Sciences: A Useful Tool in the Absence of Randomized Data." The below documents are provided in this repository: 
File Name | Description |  
--- | --- 
*Appendix Methods: RD Application, Methods and Results.docx* | This document contains the entire walkthrough of our application, including the steps for conducting an RD analysis, an overview of our application, embedded R code, and a summary of the output and results.
*RDD-paper-code.R* | This document contains just the R code required to implement this practice application.

The teaching/redacted dataset used for this application is based on the Framingham Heart Study and is available upon request via BioLINCC at https://biolincc.nhlbi.nih.gov/teaching/ . Please note that this particular dataset is intended for instructional purposes only, and therefore analyses performed on it should NOT be used for reporting results in a publication.


### Framingham dataset - teaching version
In our application of RD to the Framingham teaching dataset, we seek to estimate the causal effect of antihypertensive medications on cardiovascular disease incidence among individuals in this cohort. In our example, the cutoff for treatment is Systolic Blood Pressure = 140 mmHg, and the treatment is anti-hypertensive medication. The following is a brief data dictionary of relevant variables and their purpose in our walk-through. 

Variable | Description | Type of variable 
--- | --- | --- 
CVD | Cardiovascular Disease in follow-up period (0 = No, 1 = Yes) | Outcome variable (Y)
SYSBP | Systolic Blood Pressure (mmHg) | Running variable (X)
BPMEDS | Use of Anti-hypertensive medication at exam (0 = No, 1 = Yes) | Treatment status variable (D)
AGE | Age at exam (years) | Variable at baseline used to assess covariate balance
