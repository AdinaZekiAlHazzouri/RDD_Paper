################################################################################
## Epidemiology Journal
## RD example code 
## Last update: October 4, 2021
################################################################################
## TO INSTALL/DOWNLOAD R PACKAGES/FUNCTIONS:
## RDROBUST (estimation and inference):  install.packages('rdrobust')
## RDDENSITY (validation test): install.packages('rddensity')
################################################################################

rm(list=ls())
library(rdrobust)
library(rddensity)


### Load dataset
setwd("INSERT DIRECTORY HERE")  # Put location of your working directory here
hs <-read.csv("headstart_sim.csv")


### Summarize the dataset
summary(hs$povrate60)
summary(hs$mort_age59_related_postHS)
summary(hs$D) 
summary(hs$census1960_pop)


### Step 1
### Define outcome (Y), running variable (X) and cutoff (c)
Y = hs$mort_age59_related_postHS 
X = hs$povrate60 
c = 59.1984

####################
##### RD Plots #####
####################
# Exploratory plot to illustrate the nature of the relationship
plot1 = rdplot(Y, X, c, x.label = "County poverty rate in 1960, percent", y.label = "Mortality, Ages 5-9, 1973-1983")
summary(plot1)



### Step 2
####################
##### RD Model #####
####################
# RDD Estimation: everything in one step, including bandwidth selection
rd_1 = rdrobust(Y, X, c)
# note that by default:  kernel = 'triangular',  p = 1, bwselect = 'mserd'
# We could have also obtained the MSE bandwidth using: 
rd_bw = rdbwselect(Y, X, c, kernel = 'triangular',  p = 1, bwselect = 'mserd')


### Robustness
# Change to uniform kernel
rd_2 <- rdrobust(Y, X, c, kernel = 'uniform',  p = 1, bwselect = 'mserd')
# Change to local quadratic regression
rd_3 <- rdrobust(Y, X, c, kernel = 'triangular',  p = 2, bwselect = 'mserd')
# Change to different bandwidths on each side:
rd_4 <- rdrobust(Y, X, c, kernel = 'triangular',  p = 1, bwselect = 'msetwo')


### Steps 3 & 4: Output results from model (RDD effect and 95% CI estimation)
summary(rd_1)



### Step 5
#############################################################
## Additional Validity Checks
#############################################################
# Using rddensity
rdd <- rddensity(X, c)
summary(rdd)
# Figure
plot <- rdplotdensity(rdd, X)

## Covariate balance assessment
rd_5 = rdrobust(hs$census1960_pop, X, c)
summary(rd_5)
rdplot(hs$census1960_pop, X, c, title = "Covariate Balance - RD Plot", x.label = "County poverty rate in 1960, percent", y.label = "Census 1960: county population")



### Step 6
### Plotting the RDD
bandwidth = rdrobust(Y, X, c, kernel = 'triangular', p = 1, bwselect = 'mserd')$bws[1]
out = rdplot(Y, X, c, p = 1, kernel = 'triangular', h = bandwidth, x.label = "County poverty rate in 1960, percent", y.label = "Mortality, Ages 5-9, 1973-1983")



### Step 7
#############################################################
## Fuzzy RD: average effect on compliers
#############################################################
# First, assess if there is imperfect compliance by computing RD effect using D as the outcome
D = hs$D
rd_6 = rdrobust(D, X, c)
summary(rd_6)

# Next, run a RD fuzzy model, specifying the D variable as the actual treatment value
frd = rdrobust(Y, X, c, fuzzy=D)
summary(frd)








