#Dev R 3.2.3 Wooden Christmas-Tree
#Prepares figures and tables for analysis
#Bryce Bartlett


rm(list=ls())

#Preliminaries
#@@
source('config.R')

require(knitr)

#Special Functions
#@@

#none

#Load and define cleaned data
#@@

load(paste0(outdir,'private~/dat.rda'))

#exclude States that are not in fips


dat = dat[dat$State.Code > 0,]

#STRUCTURAL ZEROS (146)
#dat$rrcomp[dat$rrcomp == 0] = NA
#dat$rrcomp = log(dat$rrcomp)

#descriptives by state
aggregate(dat$rrcomp[dat$switchcap==0],by=list(dat$nocap[dat$switchcap==0]),
          FUN=function(x) c(mean=mean(x, na.rm=TRUE),sd=sd(x,na.rm=TRUE),
                          qt=quantile(x,prob=c(0.05,0.33,0.5,0.66,0.95),na.rm=TRUE)))

#various plots
hist(dat$rrcomp)

#aggregate median trend with 50% and 90% spans
#the tails at either end are likely related to statutes of limitations
#shoud do some analysis and projection on difference between malyear and origyear
plts = aggregate(dat$rrcomp,by=list(dat$year),FUN=function(x)
  c(qt=quantile(x,prob=c(.05,.25,.5,.75,.95),na.rm=TRUE),
    mean=mean(x,na.rm=TRUE)))

plot(1,type='n',xlim=range(dat$year),ylim=range(plts$x))
  lines(1999:2014,plts[['x']][,3])

lines(1999:2014,plts[['x']][,6],type='p')  
  
for(y in 1:nrow(plts$x)){
  segments(plts$Group.1[y],plts$x[y,2],plts$Group.1[y],plts$x[y,4])  
  segments(plts$Group.1[y],plts$x[y,1],plts$Group.1[y],plts$x[y,5],lty=2)  
}

#plots sliced by group and year
datcap = dat[dat$switchcap == 0,]

capplts = aggregate(datcap$rrcomp,by=datcap[,c('year','nocap')],FUN=function(x)
  c(qt=quantile(x,prob=c(.05,.25,.5,.75,.95),na.rm=TRUE),
    mean=mean(x,na.rm=TRUE)))
nc=capplts[['nocap']]==1

plot(1,type='n',xlim=range(dat$year),ylim=range(capplts$x))
lines(1999:2014,capplts$x[nc,3],col='green')
lines(1999:2014,capplts$x[nc==FALSE,3],col='red')

lines(capplts$year[nc],capplts[['x']][nc,6],type='p',col='green')  
lines(capplts$year[nc],capplts[['x']][nc==FALSE,6],type='p',col='red')  

for(y in 1:nrow(capplts$x)){
  if(capplts$nocap[y]==TRUE){
    segments(capplts$year[y]-.15,capplts$x[y,2],capplts$year[y]-.15,capplts$x[y,4],col='green')  
    segments(capplts$year[y]-.15,capplts$x[y,1],capplts$year[y]-.15,capplts$x[y,5],lty=2,col='green')  
  } else{
    segments(capplts$year[y]+.15,capplts$x[y,2],capplts$year[y]+.15,capplts$x[y,4],col='red')  
    segments(capplts$year[y]+.15,capplts$x[y,1],capplts$year[y]+.15,capplts$x[y,5],lty=2,col='red')  
  }
}

sw = dat[dat$switchcap == 1,]
st = unique(sw$workstat)

for(s in st){
  text(sw$year[sw$workstat == s & sw$cap == 0],
       sw$rrcomp[sw$workstat == s & sw$cap == 0],
       labels=s,cex=.5,col='green')

  text(sw$year[sw$workstat == s & sw$cap == 1],
     sw$rrcomp[sw$workstat == s & sw$cap == 1],
     labels=s,cex=.5,col='red')
}

#export to csv
write.csv(sw,paste0(outdir,'private~/agg_switch.csv'))

#@@@@@
#output icd10 adverse event supplement
#this uses previously cleaned icd10 codes
#from 
#https://github.com/bjb40/cause_death/blob/master/output/icd10.csv

icd10 = read.csv("H:/projects/cause_death/output/icd10.csv")

sink(paste0(outdir,'icd10list.txt'))

comp = icd10[icd10$nchs113 == 113,]
  cat('Selected NCHS Causes of Death for',unique(as.character(comp$nchsti)),'\n')
  cat('Number of unique diagnostic codes:',nrow(comp),'\n\nNames:\n\n')
  div=unique(comp$div_name)
  
  for(d in div){
    cat(d,unique(as.character(comp$div_nos[comp$div_name==d])),'\n\t')
    cat(as.character(comp$descrip[comp$div_name==d]),sep='\n\t')
    cat('\n\n')
  }  

sink()

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#DESCRIPTIVE TABLE
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#fixed characteristics
fx = c('year','oldcap','switchcap','nocap','female')

cons = apply(dat[,fx],2,FUN=function(x) 
  c(mn=mean(as.numeric(x), na.rm=TRUE),sd=sd(x,na.rm=TRUE),nmiss=sum(is.na(x)))
)

#changing characteristics
cx = c('Freq','compdeaths','cap','lagmp','lagcompdeaths')

ags = aggregate(dat[,cx],by=list(dat$year),FUN=function(x) 
  c(mn=mean(as.numeric(x), na.rm=TRUE),sd=sd(x,na.rm=TRUE))
  )

#this is a hokey way to make it work...
tags = t(ags); colnames(tags) = ags$Group.1

sink(paste0(outdir,'descriptives.md'))
  cat('Table of Constatn descripives.\r\n\r\n')

  kable(cons,format='markdown',caption='Constant descrptives')
  cat('\r\n\r\nTable of Moving descriptives\r\n\r\n')
  kable(t(tags),format='markdown',caption='Changing descrptives')
  
sink()


pandoc(paste0(outdir,'descriptives.md'),format='docx')


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#Descriptive line graphs
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


#box plots of series

yrs = ags[,1]
mp = ags[,2][,1]
ps = ags[,3][,1]

png(paste0(draftimg,'box-series.png'))
par(mfrow=c(2,1),mar=c(2,2,1,2))
  boxplot(dat$compdeaths~dat$year,xaxt='n',main="Deaths from Complications")
  boxplot(dat$Freq~dat$year,main='Paid Malpractice Claims')
dev.off()
  
#box plots of first difference
#create first difference

#generate unique id by state and gender
#and reshape wide to long
dat$id=paste0(dat$State.Code,dat$female)

mpdat = ts(reshape(dat[,c('Freq','id','year')],
                timevar='year',
                idvar='id',
                direction='wide'))

compdat = ts(reshape(dat[,c('compdeaths','id','year')],
                     timevar='year',
                     idvar='id',
                     direction='wide'))

colnames(mpdat)=colnames(compdat)=c('id',1999:2014)

png(paste0(draftimg,'box-series-1diff.png'))
  par(mfrow=c(2,1),mar=c(2,2,1,2))
  boxplot(diff(compdat[,2:17]),xaxt='n',main="Deaths from Complications (First Difference)")
  boxplot(diff(mpdat[,2:17]),main='Paid Malpractice Claims (First Difference)')
dev.off()
