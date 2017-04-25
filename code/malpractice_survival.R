#Survival Model for malpractice claims
#Bryce Bartlett

#@@@@
#preliminaries
#@@@@

#need: npdb.death, fips, and allmort form prep-data

library(merTools)
library(reshape2); library(ggplot2); library(lme4); library(boot); library(dplyr)

#@@@@
#Create dataset
#all that matches is state, age, gender, and year, and patient age
#@@@@

mort = allmort %>% 
  rename(name=State,fips=State.Code,ptgender=Gender.Code,malyear=Year,deaths=Deaths) %>%
  mutate(ptage=as.factor(Five.Year.Age.Groups.Code))

#edit age factors so that it is 10 year age groups
#delete topcoded digit
levels(mort$ptage)  = gsub('\\-[[:digit:]]+','',levels(mort$ptage))
levels(mort$ptage)[levels(mort$ptage)==1] = '0'
levels(mort$ptage)[levels(mort$ptage) %in% c('5','1-4')] = '1'
#change last digit to 0
levels(mort$ptage)  = gsub('5$','0',levels(mort$ptage))
levels(mort$ptage)[levels(mort$ptage) == '100+'] = '90'

#print table to check recodes
print(
  table(mort[,c('Five.Year.Age.Groups.Code','ptage')])
)

#problem with masking and MASS package
mort = mort %>% 
  dplyr::select(ptgender,ptage,name,malyear,fips,deaths) %>%
  group_by(ptgender,ptage,name,malyear,fips) %>%
  summarize(deaths=sum(deaths,na.rm=TRUE))

str.mort=mort%>%filter(ptage==1000)
#add repitition years
for(p in rev(2004:2015)){
    temp.mort = mort %>% filter(malyear<=p)
    temp.mort$paidyear=p
    str.mort=rbind(str.mort,temp.mort)
}

analyze=merge(fips,mort,by=c('fips','name'),all=TRUE)

#summarize npdb.death -- from prep-data.R
#age groups -1 = fetus; 0 = under 1 year
#can set up claim age with implied structural 0s by state...
npdb.sum = npdb.death %>% 
  rename(abb=workstat,paidyear=origyear) %>%
  filter(ptage>=0|is.na(ptage)) %>%
  mutate(ptage=factor(ifelse(is.na(ptage),'NS',ptage))) %>%
  mutate(malyear=pmax(malyear1,malyear2,na.rm=TRUE),
         claimage=paidyear-malyear) %>% 
  group_by(abb,ptgender,ptage,malyear,claimage,paidyear) %>% 
  summarize(paid=n()) %>% filter(malyear>=2004)

#can impute money using using poisson assumption (or can use midpoint) ....

analyze=merge(analyze,npdb.sum,
              by=c('abb','ptgender','ptage','malyear'),
              all=TRUE)

#@@@@@@@@@@@@@@@@@@
#prep state.dat
#i dow this multiple times -- should simplify
#@@@@@@@@@@@@@@@@@@

switch = names(switchcap)
allcap = names(oldcap)

#empty dataframe
state.dat=fips %>% filter(name=='none')

for(y in 2004:2015){
  tmp=fips %>%
    mutate(paidyear=y,
           captype=factor(
             ifelse(name %in% switch,'switchcap',
                             ifelse(name %in% allcap,'oldcap','nocap'))
             ),
           cap=ifelse(captype=='oldcap',1,
                      ifelse(captype=='nocap',0,
                             ifelse(captype=='switchcap',NA,NA)))
    )
  state.dat=rbind(state.dat,tmp)
}

#update switchcap
for(n in switch){
  state.dat = state.dat %>% 
    mutate(cap=ifelse(name==n & paidyear %in% switchcap[[n]],1,cap),
           cap=ifelse(name==n & !(paidyear %in% switchcap[[n]]),0,cap))
}

#include tort reform variables from tort reform database
source('tort-reform-data.R',local=TRUE) #loads data as dstlr
dstlr = dstlr %>% filter (year>=2004) %>% rename(paidyear=year)
state.dat=merge(dstlr,state.dat)

#add tort reform variables to analyze
analyze$cap = analyze$switchcap = 0
#caps prior to 1999
analyze=analyze %>% mutate(cap=ifelse(name %in% allcap,1,cap),
                           switchcap=ifelse(name %in% switch,1,cap),
                           captype=ifelse(name %in% allcap,2,
                                          ifelse(name %in% switch,3,1)))

analyze$captype = factor(analyze$captype,labels=c('nocap','oldcap','switchcap'))

