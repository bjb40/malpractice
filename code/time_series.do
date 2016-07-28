*dev Stata 14
*relative rate analysis
*for malpractice project - unit root and generalized least squares
*Bryce Bartlett


clear

import delimited ///
using H:/projects/malpractice/output/private~/analysis_dat.csv, ///
numericcols(_all)

drop if (year<2003 | year>2008 | statecode == 0)

gen stategender = statecode
replace stategender = statecode + 100 if female == 1

xtset stategender year

 *testing for unit root - all significant, so NOT stationary, and there is a lag process
 xtunitroot fisher lrrcomp, dfuller lags(1)
 xtunitroot fisher freq, dfuller lags(1)
 xtunitroot fisher compdeaths, dfuller lags(1)

 *this is the fgls n woolrdge p. 421 / inefficient
 *the specification is the "loosest", allowing panels to be different
 *okay, but these show a lot of stuff going on ...
  xtgls lrrcomp female cap switchcap year, panels(hetero) corr(psar1)
  xtgls freq compdeaths female oldcap switchcap year, panels(hetero) corr(psar1)
  xtgls freq female oldcap switchcap year, panels(hetero) corr(psar1)


  *does tort reform affect the reporting of deaths due to complicaitons (unspecified is alternative ratio...)
  xtgls compdeaths female oldcap switchcap year, panels(hetero) corr(psar1)
  xtgls compdeaths freq female oldcap switchcap year, panels(hetero) corr(psar1)
