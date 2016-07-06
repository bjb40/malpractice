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

 eststo clear
 eststo: xtpoisson freq lagcompdeaths female i.year, fe
 eststo: xtpoisson freq lagcompdeaths cap female i.year, fe
  esttab
  
  xtset statecode
  
 eststo clear
 eststo: xtnbreg freq cap i.year, fe
 eststo: xtnbreg freq lagcompdeaths cap i.year, fe
  
  esttab
  
 *logged value
 *gen lnfbycomp = log(freq)/log(lagcompdeaths)
 * xtgls lnfbycomp female cap switchcap year, panels(hetero) corr(psar1)
 
 
 *************************
 *************************
 *Hybrid model for use
 *************************
 *************************
 
 
 
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
 
 *supported here
 eststo clear
 eststo: xtpoisson compdeaths lagmp female i.year, fe
 eststo: xtpoisson compdeaths lagmp cap female i.year, fe
 eststo: xtpoisson compdeaths freq cap female i.year, fe
 
 esttab
 
 *not supported here -- INEFFICIENT
 xtset stategender
 eststo clear
 eststo: xtnbreg compdeaths cap i.year, fe
 eststo: xtnbreg compdeaths lagmp cap i.year, fe

 esttab
 
 *allison conditional model
 *http://statisticalhorizons.com/fe-nbreg
 
 *individual specific means
 egen mcompdeaths = mean(compdeaths), by(stategender) 
 egen mcap = mean(cap), by(stategender)
 egen mlagmp = mean(lagmp), by(stategender)
 
 *time-varying deviations from means
 gen dcompdeaths = compdeaths - mcompdeaths
 gen dcap = cap - mcap
 gen dlagmp = lagmp - mlagmp
 
 eststo clear
 xtset stategender
 eststo: xi: xtnbreg compdeaths  mcap mlagmp dcap dlagmp i.year, re
 eststo: xi: xtnbreg compdeaths  mcap mlagmp dcap dlagmp i.year, pa robust
 
 esttab
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 3: spike -- first difference models same as H2
*http://www.statalist.org/forums/forum/general-stata-discussion/general/193879-first-difference-regression
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 




*@@@@@@@@@@@@@@@@
*percentile recodes
*@@@@@@@@@@@@@@@@


tsset stategender year

gen dmp = d.lagmp

*create percentile cuts for lagmp
centile(dmp), centile(50 75 90 95)
egen dmp_high = cut(dmp), at(-100,0,3,8,13,40) label
*cut based on analyisis
gen dmp90 = 0
	replace dmp90=1 if dmp>13 
centile(lagmp), centile(50 75 90 95)
egen lagmp_high = cut(lagmp), at (15,35.75,79.7,133.35) label

*@@@@@@@@@@@@@@@
*@@@@@@@@@@@@@@@
*HERE
*@@@@@@@@@@@@@@@
*@@@@@@@@@@@@@@@


eststo clear
 xtset stategender year
 *this is the fgls n woolrdge p. 421 / inefficient
  eststo: xtgls compdeaths female cap switchcap year, panels(hetero) corr(psar1)
  eststo: xtgls compdeaths dmp female cap switchcap year, panels(hetero) corr(psar1)
  eststo: xtgls compdeaths dmp#i.dmp_high female cap switchcap year, panels(hetero) corr(psar1)
esttab


 *supported here
 xtset statecode
 eststo clear
 eststo: xtpoisson compdeaths lagmp female i.year, fe
 eststo: xtpoisson compdeaths lagmp cap female i.year, fe
 eststo: xtpoisson compdeaths freq cap female i.year, fe
esttab


*@@@@@@@@@@@@@@@
*hybrid
*@@@@@@@@@@@@@@@

egen mdmp = mean(dmp), by(stategender)
egen mdmp90 = mean(dmp90), by(stategender)
gen ddmp = dmp - mdmp
gen ddmp90 = dmp90-mdmp90

*includes female/state trends
 xtset stategender 
 eststo clear
 eststo: xi: xtnbreg compdeaths female oldcap switchcap mcap mlagmp mdmp90 dcap dlagmp ddmp90 i.year, re
 eststo: xi: xtnbreg compdeaths female oldcap switchcap  mcap mlagmp mdmp90 dcap dlagmp ddmp90 i.year, pa robust
esttab



eststo clear
eststo: xtreg d.compdeaths i.year
eststo: xtreg d.compdeaths d.lagmp i.year
eststo: xtreg d.compdeaths d.cap i.year
eststo: xtreg d.compdeaths d.lagmp d.cap i.year

esttab


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

 
 