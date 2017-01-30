#Dev R 3.2.3 Wooden Christmas-Tree
#Cleans data for analysis
#Bryce Bartlett

rm(list=ls())

#Preliminaries
#@@
source('config.R')

#Special Funcitons
#@@

#none

#Load and define raw data
#@@

#@@@@@@@@@@@@@@@@@@@@@
#NPDB DATA
#NPD downloaded 4/13/2016 
#from http://www.npdb.hrsa.gov/resources/publicData.jsp#termsOfAgree
#@@@@@@@@@@@@@@@@@@@@@

#Note that the original data is a fixed width ascii file that takes a long time to read; 
#but is easily imported once it is an R object, hence previously loaded as raw data is saved
#otherwise, it is loaded and saved as an R object

if (file.exists(paste0(outdir,'private~/rawdat.rda'))) {
  print('Data already subset, loading previously saved.')
  load(paste0(outdir,'private~/rawdat.rda'))
  
} else {
  rawzip = paste0(rawdir,"NpdbPublicUseDataAscii.zip")
  zipdat = unzip(rawzip,"NPDB1510.DAT")
  
  #
  wds = c(8,1,4,4,2,10,2,10,2,4,
          2,4,8,8,8,8,4,4,12,12,
          1,3,1,1,2,1,1,4,4,4,
          4,4,4,2,2,2,2,2,1,8,
          4,4,3,8,4,4,4,4,4,4,
          4,4,4,1
  )
  
  wds.names = c('seqno','rectype','reptype','origyear','workstat',
                'workctry','homestat','homectry','licnstat','licnfeld',
                'practage','grad','algnnatr','alegatn1','alegatn2',
                'outcome','malyear1','malyear2','payment','totalpmt',
                'paynumbr','numbpersn','paytype','pyrrltns','ptage',
                'ptgender','pttype','aayear','aaclass1','aaclass2',
                'aaclass3','aaclass4','aaclass5','basicd1','basicd2',
                'basicd3','basicd4','basicd5','aalentyp','aalength',
                'afyear','aasigyr','type','practnum','accrrpts',
                'npmalrpt','nplicrpt','npclprpt','nppsmrpt','npdearpt',
                'npexcrpt','npgarpt','npctmrpt','fundpymt')
  
  rawdat=read.fwf(zipdat,wds)
  
  file.remove("NPDB1510.DAT") #erase unzipped data
  colnames(rawdat) = wds.names
  
  #save as rda object
  save(rawdat,file=paste0(outdir,'private~/rawdat.rda'))
}

#output table for types of actions by year??

#subset
npdb.death = subset(rawdat, outcome == 9, #death only
              select=c('origyear','workstat','homestat','licnstat','malyear1','malyear2','aayear','payment',
                       'totalpmt','paytype',
                       #patient demographics
                       'ptage','ptgender','pttype','algnnatr'))

#issue with selecting deaths - limits to NA, and a lot of NA
#on outocme (50,000-60,000); like 60% 
#blank in "adverse action" and type "M" malpractice payments
#rectype explains it -- there, there is NO missing
#and 28-30% of outcomes are death (1-3% are 10 which is missing)

#all
prop.table(table(rawdat[,c('origyear','outcome')],useNA='always'),1)

#limited to malpractice allegations only
round(
  prop.table(table(
    rawdat[rawdat$rectype == 'P',
           c('origyear','outcome')],
            useNA='always'),1)
  ,2)

#lag between most recent occurence and reporting...
#reporting time of malpractice allegation does not apply to adverse actions
maldat = subset(rawdat,rectype %in% c('P','M'))
rmyear = apply(maldat[,c('malyear1','malyear2')],1,max, na.rm=TRUE)
mallag = maldat$origyear[rmyear != -Inf] - rmyear[rmyear != -Inf]
plt = mallag[mallag>=0 & mallag<15]

png(paste0(draftimg,'lag_hist.png'))
  hist(plt,freq=FALSE,main='',xlab='Years Since Event', 
    ylim=c(0,.20),ylab='Proportion',breaks=18) 
dev.off()

print(rnd(prop.table(table(plt))))

rm(plt)

summary(mallag[mallag >= 0 & mallag < 10]) #median is 4 years max is like forever 1st Q is 3; 
sum(mallag>10)/length(mallag) #5% greater than 10

#CONSIDER WHETHER CERTAIN PRACTITIONERS NEED EXCLUDED B/C OF DIFFERENT
#REPORTING REQUIREMENTS
  