for(n in switch){
  yrs=switchcap[[n]]
  analyze = analyze %>% 
    mutate(cap=ifelse(name == n & malyear %in% paidyear,1,cap))
}

print(
  table(analyze[,c('name','cap','switchcap')])
)

#@@@@@@@@@@@@@@@@@@@@@
#descriptives & visuals
#@@@@@@@@@@@@@@@@@@@@@

analyze.sum = analyze %>% 
  filter(malyear>=2004) %>%
  group_by(malyear,claimage,paidyear,captype) %>% 
  summarize(paid=sum(paid,na.rm=TRUE)) %>%
  group_by(malyear,captype,paidyear) %>% arrange(claimage)

captable = unique(analyze[,c('name','captype')])
mort = merge(mort,captable,by='name')

deaths.sum=mort %>% group_by(malyear,captype) %>% summarize(deaths=sum(deaths)) 

analyze.sum=merge(analyze.sum,deaths.sum,by=c('malyear','captype'))  %>%
  group_by(malyear,captype) %>% arrange(claimage) %>%
  mutate(cum.prop=cumsum(paid)/mean(deaths))
  
compmort.sum = compmort %>% 
  rename(malyear = Year, ptgender=Gender.Code,name=State,compdeaths=Deaths)

compmort.sum=merge(compmort.sum,captable,by='name') %>%
  group_by(malyear,captype) %>%
  summarize(compdeaths=sum(compdeaths,na.rm=TRUE))

analyze.sum = merge(analyze.sum,compmort.sum,by=c('malyear','captype')) %>%
  mutate(comprate=compdeaths/(deaths/1000))

#prepare crude rates
analyze = analyze %>%
  group_by(malyear,name,ptage,ptgender) %>%
  arrange(claimage) %>%
  mutate(lx.mal=lag(deaths-cumsum(paid),order_by=claimage),
         lx.mal=ifelse(is.na(lx.mal),deaths,lx.mal),
         mx.mal=paid/(lx.mal/1000)) #need to fix to the average


#constant deaths
ggplot(analyze.sum,aes(x=claimage,y=deaths/1000,color=factor(malyear))) + geom_line() + facet_grid(~captype)
ggsave(paste0(draftimg,'constant-deaths.pdf'))
#paid claims...

