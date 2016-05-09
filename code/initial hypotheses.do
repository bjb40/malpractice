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
  xtgls freq lagcompdeaths female cap switchcap year, panels(hetero) corr(psar1)
  
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
  
 xtnbreg freq lagcompdeaths female i.year, fe
 xtnbreg freq lagcompdeaths cap female i.year, fe
  
 *logged value
 gen lnfbycomp = log(freq)/log(lagcompdeaths)
  xtgls lnfbycomp female cap switchcap year, panels(hetero) corr(psar1)
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 2: increases in medmal claims are associated with deaths due to complications 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

 * linear
 reg compdeaths lagmp female cap switchcap year

 xtset stategender year
 *this is the fgls n woolrdge p. 421 / inefficient
  xtgls compdeaths lagmp female cap switchcap year, panels(hetero) corr(psar1)
  
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

 xtpoisson compdeaths lagmp female i.year, fe
 xtpoisson compdeaths lagmp cap female i.year, fe
 
 *not supported here
 xtnbreg compdeaths lagmp female i.year, fe
 xtnbreg compdeaths lagmp cap female i.year, fe
