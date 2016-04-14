#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#Dev R 3.2.1 "World Famous Astronaut";x86_64-w64-mingw32/x64 (64-bit)
#Script sets universal configuration and objects
#Bryce Bartlett
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#@@
#options

#source("H:/projects/proposal/r_study/code/funs.R")

#turn off sicentific notation for display
options(scipen=999, digits=3)

#@@
#Directories

#datasource
rawdir = "H:/Academic Projects/Data Files/NPD/"
#parent directory
projdir = "H:/projects/proposal/r_study/"
#directory for output
outdir = paste0(projdir,"output/")

#@@
#Files and temp folders

#test for and create private~ output folder
if(file.exists(paste0(outdir, "private~"))== F)
{dir.create(paste0(outdir,"private~"))}

#test for and create draft_img~ folder
if(file.exists(paste0(projdir,'draft_img~'))==F)
{dir.create(paste0(projdir,'draft_img~'))}

finalimg = paste0(projdir,'img/')
draftimg = paste0(projdir,'draft_img~/')