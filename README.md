## Overview And Steps to Conduct A Regression Discontinuity Analysis

This repository contains R code which can be used and followed along in the Appendix section of our paper titled, "Regression Discontinuity Design - A Practical Guide." The teaching/redacted dataset used for this application is based on the Framingham Heart Study and is available upon request via BioLINCC at https://biolincc.nhlbi.nih.gov/teaching/

Please note that this particular dataset is intended for instructional purposes only, and therefore analyses performed on it should NOT be used for reporting results in a publication.


### Framingham dataset - teaching version
In our application of RD to the Framingham teaching dataset, we seek to estimate the causal effect of antihypertensive medications on cardiovascular disease incidence among individuals in this cohort. In our example, the cutoff for treatment is Systolic Blood Pressure = 140 mmHg, and the treatment is anti-hypertensive medication. The following is a brief data dictionary of relevant variables and their purpose in our walk-through. 

Variable | Description | Type of variable 
--- | --- | --- 
CVD | Cardiovascular Disease in follow-up period (0 = No, 1 = Yes) | Outcome variable (Y)
SYSBP | Systolic Blood Pressure (mmHg) | Running variable (X)
BPMEDS | Use of Anti-hypertensive medication at exam (0 = No, 1 = Yes) | Treatment status variable (D)
AGE | Age at exam (years) | Variable at baseline used to assess covariate balance
