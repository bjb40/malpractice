###

library(dplyr); library(reshape2)

dstlr.dir = "H:/Academic Projects/Data Files/DSTLR"
dstlr = read.csv(paste0(dstlr.dir,'/dstlr-5.1-02212015.csv'))

#code to change reforms to binary, i.e. top code to 1
dstlr = dstlr %>% 
  mutate_at(vars(starts_with('r_')),funs(ifelse(.>0,1,.)))

#check coding
print(
  summarize_at(dstlr,vars(starts_with('r_')),funs(max(.,na.rm=TRUE)))
)

print(
  summarize_at(dstlr,vars(starts_with('r_')),funs(min(.,na.rm=TRUE)))
)

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

noaxis =   theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank(),
                 axis.line = element_blank()) 

map.dat = merge(map_data('state') %>% rename(name=region),
                dstlr %>% filter(year==2012) %>% mutate(name=tolower(name)),by='name')

  tspag = ggplot(dstlr, aes(x=year, y=n_reform)) + 
    geom_line() + guides(colour=FALSE) 
  spag = tspag + aes(colour = factor(name)) +
    geom_smooth(se=FALSE, colour='black', size=2)
  print(spag)

  map.plot=ggplot(map.dat,aes(long,lat,group=group)) + 
    geom_polygon(aes(fill=n_reform,color=factor(r_cap)),size=1.3,linetype=3) + coord_fixed() +
    theme_classic() + noaxis 
  
print(map.plot)
ggsave(paste0(draftimg,'tort_reform.png'),
       h=10,w=18,units='in',dpi=200)

reform = c('r_cn','r_cp','r_ct','r_sr',
           'r_cs','r_pe','r_pp',
           'r_cf','r_js','r_pcf','r_cmpf')

reform.names = c('Nonecon Cap','Punitive Cap','Total Cap',
                 'Split Recovery','Collateral Source',
                 'Punitive Evidence','Periodic Payments',
                 'Contingency Fee','Joint & Several Liab.',
                 'Patient Compensation','Comparative Fault')

  #@@@@@@@@@@@@@@@@@
  #plot correlations
  corrs=
    cor(select(dstlr,starts_with('r_'),-r_cap),
        use='pairwise.complete.obs')
  #corrs[upper.tri(corrs)] = NA
mcors = melt(corrs) 
levels(mcors$Var1) = levels(mcors$Var2) = reform.names

corplot=  qplot(x=Var2,y=ordered(Var1,levels=rev(sort(unique(Var1)))),
        data= mcors)  + 
    geom_tile(aes(fill=value)) +
    scale_fill_gradient2(limits=c(-1,1),low=muted('red'),high=muted('blue'),mid='white',midpoint=0) +
    theme(axis.line=element_blank(),
          axis.text.x=element_text(angle=45,hjust=1),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank())
  
print(corplot)
  ggsave(paste0(outdir,'correlations.pdf'))
  