*dev Stata 14
*basic tests of hypotheses
*for malpractice - fixed effects
*Bryce Bartlett


clear

import delimited ///
using H:/projects/malpractice/output/private~/analysis_dat.csv, ///
numericcols(_all)

drop if (year<2003 | year>2008 | statecode == 0)

gen stategender = statecode
replace stategender = statecode + 100 if female == 1

xtset stategender year

 *testing for unit root - all significant, so .... stationary?s
 *xtunitroot fisher lrrcomp, dfuller lags(1)
 *xtunitroot fisher freq, dfuller lags(1)
 *xtunitroot fisher compdeaths, dfuller lags(1)

 *should probably turn these into rates...
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 1: lower patient safety (large compdeaths) are associated with increased claims 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 
 * linear
 reg freq lagcompdeaths female cap switchcap year
 
 *this is the fgls n woolrdge p. 421 / inefficient
 
  eststo: xtgls freq female oldcap switchcap year, panels(hetero) corr(psar1)
  eststo: xtgls freq lagcompdeaths female oldcap switchcap year, panels(hetero) corr(psar1)
  
  esttab
  
  xtset statecode
 *re
 xtmixed freq lagcompdeaths year oldcap switchcap female || statecode: || year:, cov(un)
 xtmixed freq lagcompdeaths year oldcap switchcap female || statecode: year, cov(un)
 
 xtpoisson freq lagcompdeaths year oldcap switchcap female, re
 xtnbreg freq lagcompdeaths year oldcap switchcap female, re

 
 *fe
 reg freq lagcompdeaths oldcap switchcap female i.statecode i.year
 xtreg freq lagcompdeaths female i.year, fe 
 xtreg freq lagcompdeaths cap female i.year, fe 

 xtpoisson freq lagcompdeaths female i.year, fe
 xtpoisson freq lagcompdeaths cap female i.year, fe
  
  xtset statecode
  
 eststo clear
 eststo: xtnbreg freq cap i.year, fe
 eststo: xtnbreg freq lagcompdeaths cap i.year, fe
  
  esttab
  
 *logged value
 *gen lnfbycomp = log(freq)/log(lagcompdeaths)
 * xtgls lnfbycomp female cap switchcap year, panels(hetero) corr(psar1)
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 2: increases in medmal claims are associated with deaths due to complications 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

 * linear
 reg compdeaths lagmp female cap switchcap year

 eststo clear
 xtset stategender year
 *this is the fgls n woolrdge p. 421 / inefficient
  eststo: xtgls compdeaths female cap switchcap year, panels(hetero) corr(psar1)
  eststo: xtgls compdeaths lagmp female cap switchcap year, panels(hetero) corr(psar1)
  
  eststo: xtgls compdeaths freq female cap switchcap year, panels(hetero) corr(psar1)
  
  esttab
  
  xtset statecode
 *re
 xtmixed compdeaths lagmp year oldcap switchcap female || statecode: || year:, cov(un)
 xtmixed compdeaths lagmp year oldcap switchcap female || statecode: year, cov(un)
 
 xtpoisson compdeaths lagmp year oldcap switchcap female, re
 xtnbreg compdeaths lagmp year oldcap switchcap female, re

 
 *fe
 reg compdeaths lagmp oldcap switchcap female i.statecode i.year
 xtreg compdeaths lagmp female i.year, fe 
 xtreg compdeaths lagmp cap female i.year, fe 
 xtreg  compdeaths freq cap female i.year,fe
 
 xtpoisson compdeaths lagmp female i.year, fe
 xtpoisson compdeaths lagmp cap female i.year, fe
 xtpoisson compdeaths freq cap female i.year, fe
 
 
 *not supported here
 eststo clear
 eststo: xtnbreg compdeaths cap i.year, fe
 eststo: xtnbreg compdeaths lagmp cap i.year, fe

 esttab
 
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 3: spike -- first difference models same as H2
*http://www.statalist.org/forums/forum/general-stata-discussion/general/193879-first-difference-regression
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

xtset stategender year




eststo clear
eststo: xtreg d.compdeaths i.year
eststo: xtreg d.compdeaths d.lagmp i.year
eststo: xtreg d.compdeaths d.cap i.year
eststo: xtreg d.compdeaths d.lagmp d.cap i.year

esttab


*@@@@@@@@@@@@@@@@
*percentile recodes
*@@@@@@@@@@@@@@@@


tsset stategender year

gen dmp = d.lagmp

*create percentile cuts for lagmp
centile(dmp), centile(50 75 90 95)
egen dmp_high = cut(dmp), at(-100,0,3,8,13,40) label

*@@@@@@@@@@@@@@@
*@@@@@@@@@@@@@@@
*HERE
*@@@@@@@@@@@@@@@
*@@@@@@@@@@@@@@@

*quadratic linear--no effect
 eststo clear
 eststo: xtreg d.compdeaths d.cap i.year
 eststo: xtreg d.compdeaths dmp c.dmp#i.dmp_high i.year d.cap
 esttab

*piecewise apparent effect 
 eststo clear
 eststo: xtnbreg compdeaths cap i.year, fe
 eststo: xtnbreg compdeaths lagmp i.lagmp_high c.lagmp#i.lagmp_high cap i.year, fe
 esttab

 
 eststo clear
 eststo: xtpoisson compdeaths cap i.year, fe
 eststo: xtpoisson compdeaths lagmp i.lagmp_high c.lagmp#i.lagmp_high cap i.year, fe
 esttab

 
 *lower interddept, higher slope 
 eststo clear
 eststo: xtmixed compdeaths cap i.year || stategender:
 eststo: xtmixed compdeaths lagmp i.lagmp_high c.lagmp#i.lagmp_high cap i.year || stategender:
 esttab

 
 *piecewise apparent effect 
*no effect
 eststo clear
 eststo: nbreg compdeaths cap i.year
 eststo: nbreg compdeaths lagmp i.lagmp_high c.lagmp#i.lagmp_high cap i.year
 esttab

 
 