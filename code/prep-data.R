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
  
  #save as dta object
  save(rawdat,file=paste0(outdir,'private~/rawdat.rda'))
}

#output table for types of actions by year??

#subset
npdb.death = subset(rawdat, outcome == 9, #death only
              select=c('origyear','workstat','homestat','licnstat','malyear1','malyear2','payment',
                       'totalpmt','paytype',
                       #patient demographics
                       'ptage','ptgender','pttype','algnnatr'))


rm(rawdat)

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

#tabulate from ICD10 onward
npdbtab = as.data.frame(table(npdb.death[npdb.death$year>=1999,c('year','workstat','ptgender')]))

#compmort sufficiently aggregated




