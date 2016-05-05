*dev Stata 14
*relative rate analysis
*for malpractice - fixed effects
*Bryce Bartlett

clear

import delimited ///
using H:/projects/malpractice/output/private~/analysis_dat.csv, ///
numericcols(_all)

drop if (year<2003 | year>2008 | statecode == 0)

*no results:
xtmixed lrrcomp year oldcap switchcap female || statecode: || year:, cov(un)

xtmixed lrrcomp year oldcap switchcap female || statecode: year, cov(un)

xtmixed lrrcomp oldcap switchcap female ///
	year c.year#(c.oldcap c.switchcap c.female) ///
	|| statecode: year, cov(un) var

xtmixed lrrcomp oldcap switchcap female i.year || statecode:

xtmixed freq compdeaths oldcap switchcap female i.year || statecode:

xtmixed freq compdeaths oldcap switchcap female ///
	i.year|| statecode: compdeaths

xtset statecode

xtpoisson freq compdeaths c.compdeaths#(c.oldcap c.switchcap) female i.year, fe
xtpoisson freq c.compdeaths#(c.oldcap c.switchcap) female i.year, fe


*does tortreform affect reporting of deaths??
xtpoisson compdeaths c.compdeaths#(c.oldcap c.switchcap) female i.year, fe
