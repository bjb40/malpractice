#bryce bartlett
#arf preparation

#preliminaries

library(tidyr)

#read data
arf.raw='H:/Academic Projects/Data Files/HRSA/ARF/tony_dat/'
arf.files=list.files(arf.raw,pattern='.csv')
arf.dat = lapply(arf.files,function(x) read.csv(paste0(arf.raw,x)))

#combine data into one wide frame
arf.wide=do.call(cbind,arf.dat)

#check multiple fips columns
fps.cols = which(colnames(arf.wide)=='FIPS')
fps = arf.wide[,fps.cols]

#check for equality -- sd is 0 if they are equal
fps.check = all(apply(fps,1,sd)==0)
if(!fps.check){
  print('PROBLEM WITH FIPS CODES...')
  Sys.sleep(5)
} 

colnames(fps)=tolower(colnames(fps)); fps = fps/1000
fps = merge(fps,fips)[,c(1,7,8)]

arf.wide = cbind(arf.wide[,!(1:ncol(arf.wide) %in% fps.cols)],fps)
arf.wide$fips = as.factor(arf.wide$fips)
#reshape2
arf.dat = melt(arf.wide,id.vars=c('fips','name','abb'))
arf.dat$variable = as.character(arf.dat$variable)
arf.dat$variable[arf.dat$variable=='pop200'] = 'pop2000'

#split out year
arf.dat = arf.dat %>% 
  mutate(year = as.numeric(substr(variable,
                                  start=nchar(variable)-3,
                                  stop=nchar(variable))),
          variable = substr(variable,
                            start=1,
                            stop=nchar(variable)-4))

#cast variables to dataframe
arf.dat = dcast(arf.dat,id.vars=c('fips','name','abb','year'),
            name+year~variable)

#cleanup
rm(fps,fps.check,fps.cols,arf.files,arf.wide)

#percapita 1000
arf.dat = arf.dat %>% 
  filter(year > 2003 & year< 2016) %>%
  mutate_at(vars(hospbeds,hosptot,mdactnfd,mdcragdienr,mdsptcnfd),funs(.*1000/pop)) %>%
  dplyr::select(-pop,-mcaidelig)

#impute---when data gets uploaded again, can fix
  

save(arf.dat,file=paste0(outdir,'arf-dat.RData'))
