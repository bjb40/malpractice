*dev Stata 14
*prelim analysis of switching states
*for malpractice
*Bryce Bartlett

*no effects -- !!

clear

import delimited ///
using H:/projects/malpractice/output/private~/agg_switch.csv, ///
numericcols(_all)

gen lrrcomp = log(rrcomp) //10 missing values

xtset statecode

*linear
xtreg rrcomp year cap c.year#c.cap female, fe
xtreg rrcomp year cap c.year#c.cap female if(year>2003 & year<2008), fe

*loglin
xtreg lrrcomp year cap c.year#c.cap female, fe
xtreg lrrcomp year cap c.year#c.cap female if(year>2003 & year<2008), fe


*poisson
xtpoisson rrcomp year cap c.year#c.cap female, fe
xtpoisson rrcomp year cap c.year#c.cap female if(year>2003 & year<2008), fe

*negbin
xtnbreg rrcomp year cap c.year#c.cap female, fe
xtnbreg rrcomp year cap c.year#c.cap female if(year>2003 & year<2008), fe
