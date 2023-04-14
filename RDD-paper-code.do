**********************************************************************************************************
** BMJ
** RD example code in Stata for "Regression Discontinuity Design studies: A guide for health researchers"
** Authors: Sebastian Calonico, Neal Jawadekar, Katrina Kezios, Adina Zeki Al Hazzouri
** Last update: April 14, 2023
**********************************************************************************************************
** TO INSTALL/DOWNLOAD R PACKAGES:
** RDROBUST (estimation and inference):  net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace
** RDDENSITY (validation test):          net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace
********************************************************************************
clear all


*** Load dataset
cd "INSERT DIRECTORY HERE" /* Put location of your working directory here */
use "frmgham2.dta"
keep if !missing(cvd, sysbp, bpmeds) /* For illustrative purposes, and to keep samples consistent between Sharp RD and Fuzzy RD models, we will limit our sample  */
                                     /* to individuals with a non-missing value of the outcome variable, running variable, and actual treatment take-up indicator. */

**********************************************************************************************************
***** Step 1. Identify main components of the RD model ***************************************************
**********************************************************************************************************

global Y cvd    /* outcome variable */
global X sysbp  /* running variable  */
global D bpmeds /* actual treatment take-up indicator */
global C 140        /* cutoff value */
gen T = 1*($X>=$C)        /* treatment assignment indicator */

su $Y $X $D T

**********************************************************************************************************
***** Step 2. RD Plots: Exploratory plot to illustrate the nature of the relationship ********************
**********************************************************************************************************

rdplot $Y $X, c($C) ///
graph_options(title("") ///
                     ytitle(Cardiovascular Disease at Follow-up) ///
                     xtitle(Systolic Blood Pressure (mmHg)) ///
                     graphregion(color(white)) legend(off))



***********************************************************************************************************
***** Step 3. Set up the local polynomial model ***********************************************************
***********************************************************************************************************
local P  = 1             /* local linear approximation */
local K  = "triangular"  /* triangular kernel  */
local BW = "mserd"       /* MSE optimal bandwidth*/


***********************************************************************************************************
***** Steps 4-5. RD Estimation and Inference **************************************************************
***********************************************************************************************************
rdrobust $Y $X, c($C) kernel(`K') p(`P') bwselect(`BW')

* You can also run RD using default choices, as shown here:
rdrobust $Y $X, c($C) 


*** Plotting the RD model
rdplot $Y $X if -e(h_l)<= $X-$C & $X-$C <= e(h_r), c($C) kernel(`K') p(`P') bwselect(`BW') ///
					h(`e(h_l)' `e(h_r)')  ///
					 graph_options(title("") ///
                     ytitle(Cardiovascular Disease at Follow-up) ///
                     xtitle(Systolic Blood Pressure (mmHg)) ///
                     graphregion(color(white)) legend(off))


**********************************************************************************************************
***** Step 6. Robustness checks and validation ***********************************************************
**********************************************************************************************************

* Change to uniform kernel
rdrobust $Y $X, c($C) kernel("uniform") p(1) bwselect("mserd")

* Change to local quadratic regression
rdrobust $Y $X, c($C) kernel("triangular") p(2) bwselect("mserd")

* Change to different bandwidths on each side:
rdrobust $Y $X, c($C) kernel("triangular") p(1) bwselect("msetwo")


* Other bandwidth choices:
rdbwselect $Y $X, c($C) all


* Test for manipulation of the running variable: rddensity test
rddensity $X, c($C) plot ///
					 graph_opt(title("") ///
                     ytitle(Cardiovascular Disease at Follow-up) ///
                     xtitle(Systolic Blood Pressure (mmHg)) ///
                     graphregion(color(white)) legend(off))



** Covariate balance assessment (Age)
rdrobust age $X, c($C)

rdplot age $X, c($C) ///
					 graph_options(title("Covariate Balance - RD Plot") ///
                     ytitle(Age) ///
                     xtitle(Systolic Blood Pressure (mmHg)) ///
                     graphregion(color(white)) legend(off))



**********************************************************************************************************
**** Step 7: Fuzzy RD: average effect for compliers ******************************************************
**********************************************************************************************************

* First, assess compliance by computing RD effect using D as the outcome (first stage)
rdrobust $D $X, c($C)

disp "Treatment take-up for the treatment group: " e(tau_cl_r)
disp "Treatment take-up for the control group: " e(tau_cl_l)
disp "Compliance rate: " e(tau_cl_r)-e(tau_cl_l)

rdplot $D $X, c($C) p(1) ///
					 graph_options(title("First Stage") ///
                     ytitle(Use of anti-hypertensive medication) ///
                     xtitle(Systolic Blood Pressure (mmHg)) ///
                     graphregion(color(white)) legend(off))
					 


* Fuzzy RD model: 
rdrobust $Y $X, c($C) fuzzy($D)







