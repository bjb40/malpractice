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
      geom='polygon') + theme(legend.position='bottom')

print(map.plot)
ggsave('test.pdf') #need to adjust size based on 1:1 scale for lat and long
Sys.sleep(5)

}

library(maps)
library(ggmap)
home= geocode('2137 Old Oxford Road East, Chapel Hill, NC',output='latlon')

nc=map_data('county') %>% filter(region=='north carolina')
nc=nc[order(nc$order),]

ggplot(nc,aes(long,lat,group=group)) + 
  geom_polygon(fill=NA,color='black') +
  geom_point(data=home,aes(lon,lat,group=NA)) + 
  geom_text(data=home,aes(lon+.24,lat,label=name,group=NA),size=3)

