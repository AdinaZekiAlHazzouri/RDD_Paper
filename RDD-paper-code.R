################################################################################
## JAMA Internal Medicine Journal
## RD example code 
## Last update: February 12, 2022
################################################################################
## TO INSTALL/DOWNLOAD R PACKAGES:
## RDROBUST (estimation and inference):  install.packages('rdrobust')
## RDDENSITY (validation test):          install.packages('rddensity')
################################################################################

rm(list=ls())

# Load R packages
# Load R packages
library(rdrobust)
library(rddensity)

### Load dataset
setwd("Insert Directory Here") # Put location of your working directory here
frm <-read.csv("frmgham2.csv")


###########################################################################
##### Step 1. Identify main components of the RD model ####################
###########################################################################

Y = frm$CVD    # outcome variable
X = frm$SYSBP  # running variable 
D = frm$BPMEDS # actual treatment take-up indicator
C = 140        # cutoff value
T = 1*(X>=C)   # treatment assignment indicator 

summary(Y)
summary(X)
summary(D) 
summary(T)

##########################################################################################################
##### Step 2. RD Plots: Exploratory plot to illustrate the nature of the relationship ####################
##########################################################################################################

rdplot1 = rdplot(y = Y, x = X, c = C, 
                 x.label = "Systolic Blood Pressure (mmHg)", 
                 y.label = "Cardiovascular Disease at Follow-up")
summary(rdplot1)




####################################################################
##### Step 3. Set up the local polynomial model ####################
####################################################################
P  = 1             # local linear approximation
K  = 'triangular'  # triangular kernel  
BW = 'mserd'       # MSE optimal bandwidth


####################################################################
##### Steps 4-5. RD Estimation and Inference #######################
####################################################################
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
                 y.label = "Cardiovascular Disease at Follow-up",  subset = (X >= (C - bw) & X <= (C + bw)), x.lim = c(C - bw - 1,+ C + bw + 1), y.lim = c(0,+ 1))


###################################################################
##### Step 6. Robustness checks and validation ####################
###################################################################

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
plot <- rdplotdensity(rdd, X)

## Covariate balance assessment (Age)
rd_covs = rdrobust(y = frm$AGE, x = X, c = C)
summary(rd_covs)

rdplot(y = frm$AGE, x = X, c = C, 
  title = "Covariate Balance - RD Plot", 
  x.label = "Systolic Blood Pressure (mmHg)", 
  y.label = "Age")


#############################################################
#### Step 7: Fuzzy RD: average effect for compliers #########
#############################################################

# First, assess compliance by computing RD effect using D as the outcome

RD_comp = rdrobust(y = D, x = X, c = C)
summary(RD_comp)
RD_comp_plot = rdplot(y = D, x = X, c = C,
                      x.label = "Systolic Blood Pressure (mmHg)", 
                      y.label = "Use of anti-hypertensive medication")

# Fuzzy RD model: 

RD_fuzzy = rdrobust(y = Y, x = X, c = C, fuzzy = D)
summary(RD_fuzzy)






