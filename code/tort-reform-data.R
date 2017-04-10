###

library(dplyr)

dstlr.dir = "H:/Academic Projects/Data Files/DSTLR"
dstlr = read.csv(paste0(dstlr.dir,'/dstlr-5.1-02212015.csv'))

dstlr=dstlr %>% 
  dplyr::select(name,year,r_cn,r_cp,r_ct,r_sr,r_cs,r_pe,r_pp,r_cf,r_js,r_pcf,r_cmpf) %>%
  mutate(r_cap=r_cn+r_cp+r_ct,
         n_reform=r_cap+r_sr+r_cs+r_pe+r_pp+r_cf+r_js+r_pcf+r_cmpf)

#impute 2013-2015 with 2012 levels
for(y in 2013:2015){
  dstlr = rbind(dstlr,dstlr %>% filter(year==2012) %>% mutate(year=y))
}
  
#create a .gif
#https://github.com/tidyverse/ggplot2/wiki/Using-ggplot2-animations-to-demonstrate-several-parallel-numerical-experiments-in-a-single-layout
  
library(ggplot2); library(maps)
map.dat = merge(map_data('state') %>% rename(name=region),
                dstlr %>% filter(year==2012) %>% mutate(name=tolower(name)),by='name')

  tspag = ggplot(dstlr, aes(x=year, y=n_reform)) + 
    geom_line() + guides(colour=FALSE) 
  spag = tspag + aes(colour = factor(name)) +
    geom_smooth(se=FALSE, colour='black', size=2)
  print(spag)

  map.plot=ggplot(map.dat,aes(long,lat,group=group)) + 
    geom_polygon(aes(fill=n_reform,color=factor(r_cap)),size=1.3,linetype=3)
  
  print(map.plot)
  
  