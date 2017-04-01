#Survival Model for malpractice claims
#Bryce Bartlett

#@@@@
#preliminaries
#@@@@

#need: npdb.death, fips, and allmort form prep-data

library(dplyr); library(reshape2); library(ggplot2)

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

mort = mort %>% 
  select(ptgender,ptage,name,malyear,fips,deaths) %>%
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
  summarize(paid=n()) %>% filter(malyear>=1999)

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
    mutate(cap=ifelse(name==n & paidyears %in% switchcap[[n]],1,cap),
           cap=ifelse(name==n & !(paidyears %in% switchcap[[n]]),0,cap))
}

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
  mutate(cum.prop=cumsum(paid)/mean(deaths/1000))
  
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
ggplot(analyze.sum,aes(x=claimage,y=(paid/(deaths/1000)),color=factor(malyear))) + geom_line() + facet_grid(~captype)

overview.plt=ggplot(analyze.sum,aes(x=claimage,y=cum.prop,color=factor(malyear))) +
  geom_line() + 
  facet_grid(~captype)

print(overview.plt)

comptrend.plt = ggplot(analyze.sum %>% group_by(malyear,captype) %>% summarize(comprate=mean(comprate)),
       aes(x=malyear,y=comprate,color=captype)) + geom_line() 

print(comptrend.plt)

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

scatter.plt = ggplot(analyze.sum %>% 
                       filter(!is.na(claimage)),
                     aes(x=mx.mal,y=comprate,color=captype)) +
  geom_jitter() + facet_wrap(~claimage)

print(scatter.plt)

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

mort=mort %>% 
  group_by(name,ptgender,malyear,fips) %>%
  summarize(deaths=sum(deaths))

datnames=c(colnames(npdb),colnames(mort))
dat = setNames(replicate(length(datnames),numeric(0), simplify = F), datnames)

###prep with structural zeros
for(y in unique(analyze.model$malyear)){
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
  select(malyear,ptgender,name,compdeaths)

dat=merge(dat,sub.comp) %>% mutate(comprate=compdeaths/deaths)

#####model
#http://stats.stackexchange.com/questions/89734/glm-for-proportion-data-in-r

m1=glm(cbind(paid,(deaths))~claimage + I(claimage^2),
       family=binomial(logit),data=dat)

#@@@@@@@@@@@@@@@@@@@@@
#prep analytic models with compmort
#@@@@@@@@@@@@@@@@@@@@@


