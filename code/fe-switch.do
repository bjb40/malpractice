*dev Stata 14
*prelim analysis of switching states
*for malpractice - fixed effects
*Bryce Bartlett

*no effects -- !!

clear

import delimited ///
using H:/projects/malpractice/output/private~/agg_switch.csv, ///
numericcols(_all)

drop if(year > 2003 & year < 2008 & statecode == 0)

*gen lrrcomp = log(rrcomp) //10 missing values

xtset statecode

*linear
xtreg rrcomp year cap c.year#c.cap female, fe
xtreg rrcomp year cap c.year#c.cap female if(year>2003 & year<2008), fe


****This is reall interesting, here--how much is IL driving?******
*Q: does tort reform affect the reporting of deaths due to complications?
*cap decreses by 44, then increasses by .022 each year... (general decreaasse)
xtnbreg compdeaths year cap c.year#c.cap female, fe
*cap increases filings by 124, then decreases by .062...
xtnbreg freq year cap c.year#c.cap female, fe


*loglin
xtreg lrrcomp year cap c.year#c.cap female, fe
xtreg lrrcomp year cap c.year#c.cap female if(year>2003 & year<2008), fe


*poisson
xtpoisson rrcomp year cap c.year#c.cap female, fe
xtpoisson rrcomp year cap c.year#c.cap female if(year>2003 & year<2008), fe

*negbin
xtnbreg rrcomp year cap c.year#c.cap female, fe
xtnbreg rrcomp year cap c.year#c.cap female if(year>2003 & year<2008), fe