#rm(rawdat)

#@@@@@@@@@@@@@@@@@@@@@
#MULTIMORTALITY DATA
#Downloaded from wonder 4/18/2016 
#from http://wonder.cdc.gov
#the bottom of the text file contains relevant information regarding selection
#@@@@@@@@@@@@@@@@@@@@@

#sliced by state, gender, 10 year age groups
allmort = read.table("H:/Academic Projects/Data Files/NVSS/wonder_mortality/MCD-state-1999-2014.txt",
                     sep='\t',nrows=19584,header=TRUE, #stop at line 19585; remainder of file includes sel params
                     na.strings = c('Supressed','Not Applicable','Unreliable'), stringsAsFactors=FALSE)

allmort$Deaths = as.numeric(allmort$Deaths)

#sliced by state, gender, and only includes deaths from complications of medical care (specific 113 COD)
compmort = read.table("H:/Academic Projects/Data Files/NVSS/wonder_mortality/MCD-state-compl-1999-2014.txt",
                      sep='\t',nrows=1632,header=TRUE, #stop at line 19585; remainder of file includes sel params
                      na.strings = c('Supressed','Not Applicable','Unreliable'), stringsAsFactors=FALSE)


#@@@@@@@@@@@@@@@@@@@@@
#PREPARE AND EXPORT ANALYSIS DATASET OF RELATIVE RATES
#prelim analysis: relative rates (i.e. ratios; 
#(see Bartlett, Bryce. [date]. New Ways to Die in the Age of Biomedicalization for details )
#sliced by state and age
#@@@@@@@@@@@@@@@@@@@@@

#aggregate NPD

#sum of malyear that are not equal
tst=npdb.death[is.na(npdb.death$malyear1)==FALSE & is.na(npdb.death$malyear2)==FALSE,c('malyear1','malyear2')]

#info on uneqqual malyears
print(nrow(tst))
print(sum(tst[,1]!=tst[,2]))
print(table(tst[,1]-tst[,2])) 

#assume most recent (i.e. greatest) malyear is the date of death
npdb.death$year = npdb.death$malyear1
  adjust = is.na(npdb.death$malyear2)==FALSE & npdb.death$malyear2>npdb.death$year
npdb.death$year[adjust] = npdb.death$malyear2[adjust]; rm(adjust)

#use fips to collect state names and numbers (confirm wonder uses fips)
#fips csv file downloaded from 
#https://www.census.gov/geo/reference/ansi_statetables.html
#4/20/2016

fips = read.csv(paste0(outdir,'fips.csv'))

#tabulate from ICD10 onward
npdbtab = as.data.frame(table(npdb.death[npdb.death$year>=1999,c('year','workstat','ptgender')]))
npdbtab$State.Code = 0
npdbtab$State.Name = as.character(NA)

for(r in fips$fips){
  abb = fips$abb[fips$fips == r]
  #print(c(r,abb))
  npdbtab$State.Code[as.character(npdbtab$workstat) %in% abb] = r
  npdbtab$State.Name[as.character(npdbtab$workstat) %in% abb] = as.character(fips$name[fips$fips==r])
}

#id unidentified abbreviations
print(unique(npdbtab$workstat[npdbtab$State.Code==0]))

#delete observations with death prior to 1999 and unknown gender
dat = npdbtab; rm(npdbtab,tst,npdb.death)
  full = sum(dat$Freq); print(full)

dat$year = as.numeric(levels(dat$year))[dat$year]
dat = dat[dat$year %in% 1999:2014,]
  dropyear = full - sum(dat$Freq); print(dropyear)

dat = dat[dat$ptgender %in% c('M','F'),]
  missgender = full - sum(dat$Freq); print(missgender)

#import compdeaths (state, year, gender)
dat$compdeaths = as.numeric(NA)

#see notes for rationale: mean 2-5 years behind
dat$lagcompdeaths = as.numeric(NA)
dat$lagmp = as.numeric(NA)

