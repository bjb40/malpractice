#this is analysis of models and output for results of PAA poster
#using this for a clean version --- will clean models and delete later

##data manipulation for hlm model
#calculate mean, lag and difference
mal.dat = dat %>% 
  select(name,claimage,captype,deaths,n_reform,cap,
         compdeaths,comprate,paid,paidyear, lx.mal) %>%
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

#generate predicted data for plotting fit
#pick 3 random states
nms = sample(unique(mal.dat$name),1)

predict.bt = mal.dat[1:15,] %>% select(name,claimage_d)
predict.bt$comprate_d=(-7:7)/1000
predict.bt$ptgender='M'
predict.bt$malyear = 2004
predict.bt$name = nms
predict.bt$captype='nocap'
predict.bt$comprate_mn = mean(mal.dat$comprate_mn)
predict.bt$n_reform_d = mean(mal.dat$n_reform_d)
predict.bt$n_reform_mn = mean(mal.dat$n_reform_mn)
predict.tmp = predict.bt
c=1

for(i in unique(mal.dat$claimage_d)){
  #print(i)
  predict.tmp$claimage_d = i
  if(c!=1){
    predict.bt = rbind(predict.bt,predict.tmp)
  } else{
    predict.bt$claimage_d = i
  }
  c=c+1
}

#test=predict(mal.hlm2,predict.bt,type='response')


#u is the spherical errors on the random effects; use.u means not to draw new effects
#use.u=FALSE, means to integrate over the uncertainty in 'u' (theoretically)
#bootstrap 200
#bootstrap c.i.
predFun = function(fit){
  predict(fit,predict.bt,type="response")
}

#generates columns --- can sum up...
#bb=bootMer(mal.hlm2,nsim=2,FUN=predFun,use.u=TRUE,
#           parallel='multicore',ncpus=4,verbose=TRUE)

#predict.bt$pred=predict(mal.hlm2,predict.bt,type='response')
#predict.bt$up=apply(bb$t,2,quantile,prob=0.975)
#predict.bt$down=apply(bb$t,2,quantile,prob=0.025)

#sum over claimage for 10 years... bootstrap using bb

pr = predict.bt %>% 
  group_by(malyear,comprate_d) %>%
  summarize(pred=sum(pred))

ggplot(pr,aes(x=comprate_d*1000,y=pred*1000)) + 
         geom_line(linetype=2) 
#  geom_ribbon(aes(ymin=down*1000,ymax=up*1000,fill=captype),alpha=0.05)


###
#compdeaths model
#collapse by paidyear...
###

comp.dat = dat %>% 
  select(name,ptgender,captype,cap,paid,paidyear,n_reform) %>%
  filter(paidyear<=2014) %>%
  group_by(name,ptgender,paidyear,captype) %>%
  summarize(paid=sum(paid),
            n_reform=mean(n_reform),
            cap=mean(cap))

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
             n_reform,paidrate,cap)

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


#####
#plot fits
mal.pred = predictInterval(mal.hlm2,predict.bt,
                     which='fixed',
                     type='probability',
                     returnSims=TRUE)

predict.bt$fit = mal.pred$fit
predict.bt$up = mal.pred$upr
predict.bt$low = mal.pred$lwr

ggplot(predict.bt %>% filter(claimage_d>-2 & claimage_d<1),
       aes(x=comprate_d,
           y=fit,
           color=factor(claimage_d),
           group=claimage_d)) +
  geom_line() 

#sum over claimage
mal.sim = cbind(predict.bt[,'comprate_d'],
                data.frame(
                  inv.logit(attr(mal.pred,'sim.results')))
                )%>% 
  group_by(comprate_d) %>% 
  summarize_each(funs(sum(.)))

test = cbind(data.frame(t(apply(mal.sim[,2:ncol(mal.sim)],1,eff))),comprate_d=-7:7)

ggplot(test,aes(x=comprate_d,y=mean)) +
  geom_line() + geom_point() +
  geom_ribbon(aes(ymin=X2.5.,
                  ymax=X97.5.), alpha=0.25)

