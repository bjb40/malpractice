#reviewing allegations for failure to treat...

#load npdb rawdat
load(paste0(outdir,'private~/rawdat.rda'))

library(dplyr); library(reshape2); library(ggplot2)
library(maptools); library(maps)

#note: NO missing on alegatn1, missing on alegatn2 - wierd
rawdat$alegatn2[is.na(rawdat$alegatn2)] = 1000

ldat = rawdat %>% 
  filter(outcome==9 & rectype=='P') %>% #limit to mortality & malpractice data
  mutate(notreat=ifelse(alegatn1 < 200 | alegatn2 < 200,1,
                        ifelse(alegatn1>800 & alegatn2>800, NA,0)))

testtab=
table(ldat[,c('alegatn1','alegatn2','notreat')],useNA='always')

print(
  table(ldat$notreat,useNA='always')
)

#impossible values test --- should all return 0
nrow(ldat %>% filter(alegatn1 < 200 & notreat==0))
nrow(ldat %>% filter(alegatn2 < 200 & notreat==0))
nrow(ldat %>% filter(alegatn1 > 200 & alegatn1<800 &
                     alegatn2 > 200 & alegatn2<800 &
                       notreat==1))
nrow(ldat %>% filter(is.na(notreat) &
                       (alegatn1<800 | alegatn2<800)))

#deltas
pltdat=ldat %>% 
  group_by(origyear,workstat) %>%
  summarize(prop_notreat=sum(notreat,na.rm=TRUE)/n())

ggplot(pltdat,aes(x=origyear,y=prop_notreat,col=workstat)) +
  geom_line() + geom_point()

#map

state.map=map_data('state')
#csv loaded prep-data
fips.map = merge(fips %>% mutate(region=tolower(name)),
                 state.map,by='region',
                 sort=FALSE,all.y=TRUE)


for(y in unique(pltdat$origyear)){
choro=merge(pltdat %>% 
              filter(origyear==y) %>% 
              rename(abb=workstat),
            fips.map,sort=FALSE,by='abb',
            all.y=TRUE
            )
choro = choro[order(choro$order),]
map.plot = qplot(long,lat,data=choro,group=group,fill=prop_notreat,
      geom='polygon')

print(map.plot)
Sys.sleep(5)

}