ggplot(analyze.sum,aes(x=claimage,y=(paid/(deaths/1000)),color=factor(malyear))) + 
  geom_line() +
  facet_grid(~captype) + 
  ylab('Paid Claims per 1,000 Deaths') +
  xlab('Age of Claim') +
  theme_minimal() +
  labs(title='Unadjusted malpractice rates across year and damage caps.',
        subtitle='Adoption of state damage caps over period: 
Never a cap ("nocap"), always a cap ("oldcap"), change in cap status ("switchcap").') + 
  theme(legend.title=element_blank())

#for paa poster
ggsave(paste0(draftimg,'malpractice-px.png'),
       height=10,width=18,dpi=200,units='in')

#ggsave(paste0(draftimg,'malpractice-px.pdf'))


#####twiter print
##prob with cumulative proportion

overview.plt=ggplot(analyze.sum,aes(x=claimage,y=cum.prop,color=factor(malyear))) +
  geom_line() + 
  facet_grid(~captype) +
  ylab('Cumulative Proportion') + xlab('Age of Claim') +
  labs(title='Proportion of Deaths that Resulting in Paid Malpractice Claims (2004-2014)',
       subtitle='Depending on whether state continuusly had damage cap law, or not',
       caption='Source: National Practioner Data Bank & CDC Wonder  
       Caclulated: Bryce Bartlett (http://www.brycebartlett.com)') +
  theme(legend.title=element_blank())
  

print(overview.plt)
ggsave(paste0(draftimg,'cum-malpractice-px.pdf'))
#twitter save
ggsave(paste0(draftimg,'cum-malpractice-px.jpg'),
       height=20,width=20,
       units='cm',dpi=300)

comptrend.plt = ggplot(analyze.sum %>% group_by(malyear,captype) %>% summarize(comprate=mean(comprate)),
       aes(x=malyear,y=comprate,color=captype)) + 
  geom_line() +
  ylab('Proportion of Deaths from Complications of Medical Care (per 1,000 deaths)') +
  labs(title='Trend in proportions of death due to medical complications',
       subtitle='Sliced by state tort reform characteristics.') +
  xlab('Year') +
  theme_classic()

print(comptrend.plt)

ggsave(paste0(draftimg,'comprate.png'),
       height=10,width=18,units='in',dpi=200)

#ggsave(paste0(draftimg,'comprate.pdf'))

#(re)prepare crude malpractice rates

analyze.sum = analyze.sum %>%
  group_by(malyear,captype) %>%
  arrange(claimage) %>%
  mutate(lx.mal=lag(deaths-cumsum(paid),order_by=claimage),
         lx.mal=ifelse(is.na(lx.mal),deaths,lx.mal),
         mx.mal=paid/(lx.mal/1000)) #need to fix to the average


periodmal.plt = ggplot(analyze.sum %>% group_by(paidyear,captype) %>% summarize(mx.mal=mean(mx.mal)),
                       aes(x=paidyear,y=mx.mal,color=captype)) + geom_line() 

print(periodmal.plt)
ggsave(paste0(draftimg,'malpractice-period.pdf'))

scatter.plt = ggplot(analyze.sum %>% 
                       filter(!is.na(claimage)),
                     aes(x=mx.mal,y=comprate,color=captype)) +
  geom_jitter() + facet_wrap(~claimage)

print(scatter.plt)
ggsave(paste0(draftimg,'scatterplt.pdf'))

print(
  analyze.sum %>% 
    group_by(claimage) %>% 
    summarize(cor(comprate,mx.mal,use='pairwise.complete.obs'))
)

ggplot(analyze,aes(x=claimage,y=mx.mal,color=captype)) + geom_jitter()

print(summary(analyze$mx.mal))

#@@@@@@@@@@@@@@@@@@@@@
#prep a survival model
#to estimate how long they stay
#draw posterior predicitve imputatations
#@@@@@@@@@@@@@@@@@@@@@


#@@@@@@@@@@@@
#prep data with NO age
#picewise w/claimage...need to include full exposure, incl. structural zeros
#will just drop all missing for now... should prep proportion missing, though
#summarize and ignore age....

npdb = npdb.sum %>% filter(malyear>=2004) %>%
  group_by(abb,ptgender,malyear,claimage,paidyear) %>%
  summarize(paid=sum(paid,na.rm=TRUE))

mort=mort %>% filter(malyear>=2004) %>%
  group_by(name,ptgender,malyear,fips) %>%
  summarize(deaths=sum(deaths))

datnames=c(colnames(npdb),colnames(mort))
dat = setNames(replicate(length(datnames),numeric(0), simplify = F), datnames)

###prep with structural zeros
for(y in unique(analyze$malyear)){
  for(p in 2004:2015){
  if(p<y){next}
   subdat = npdb %>% filter(malyear==y,paidyear==p)
   submort = mort %>% filter(malyear==y)
   submort=merge(submort,fips,by=c('name','fips'))
   t = merge(subdat,submort,all=TRUE)
   t = t %>% filter(!is.na(fips)) %>%
     mutate(paidyear=p,
            claimage=paidyear-malyear,
            paid=ifelse(is.na(paid),0,paid))
   
   dat=rbind(dat,t)
  }
}

dat=merge(dat,state.dat)
sub.comp = compmort %>% 
  rename(malyear=Year,ptgender=Gender.Code,compdeaths=Deaths,name=State) %>% 
  dplyr::select(malyear,ptgender,name,compdeaths)

dat=merge(dat,sub.comp) %>% mutate(comprate=compdeaths/deaths)

#prepare crude rates and lx (i.e. deaths at risk of becoming paid claims)
dat = dat %>%
  group_by(malyear,name,ptgender) %>%
  arrange(claimage) %>%
  mutate(lx.mal=lag(deaths-cumsum(paid),order_by=claimage),
         lx.mal=ifelse(is.na(lx.mal),deaths,lx.mal),
         mx.mal=paid/(lx.mal)) #need to fix to the average


#@@@@@@@@@@@
#AHRF -- load data
#@@@@@@@@@@@
#require(RevoScaleR)
#ahrf.zip = 'H:/Academic Projects/Data Files/HRSA/ARF/AHRF_SN_2015-2016.zip'
#ahrf = unzip(ahrf.zip)
#ahrf.dat = read.table(list.files(pattern='.asc'))

#@@@@@@@@@@@
#####model---
#http://stats.stackexchange.com/questions/89734/glm-for-proportion-data-in-r

biv=glm(cbind(paid,lx.mal)~factor(claimage) + I(comprate*1000) + factor(malyear),
        family=binomial(logit),data=dat)

print(summary(biv))

m1=glm(cbind(paid,lx.mal)~factor(claimage) + cap,
       family=binomial(logit),data=dat)

m1a=glm(cbind(paid,lx.mal)~claimage+I(claimage^2) + I(claimage^3) + cap,
        family=binomial(logit),data=dat)

pred.m1=data.frame(predict.glm(m1,se.fit=TRUE,type='response'))
pred.m1$claimage=m1$model[['factor(claimage)']]
pred.m1$cap=m1$model$cap
pred.m1$fitpoly=predict.glm(m1a,type='response')

#confirm this is okay or use delta method from network project...
pred.m1=unique(pred.m1) %>% 
  mutate(upper=fit+1.96*se.fit,
         lower=fit-1.96*se.fit)

pred.plt = ggplot(pred.m1,aes(x=as.numeric(claimage),y=fit,color=factor(cap))) + 
  geom_line() +  
  geom_ribbon(aes(ymin=lower,ymax=upper,fill=factor(cap)),alpha=0.2)+ 
  geom_line(aes(y=fitpoly),linetype=2) +
  labs(title='Predicted malpractice rates by claimage',
       subtitle='Solid is factor; dashed is polynomial model')

print(pred.plt) 
ggsave(paste0(draftimg,'pred-plt.pdf'))

m2=glm(cbind(paid,lx.mal)~ factor(claimage) + cap + factor(malyear) +
        I(comprate*1000) + ptgender + name,
       family=binomial(logit),data=dat) 

print(summary(m2))

m2a=glm(cbind(paid,lx.mal)~ factor(claimage) + n_reform + factor(malyear) +
         I(comprate*1000) + ptgender + name,
       family=binomial(logit),data=dat) 

print(summary(m2a))

m2b=glm(cbind(paid,lx.mal)~ factor(claimage) + 
          r_cn + r_cp + r_ct + r_sr + r_cs + r_pe + r_pp + r_cf + r_js +r_pcf + r_cmpf + 
          factor(malyear) +
          I(comprate*1000) + ptgender + name,
        family=binomial(logit),data=dat) 

print(summary(m2b))


#2 year windows
dat$malyear.adj = dat$malyear - 2009

#mean time-frame stuff
hlm = glmer(cbind(paid,lx.mal)~ 
        factor(claimage) + cap + I(comprate*1000) + ptgender +
        I(malyear-2009) +
        (1|name),
      family=binomial(logit),data=dat)

print(summary(hlm))

hlma = glmer(cbind(paid,lx.mal)~ 
              I(claimage/10) + I((claimage/10)^2)  + 
               captype +
               I(comprate*1000) + ptgender +
              I(malyear-2009) +
              (1|name),
            family=binomial(logit),data=dat)

print(summary(hlma))

#@@@@@@@@@@@@@@@@@@@@@
#prep analytic models with compmort
#@@@@@@@@@@@@@@@@@@@@@

#effects are negative, brecause I have to sum from out-of sample predictoins
#(i.e. how many will there be in 10 years...)
comp.dat=dat %>% ungroup
#fill out data with future values for predictions
for(y in 2005:2014){
  tmp = comp.dat %>% filter(malyear == y)
  ma=max(tmp$claimage); print(nrow(tmp))
  tmp = tmp %>% filter(claimage==ma)
  for(a in (ma:10)){
    tmp$claimage = a+1
    tmp$paid=NA
    comp.dat = rbind(comp.dat,tmp)
  } 
}

#should fill out with 102s
print(
  table(comp.dat[,c('claimage','malyear')])
)

comp.dat = comp.dat %>% filter(claimage<=10)

############
#should bootstrap or use fully bayesian posterior predictive for predictions
#(then don't have to worry about calculating boot c.i.s as below)
############

comp.dat$predmal = predict.glm(m2,type='response',newdata=comp.dat)
comp.dat$predmal.hlm = inv.logit(predict(hlm,comp.dat))

############
#end predictive...
############

comp.dat = comp.dat %>% 
  group_by(name,ptgender,malyear,abb,fips,captype) %>%
  summarize(deaths=mean(deaths),
            compdeaths=mean(compdeaths),
            predmal.hlm=sum(predmal.hlm),
            predmal=sum(predmal),
            r_cn=sum(r_cn),r_cp=mean(r_cp),r_cs=mean(r_cs),r_ct=mean(r_ct),r_sr=mean(r_sr),
                  r_pe=mean(r_pe),r_pp=mean(r_pp),r_cf=mean(r_cf),
                  r_pcf=mean(r_pcf),r_cmpf=mean(r_cmpf),r_js=mean(r_js))
  
comp.dat = comp.dat %>% 
  group_by(malyear,ptgender) %>% 
  arrange(malyear) %>% 
  mutate(predlag=lag(predmal))

predmal.plt = ggplot(comp.dat,aes(x=predmal*1000,y=(compdeaths/(deaths/1000))
                    ,color=malyear, shape=captype),
                     group=name) + 
  geom_point() + 
  facet_wrap(~name) 
print(predmal.plt)

spag.plt = ggplot(comp.dat %>% filter(ptgender=='F'),aes(x=predmal*1000,y=(compdeaths/(deaths/1000)))) + 
  geom_line(aes(group=name),stat='smooth',method='lm',alpha=.25,size=1.2) +
  geom_point(aes(color=malyear), alpha=.55) + 
  theme_minimal()
print(spag.plt)

ggsave(spag.plt,filename=paste0(draftimg,'spag.pdf'))


m1c=glm(cbind(compdeaths,deaths)~ predlag + I(malyear-2009),
        family=binomial(logit),data=comp.dat)
print(summary(m1c))

m1.1c=glm(cbind(compdeaths,deaths)~ predlag + factor(malyear),
        family=binomial(logit),data=comp.dat)
print(summary(m1.1c))

m1b=glm(cbind(compdeaths,deaths)~ predlag + I(malyear-2009) + captype,
          family=binomial(logit),data=comp.dat)
print(summary(m1b))

#switches ... because of trend?  
m2c=glm(cbind(compdeaths,deaths)~ captype + I(malyear-2009) +
          I(predlag*1000) + ptgender + name,
        family=binomial(logit),data=comp.dat)
print(summary(m2c))

m2e=glm(cbind(compdeaths,deaths)~ I(malyear-2009) +
          r_cn + r_cp + r_ct + r_sr + r_cs + r_pe + r_pp + r_cf + r_js +r_pcf + r_cmpf +
          I(predlag*1000) + ptgender + name,
        family=binomial(logit),data=comp.dat)
print(summary(m2e))

hlmc = glmer(cbind(compdeaths,deaths)~ captype + I((malyear-2009)/10) +
               I(predlag*1000) + ptgender + (1|name),
             family=binomial(logit),data=comp.dat)

summary(hlmc)

hlmc.a = glmer(cbind(compdeaths,deaths)~ I((malyear-2009)/10) +
                 r_cn + r_cp + r_ct + r_sr + r_cs + r_pe + r_pp + r_cf + r_js +r_pcf + r_cmpf +
                 I(predlag*1000) + ptgender + (1|name),
               family=binomial(logit),data=comp.dat)

summary(hlmc.a)

b=attr(hlmc,'beta')
predlag=seq(0,0.003,by=0.0001)*1000

pred=matrix(0,length(predlag),length(b))
pred[,1] = 1
pred[,5] = predlag

#updated plot based on rates per 1,000 deaths!!

predict = inv.logit(pred %*% b)
plot(predlag,predict*1000,type='l')  
  
###alt predict

predict.tmp = comp.dat[1:31,]
predict.tmp$name='California'
predict.tmp$ptgender='M'
predict.tmp$captype='nocap'
predict.tmp$predlag=seq(0,0.003,by=0.0001)

predict=rbind(predict.tmp,predict.tmp %>% mutate(captype='oldcap'))
predict=rbind(predict,predict.tmp %>% mutate(captype='switchcap'))


#predictInterval(hlmc,newdata=predict)

#bootstrap c.i.
predFun = function(fit){
  predict(fit,predict,type="response")
}

#u is the spherical errors on the random effects; use.u means not to draw new effects
#use.u=FALSE, means to integrate over the uncertainty in 'u' (theoretically)
#bb=bootMer(hlmc,nsim=200,FUN=predFun,use.u=TRUE,ncpus=4)
#predict$pred=predict(hlmc,predict,type='response')
#predict$up=apply(bb$t,2,quantile,prob=0.975)
#predict$down=apply(bb$t,2,quantile,prob=0.025)

#ggplot(predict,aes(x=predlag*1000,y=pred*1000,color=captype)) + geom_line(linetype=2) +
#  geom_ribbon(aes(ymin=down*1000,ymax=up*1000,fill=captype),alpha=0.05)

#save()

#############
#maps adjunct
"
library(maps)
map.dat = merge(map_data('state') %>% rename(name=region),
      dat %>% 
        group_by(name,malyear,captype,cap) %>% 
        summarize(comprate=mean(comprate)) %>% 
        ungroup %>%
        mutate(name=tolower(name)),
      by='name')

for(y in unique(map.dat$malyear)){
map.plot=ggplot(map.dat[map.dat$malyear==y,],aes(long,lat,group=group)) + 
  geom_polygon(aes(fill=comprate,color=factor(captype)),size=1.3,linetype=3)

print(map.plot); Sys.sleep(5)
}
"
