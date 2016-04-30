#Dev R 3.2.3 Wooden Christmas-Tree
#Regression Analysis
#Bryce Bartlett

#@@@@@@@@@@@@@@@@@
#prelims
#@@@@@@@@@@@@@@@@@
#maybe link to prep-data

#@@@@@@@@@@@@@@@@@
#prep data
#@@@@@@@@@@@@@@@@@

#lim 2002 to 2008
lim = dat$year >= 2002 & dat$year <= 2008 & !is.na(dat$State.Name)
#switchcaps be bad...
table(dat[dat$switchcap==1 & lim,c('year','cap','State.Name')])
#remove switchcap
lim = lim & dat$switchcap == 0
#id structural zeros
unique(dat[dat$Freq==0,'State.Name'])
unique(dat[dat$compdeaths==0,'State.Name'])

#prep data to id states by name in numeric order
stname = unique(dat$State.Name[lim])
dat$st = NA
for(s in 1:length(stname)){dat$st[lim & dat$State.Name == stname[s]] = s}

y=dat[lim,'lrrcomp']
id=dat[lim,'st']
z=as.matrix(cbind(rep(1,sum(lim)),dat[lim,c('nocap','female')]))
t=dat[lim,'year']
yrctr = 1 - range(t)[1] #center index on 1 for bayesian model processing

N=length(y)
IDS=length(unique(id))
YRS=length(unique(t))
P=ncol(z)  
  
#@@@@@@@@@@@@@@@@@
#call and send to stan 
#@@@@@@@@@@@@@@@@@

library('rstan')

#detect cores to activate parallel procesing
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
options(mc.cores = 3) #leave one core free for work

fit <- stan("bayeshlm.stan", data=c("N","P","IDS","YRS","yrctr","y","id","t","z"),
            #algorithm='HMC',
            chains=3,iter=500,verbose=T);
#sample_file = paste0(outdir,'diagnostic~/post-samp.txt'),
#diagnostic_file = paste0(outdir,'diagnostic~/stan-diagnostic.txt'),


post_sum = summary(fit)[[1]] #independant of chain

traceplot(fit, pars=c('beta','sig','zi'))
traceplot(fit, pars=c('gamma'))


#sink(paste0(outdir,'bayes.txt'))
print(summary(fit,pars=c('beta','sig','zi','lp__'),digits=3))
print(summary(fit,pars=c('gamma'),digits=3))

#sink()