for(r in 1:nrow(dat)){
  ob = dat[r,]
  if(ob$State.Code == 0 | any(is.na(ob[,c('year','State.Code','ptgender')]))){
    next;
  } else {
    mortob = compmort$State.Code == ob$State.Code & 
            compmort$Year == ob$year & 
            compmort$Gender.Code == ob$ptgender
    dat[r,'compdeaths'] = compmort[mortob,'Deaths']
  }
  
    ys = (ob$year-2):(ob$year-5)
    print(c('lag',ys))
    meanob = compmort$State.Code == ob$State.Code & 
      compmort$Gender.Code == ob$ptgender
    
  #print(c(ys,mean(compmort[meanob,'Deaths'])))
    
    dat[r,'lagcompdeaths'] = mean(compmort[meanob & compmort$Year %in% ys,'Deaths'],na.rm=TRUE)

    lagob = dat$State.Code == ob$State.Code & 
            dat$ptgender == ob$ptgender &
            dat$year == (ob$year - 1)
    if(sum(lagob) == 1){
      dat[r,'lagmp'] = dat[lagob,'Freq'] }
}

#@@@@@
#Here, need to include some double book accounting
#to ensure accuracy
#@@@@@@

#missing data - initial strategy
#1) make 0 malpractice deaths into .5 (allows log)
dat$Freq[dat$Freq==0] = .5
#2) impute NA in compdeaths to 10 (it is NA when less than 20)

dat$compdeaths[is.na(dat$compdeaths)] = 10

#calculate relative rate of complications (can model)
dat$rrcomp = dat$compdeaths/dat$Freq

#log deaths
dat$lrrcomp = log(dat$rrcomp)

#View(dat[is.na(dat$lrrcomp),c('compdeaths','Freq')])
#View(dat[is.infinite(dat$lrrcomp),c('compdeaths','Freq')])


#include dummy indicator for damage cap states
#taken from Paik, Black, & Hyman. 2003
#Receding Tide of Med Mal Lit pt. 1, table 1
#nonecon after 2000 are switchcap

nocap = c('Alabama','Arizona','Arkansas','Connecticut','Delaware',
          'District of Columbia','Iowa','Kentucky','Maine','Minnesota',
          'New Hampshire','New Jersey','New York','North Carolina',
          'Pennsylvania','Rhode Island','Tennessee','Vermont','Washington',
          'Wyoming')

#make named list
nocap = setNames(as.list(rep(0,length(nocap))),nocap)

oldcap = c('Montana','North Dakota','Wisconsin','Alaska',
           'California','Colorado','Hawaii','Idaho',
           'Indiana','Kansas','Louisiana','Maryland',
           'Massachusetts','Michigan','Missouri','Nebraska',
           'New Mexico','Oregon','South Dakota','Utah',
           'Virginia','West Virginia')

#make named list
oldcap = setNames(as.list(rep(2014,length(oldcap))),oldcap)
#reassign for entire span
oldcap=lapply(oldcap,FUN = function(x) x=1999:2014) 

switchcap = list()
  switchcap[['Florida']] = switchcap[['Mississippi']] = 2003:2014
  switchcap[['Georgia']] = 2005:2009
  switchcap[['Illinois']] = 2006:2009
  switchcap[['Nevada']] = switchcap[['Ohio']] = 2003:2014
  switchcap[['Oklahoma']] = 2010:2014
  switchcap[['South Carolina']] = 2006:2014
  switchcap[['Texas']] = 2004:2014

sum(fips$name %in% names(c(nocap,oldcap,switchcap)))
length(c(nocap,oldcap,switchcap))

#fips$name[! fips$name %in% names(allcap)] all included

#include dummy variable for whether the state is a cap year 
#and dummy for type capstate

dat$nocap = dat$switchcap = dat$oldcap = 0 
  dat$nocap[dat$State.Name %in% names(nocap)] = 1
  dat$switchcap[dat$State.Name %in% names(switchcap)] = 1
  dat$oldcap[dat$State.Name %in% names(oldcap)] = 1

dat$cap = 0
allcap = c(nocap,switchcap,oldcap); rm(nocap,switchcap,oldcap)
for(s in 1:length(allcap)){
  dat$cap[dat$State.Name == names(allcap)[s] & dat$year %in% allcap[[s]]] = 1
}

dat$female = as.numeric(NA)
dat$female[dat$ptgender == 'F'] = 1
dat$female[dat$ptgender == 'M'] = 0

#export dat for analysis
#check with both agencies to see if this tabulation can 
#be publicly displayed

#save cleaned data as rda object for further analysis
save(dat,file=paste0(outdir,'private~/dat.rda'))

#save as csv for use in stata
write.csv(dat,paste0(outdir,'private~/analysis_dat.csv'))


#lme4
library(lme4)


