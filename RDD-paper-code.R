######################################################################################################
## BMJ
## RD example code in R for "Regression Discontinuity Design studies: A guide for health researchers"
## Authors: Sebastian Calonico, Neal Jawadekar, Katrina Kezios, Adina Zeki Al Hazzouri
## Last update: April 13, 2023
######################################################################################################
## TO INSTALL/DOWNLOAD R PACKAGES:
## RDROBUST (estimation and inference):  install.packages('rdrobust')
## RDDENSITY (validation test):          install.packages('rddensity')
######################################################################################################
rm(list=ls())

# Load R packages
library(rdrobust)
library(rddensity)

### Load dataset
setwd("INSERT DIRECTORY HERE") # Put location of your working directory here

frm <-read.csv("frmgham2.csv")
# For illustrative purposes, and to keep samples consistent between Sharp RD and Fuzzy RD models, we will limit our sample  
# to individuals with a non-missing value of the outcome variable, running variable, and actual treatment take-up indicator.
frm <- frm[complete.cases(frm[c("CVD", "SYSBP", "BPMEDS")]), ]

######################################################################################################
##### Step 1. Identify main components of the RD model ###############################################
######################################################################################################

Y = frm$CVD    # outcome variable
X = frm$SYSBP  # running variable 
D = frm$BPMEDS # actual treatment take-up indicator
C = 140        # cutoff value
T = 1*(X>=C)   # treatment assignment indicator 

summary(Y)
summary(X)
summary(D) 
summary(T)


######################################################################################################
##### Step 2. RD Plots: Exploratory plot to illustrate the nature of the relationship ################
######################################################################################################

rdplot1 = rdplot(y = Y, x = X, c = C, 
                 x.label = "Systolic Blood Pressure (mmHg)", 
                 y.label = "Cardiovascular Disease at Follow-up", col.dots="lightsteelblue3",col.lines="mediumorchid4")
summary(rdplot1)
library(ggplot2)


######################################################################################################
##### Step 3. Set up the local polynomial model ######################################################
######################################################################################################
P  = 1             # local linear approximation
K  = 'triangular'  # triangular kernel  
BW = 'mserd'       # MSE optimal bandwidth


######################################################################################################
##### Steps 4-5. RD Estimation and Inference #########################################################
######################################################################################################
rd_manual = rdrobust(y = Y, x = X, c = C, 
                     kernel = K, p = P, bwselect = BW)
summary(rd_manual)

# You can also run RD using default choices, as shown here:
rd_default = rdrobust(y = Y, x = X, c = C)
summary(rd_default)


### Plotting the RD model
bw = rdrobust(y = Y, x = X, c = C, 
              kernel = 'triangular', p = 1, bwselect = 'mserd')$bws[1]
RD_plot = rdplot(y = Y, x = X, c = C,
                 p = 1, kernel = 'triangular', h = bw,
                 x.label = "Systolic Blood Pressure (mmHg)", 
                 y.label = "Cardiovascular Disease at Follow-up",  subset = (X >= (C - bw) & X <= (C + bw)), x.lim = c(C - bw - 1,+ C + bw + 1), y.lim = c(0,+ 1), col.dots="lightsteelblue",col.lines="mediumorchid4")


######################################################################################################
##### Step 6. Robustness checks and validation #######################################################
######################################################################################################

# Change to uniform kernel
rd_2 <- rdrobust(y = Y, x = X, c = C, 
                 kernel = 'uniform', p = 1, bwselect = 'mserd')
summary(rd_2)

# Change to local quadratic regression
rd_3 <- rdrobust(y = Y, x = X, c = C,
                 kernel = 'triangular', p = 2, bwselect = 'mserd')
summary(rd_3)

# Change to different bandwidths on each side:
rd_4 <- rdrobust(y = Y, x = X, c = C,
                 kernel = 'triangular', p = 1, bwselect = 'msetwo')
summary(rd_4)

# Other bandwidth choices:
rd_bws <- rdbwselect(y = Y, x = X, c = C, all = TRUE)
summary(rd_bws)


# Test for manipulation of the running variable: rddensity test
rdd <- rddensity(X = X, c = C)
summary(rdd)

# Figure
plot <- rdplotdensity(rdd, X,
                      xlabel = "Systolic Blood Pressure (mmHg)", ylabel = "Density", lcol = "mediumorchid4",pcol = "lightsteelblue3", histLineCol = "lightsteelblue3", histFillCol = "lightsteelblue3", CIcol = "lightsteelblue3")
#summary(plot)


## Covariate balance assessment (Age)
rd_covs = rdrobust(y = frm$AGE, x = X, c = C)
summary(rd_covs)

rdplot(y = frm$AGE, x = X, c = C, 
  title = "", 
  x.label = "Systolic Blood Pressure (mmHg)", 
  y.label = "Age", col.dots="lightsteelblue3",col.lines="mediumorchid4")



######################################################################################################
#### Step 7: Fuzzy RD: average effect for compliers ##################################################
######################################################################################################

# Fuzzy RD model: 

RD_fuzzy = rdrobust(y = Y, x = X, c = C, fuzzy = D)
summary(RD_fuzzy)
RD_fuzzy$Estimate[1] # Fuzzy RDD effect = -0.2301855


# Next, manually calculate this fuzzy RDD effect by running the below 2 steps:
# First, assess sharp RDD effect within bandwidth from the above fuzzy model
RD_sharp = rdrobust(y = Y, x = X, c = C, h = RD_fuzzy$bws[1,1], b = RD_fuzzy$bws[2,1], subset=!is.na(D))
summary(RD_sharp) 
RD_sharp$Estimate[1] # Sharp RDD effect = -0.005580354

# Next, assess compliance by computing RD effect using D as the outcome
RD_comp = rdrobust(y = D, x = X, c = C, h = RD_fuzzy$bws[1], b = RD_fuzzy$bws[2,1])
summary(RD_comp) 

RD_comp$Estimate[1] # Compliance RDD effect = 0.02424286
RD_comp$beta_p_r[1] # Treatment Take-up for Treatment Group = 0.08062456
RD_comp$beta_p_l[1] # Treatment Take-up for Control Group = 0.0563817


RD_comp_plot = rdplot(y = D, x = X, c = C, h = RD_fuzzy$bws[1,1], p=1, 
                      x.label = "Systolic Blood Pressure (mmHg)", 
                      y.label = "Use of anti-hypertensive medication", col.dots="lightsteelblue3",col.lines="mediumorchid4")

# Final calculation:
RD_sharp$Estimate[1] / RD_comp$Estimate[1] #  -0.2301855
  

                 





