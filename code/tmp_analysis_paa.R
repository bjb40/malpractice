#this is analysis of models and output for results of PAA poster
#using this for a clean version --- will clean models and delete later

##data manipulation for hlm model
#calculate mean, lag and difference

dat = dat %>% ungroup

mal.dat = dat %>% 
  select(name,claimage,captype,deaths,n_reform,cap,ptgender,malyear,
         compdeaths,comprate,paid,paidyear, lx.mal,
         starts_with('r_'),-r_cap) %>%
  group_by(name,ptgender) %>%
  arrange(malyear) %>%
  mutate_each(funs(mn=mean(.,na.rm=TRUE), 
                   lag=lag(.,order_by=malyear),
                   d=mean(.,na.rm=TRUE) - .),
              -captype,-name,-ptgender,-lx.mal)

###
#malpractice model
#cohort model
###

#plm --- doesn't work
#plm(formula=I(paid/lx.mal)~comprate,
#    data=mal.dat %>% ungroup,
#    index=c('name','ptgender','malyear'))


mal.m1 = glm(cbind(paid,lx.mal)~ ptgender + n_reform +
           claimage+I(claimage^2) + I(claimage^3) + 
           cap + I(malyear-2009) + name,
    family=binomial(logit),data=mal.dat)

summary(mal.m1)

#cubic term is a problem
mal.hlm1 = glmer(cbind(paid,lx.mal)~ ptgender +
                   claimage + I(claimage^2) + 
                   + malyear_d + 
                   captype + n_reform_d + n_reform_mn +
                   (1|name),
                 family=binomial(logit),data=mal.dat)

summary(mal.hlm1)


#delta and mean give positive results
#first order lag gives negative, but nonsignificant...

mal.m2 = glm(cbind(paid,lx.mal)~ ptgender + n_reform +
               factor(claimage) + 
               factor(malyear) + 
               I(comprate_d*1000) + I(comprate_mn*1000) +
               name,
             family=binomial(logit),data=mal.dat)

summary(mal.m2)


mal.hlm2 = glmer(cbind(paid,lx.mal)~ ptgender +
               I(claimage_d/10) + I((claimage_d/10)^2) +
               + I(malyear-2009) + 
               I(comprate_d*1000) + I(comprate_mn*1000) +
                 captype + n_reform_d + n_reform_mn +
                 (1|name),
             family=binomial(logit),data=mal.dat)

summary(mal.hlm2)


form = paste('cbind(paid,lx.mal)~ ptgender +
                   I(claimage_d/10) + I((claimage_d/10)^2) +
                   + I(malyear-2009) + 
                   I(comprate_d*1000) + I(comprate_mn*1000) +', 
                    paste(paste0(reform,'_mn'),collapse='+'),'+',
                    paste(paste0(reform,'_d'),collapse='+'),
                   '+(1|name)')

form2 = paste('cbind(paid,lx.mal)~ ptgender +
                   I(claimage_d/10) + I((claimage_d/10)^2) +
                   + I(malyear-2009) + 
                   I(comprate_d*1000) + I(comprate_mn*1000) +', 
             paste(reform,collapse='+'),
             '+(1|name)')

###new model for presentation
#rank deficiency for a number of 
mal.hlm3 = glmer(form2,
                 family=binomial(logit),data=mal.dat)

summary(mal.hlm3)

mal3.sim = FEsim(mal.hlm3,n.sims=200)
reform.eff = grepl('r_',mal3.sim$term)
levels(mal3.sim$term)[reform.eff] = reform.names[order(sort(reform))]
plotFEsim(mal3.sim[reform.eff,],oddsRatio=TRUE) + 
  labs(title='Effect of Tort Reform on Paid Claim Rates.') +
  ylab('Odds Ratio') +
  theme(axis.title.y = element_blank(),
        plot.title=element_text(hjust=1))

ggsave(paste0(draftimg,'reform-mprates.pdf'))


###
#compdeaths model
#collapse by paidyear...
###
dat=dat %>% ungroup
comp.dat = dat %>% 
  dplyr::select(name,ptgender,captype,cap,paid,paidyear,n_reform,starts_with('r_')) %>%
  filter(paidyear<=2014) %>%
  group_by(name,ptgender,paidyear) 

tst = summarize_at(comp.dat,vars(cap,paid,n_reform,starts_with('r_')),funs(mean(.,na.rm=TRUE)))

comp.dat_m = dat %>%
  group_by(name,ptgender,malyear) %>%
  summarize(deaths=mean(deaths),
            compdeaths=mean(compdeaths)) %>% 
  rename(paidyear=malyear)

comp.dat = merge(comp.dat,comp.dat_m,by=c('name','ptgender','paidyear'))
rm(comp.dat_m)

#create lag, etc.
comp.dat = comp.dat %>% 
  group_by(name,ptgender) %>%
  arrange(paidyear) %>%
  mutate(paidrate=paid/deaths) %>%
  mutate_each(funs(mn=mean(.,na.rm=TRUE), 
                   lag=lag(.,order_by=paidyear),
                   d=mean(.,na.rm=TRUE) - .),
             n_reform,paidrate,cap,starts_with('r_'))

comp.m1 = glm(cbind(compdeaths,deaths)~ ptgender +
               I(paidyear-2009) + n_reform_d + n_reform_mn + name,
             family=binomial(logit),data=comp.dat)

summary(comp.m1)

