#Dev R 3.2.3 Wooden Christmas-Tree
#Prepares figures and tables for analysis
#Bryce Bartlett


rm(list=ls())

#Preliminaries
#@@
source('config.R')

#Special Funcitons
#@@

#none

#Load and define cleaned data
#@@

load(paste0(outdir,'private~/dat.rda'))

#exclude States that are not in fips

dat = dat[dat$State.Code > 0,]

#plot mean RR by year


