#test for bayesian analysis of rstan
rm(list=ls())

#simulate data
x= data.frame(x1=rbinom(n=300,size=1,prob=0.5),
    x2=rnorm(n=300,mean=2,sd=.75))

beta = c(0.3,0.5,0.25)

xmat = model.matrix(~.+1,data=x)
y= rnorm(n=300,mean=(xmat %*% beta),sd=2)

cat('Sim betas =',beta,'\n')

#make a list for feeding to stan
dat=list(x=xmat,y=y,N=nrow(x),P=ncol(xmat))

#load rstan
library('rstan')

#set options for 4 independent chains, each chain on a separate cpu
burn=500
chains=4
iters=burn*2

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
options(mc.cores = chains) 


#call stan model
fit = stan("stan_testmod.stan",
           data=dat,
           warmup=burn,
           chains=chains,
           iter=iters)

print('Frequentist Object:')
print(summary(lm(y~xmat-1)))

print('Stan Object:')
print(fit)