comp.hlm1 = glmer(cbind(compdeaths,deaths)~ ptgender +
                captype + I((paidyear-2009)/10) + n_reform_d +
                  n_reform_mn +
                  (1|name),
              family=binomial(logit),data=comp.dat)

summary(comp.hlm1)

comp.m2 = glm(cbind(compdeaths,deaths)~ ptgender +
                captype + I(paidyear-2009) + 
                n_reform_mn + n_reform_d + 
                + paidrate_mn + paidrate_d + name,
              family=binomial(logit),data=comp.dat)

summary(comp.m2)


comp.hlm2 = glmer(cbind(compdeaths,deaths)~ ptgender +
                    captype + I((paidyear-2009)/10) + 
                    I(paidrate_d*1000) + I(paidrate_mn*1000) +
                    (1|name),
                  family=binomial(logit),data=comp.dat)

summary(comp.hlm2)

comp.hlm3 = glmer(cbind(compdeaths,deaths)~ ptgender +
                    captype + I((paidyear-2009)/10) + 
                    I(paidrate_d*1000) + I(paidrate_mn*1000) 
                    (1|name),
                  family=binomial(logit),data=comp.dat)

summary(comp.hlm3)

#######
#results plots -- 2 maps and a bar chart with between within

mal.pred = predictInterval(mal.hlm2,
                              mal.dat,
                              which='full',
                              type='probability')
mal.dat$fit = mal.pred$fit
mal.dat$upr = mal.pred$upr
mal.dat$lwr = mal.pred$lwr


noaxis =   theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank(),
                 axis.line = element_blank()) + coord_equal(ratio=1)


####
#malpractice map 2009
mal.map = mal.dat %>% 
  filter(malyear==2009,ptgender=='M') %>% 
  group_by(name,captype) %>%
  summarize(fit=sum(fit))

library(maps)
mal.map = merge(map_data('state') %>% rename(name=region),
                mal.map %>% 
                  group_by(name,captype) %>% 
                  ungroup %>%
                  mutate(name=tolower(name)),
                by='name')

mal.plot=ggplot(mal.map,aes(long,lat,group=group)) + 
    geom_polygon(aes(fill=fit,color=factor(captype)),size=1.3,linetype=3) + 
  theme_classic() + + coord_equal(ratio=1) +
  scale_fill_continuous(name='Pred. Rate') +
  scale_color_discrete(name='')

print(mal.plot+noaxis+labs(title='Predicted 10-Year Malpractice Rates',
                           caption='Full model, for Deaths in 2009'))

ggsave(filename=paste0(draftimg,'malmap.png'),
       h=10,w=18,units='in',dpi=200)

######
#iatrogenic fit stats
comp.pred = predictInterval(comp.hlm2,
                           comp.dat,
                           which='full',
                           type='probability')
comp.dat$fit = comp.pred$fit
comp.dat$upr = comp.pred$upr
comp.dat$lwr = comp.pred$lwr

  
####
#iatrogenic map 2009
comp.map = comp.dat %>% 
  filter(paidyear==2009,ptgender=='M') %>% 
  group_by(name) %>%
  summarize(fit=sum(fit))

comp.map = merge(map_data('state') %>% rename(name=region),
                comp.map %>% 
                  group_by(name) %>% 
                  ungroup %>%
                  mutate(name=tolower(name)),
                by='name')

comp.plot=ggplot(comp.map,aes(long,lat,group=group)) + 
  geom_polygon(aes(fill=fit),color='grey',size=.5) +
  theme_classic() +
  scale_fill_gradient(name='Pred. Rate',low=muted('red'),high='red')

print(comp.plot+noaxis+labs(title='Predicted Complications Rates',
                           caption='Full model, for Deaths in 2009'))

ggsave(filename=paste0(draftimg,'compmap.png'),
       h=10,w=18,units='in',dpi=200)

####
#barplots of between and within


mal.sim = FEsim(mal.hlm2,n.sims=200)
plotFEsim(mal.sim[6:7,])

comp.sim = FEsim(comp.hlm2,n.sims=200)
plotFEsim(comp.sim[6:7,])

sim=rbind(mal.sim[6:7,],comp.sim[6:7,])
sim$term = as.character(levels(sim$term)[sim$term]); sim$mal=TRUE
sim[1,'term'] = 'Within-State Complications Rate'
sim[2,'term'] = 'Between-State Complications Rate'
sim[3,'term'] = 'Within-State Malpractice Rate'; sim[3,'mal']=FALSE
sim[4,'term'] = 'Between-State Malpractice Rate'; sim[4,'mal']=FALSE

plt1 = plotFEsim(sim[1:2,],oddsRatio=TRUE) + 
  ylim(0.9,1.3) +
  labs(title='Effect on Malpractice Rate') +
  theme(axis.text.x=element_blank(),
        axis.title.y=element_blank(),
        axis.title.x=element_blank(),
        plot.title=element_text(hjust=1)
  )

plt2 = plotFEsim(sim[3:4,],oddsRatio=TRUE) + 
  ylim(0.9,1.3) +
  labs(title='Effect on Complications Rate') +
  ylab('Odds Ratio') +
  theme(axis.title.y = element_blank(),
        plot.title=element_text(hjust=1))

library(gridExtra)

pdf(file=paste0(draftimg,'effs.pdf'))
  grid.arrange(plt1,plt2,nrow=2)
dev.off()

png(filename=paste0(draftimg,'effs.png'),
    height=10,width=19,units='in',res=200)
  grid.arrange(plt1,plt2,nrow=2)
dev.off()


