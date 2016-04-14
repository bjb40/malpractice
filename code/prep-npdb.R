#Dev R 3.2.3 Wooden Christmas-Tree
#Cleans NPDB for analysis
#NPD downloaded 4/13/2016 
#from http://www.npdb.hrsa.gov/resources/publicData.jsp#termsOfAgree
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

#output table for types of actions by year 

#subset
subdat = subset(rawdat, outcome == 9, #death only
                select=c('origyear','workstat','homestat','licnstat','malyear1','malyear2','payment',
                         'totalpmt','paytype',
                         #patient demographics
                         'ptage','ptgender','pttype','algnnatr'))



