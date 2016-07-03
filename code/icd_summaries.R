#dev R 3.3.0 "Supposedly Educational"
#Bryce Bartlett
#uses data downloaded from https://github.com/bjb40/cause_death

#empty library
rm(list=ls())

#generals
library('knitr') #for outputing table

indir = 'H:/projects/cause_death/output/'
outdir = 'H:/projects/malpractice/output/'


#input and clean
icd10=read.csv(paste0(indir,'icd10.csv'))

#print(unique(icd10$nchsti))
comps  = icd10[icd10$nchs113==113,]

print(nrow(comps))

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#print table of complications
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

comps.divs = unique(comps[,c('div_nos','div_name')])

tables1 = paste0(outdir,'table-s1.md')

sink(tables1)
#header
cat('Table S-1. ICD-10 Causes of Death for "Complications of medical and surgical care"
    as defined by the NCHS.\n')
cat('\n\n|H1|H2|H3|\n')
cat('|:---|:-----|:----|\n')

for(div in seq_along(comps.divs$div_nos)){
  #print headings - bold
  dvn = levels(comps.divs$div_name)[comps.divs$div_name[div]]
  dvl = levels(comps.divs$div_nos)[comps.divs$div_nos[div]]
  cat('|   | **'); cat(dvn,dvl,sep='** | **'); cat('** |\n')
  
  #print levels under headings
  subn = comps$descrip[comps$div_name == dvn]
  subl = comps$code[comps$div_name == dvn]
  
  #print(length(subn))
  
  for(sub in seq_along(subn)){
    nm = levels(subn)[subn[sub]]
    no = levels(subl)[subl[sub]]
    cat('|');cat(no,nm,sep='|'); cat('| |\n')
  }
  
}

sink()

#create formated table
#pandoc(tables1)
pandoc(tables1,format='docx')

