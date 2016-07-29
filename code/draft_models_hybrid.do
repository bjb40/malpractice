*dev Stata 14
*models including rate
*Bryce Bartlett

clear

import delimited ///
using H:/projects/malpractice/output/private~/analysis_dat.csv, ///
numericcols(_all)

drop if (year<2003 | year>2008 | statecode == 0)

**scale rates by 10000
scalar scale =  10000

replace mprate = mprate*scale
replace comprate = comprate*scale
replace lagmprate = lagmprate*scale
replace lagcomprate = lagcomprate*scale

gen stategender = statecode
replace stategender = statecode + 100 if female == 1
 
 *******************************************************************************
 *******************************************************************************
 *Hybrid model recodes
 *******************************************************************************
 *******************************************************************************
 
 *allison conditional model
 *http://statisticalhorizons.com/fe-nbreg
 
 *individual specific means
 egen mlagcomp = mean(lagcomprate), by(statecode)
 egen mcap = mean(cap), by(statecode)
 egen mlagmp = mean(lagmprate), by(statecode)
 egen mpop = mean(pop), by(statecode)
 
 *time-varying deviations from means
 gen dlagcomp = lagcomprate - mlagcomp
 gen dcap = cap - mcap
 gen dlagmp = lagmp - mlagmp
 gen dpop = pop - mpop
 
 *******************************************************************************
 *******************************************************************************
 *Difference Model recodes
 *******************************************************************************
 *******************************************************************************
 tsset stategender year
 
 gen dmp = d.lagmprate

*create percentile cuts for lagmp
centile(dmp), centile(50 75 90 95)
*egen dmp_high = cut(dmp), at(-100,0,3,8,13,40) label
*cut based on analyisis
gen dmp90 = 0
	replace dmp90=1 if dmp>.05 
*centile(lagmp), centile(50 75 90 95)
*egen lagmp_high = cut(lagmp), at (15,35.75,79.7,133.35) label
 
egen mdmp = mean(dmp), by(statecode)
egen mdmp90 = mean(dmp90), by(statecode)
gen ddmp = dmp - mdmp
gen ddmp90 = dmp90-mdmp90
 
 
 label variable mlagcomp "Rate of Deaths from Complications (Between)"
 label variable dlagcomp "Differnce in Rate of Deaths from Complicaitons (Within)"

 label variable mlagmp "Rate of Paid Claims for Wrongful Death (Between)"
 label variable dlagmp "Difference in Rate of Paid Claims for Wrongful Death (Within)"

 label variable mdmp90 "Proportion of years Experiencing Spikes in Rates of Paid Claims (Between)"
 
 eststo clear
 
  xtset statecode
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Baseline malpractice claims
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

eststo: xi: xtreg mprate female mcap dcap i.year, re
estat ic 
 
*fe
xtreg mprate cap i.year, fe 
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 1: lower patient safety (large compdeaths) are associated with increased claims 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 
 eststo: xi: xtreg mprate mlagcomp dlagcomp female mcap dcap i.year, re
	*estimates save h1
	
estat ic 

*fe
xtreg mprate lagcomprate cap i.year, fe

 ****************************
 *export table 1
 ****************************
 
 esttab using "H:/projects/malpractice/output/hypothesis1.rtf", replace

 ****************************
 *marginal effects
 ****************************

*estpost margins,at(mlagcomp=(25(25)500)) atmeans expression(exp(predict(xb))) 
*  putexcel A1=matrix(e(table), names) ///
*using "H:/projects/malpractice/output/m1_mlagcomp_margins.xls", replace

* quietly: xtnbreg freq mpop mlagcomp dpop dlagcomp female mcap dcap i.year, re 
* quietly: margins,at(mlagcomp=(25(25)500)) atmeans expression(exp(predict(xb)))
* marginsplot, xlabel(25(50)500) recast(line) recastci(rarea) ytitle(Predicted No. of Paid Claims) 
 
 *for some bullshit reason estposting the estimates clears the regression estimates
 *save and restore don't work for some reason
 *quietly: xtnbreg freq mlagcomp dlagcomp female mcap dcap i.year, re 
 *quietly: margins,at(dlagcomp=(-200(25)200)) atmeans expression(exp(predict(xb)))
    *putexcel A1=matrix(e(table), names) ///
*using "H:/projects/malpractice/output/m1_dlagcomp_margins.xls", replace
 *marginsplot, xlabel(-200(25)200) recast(line) recastci(rarea) ytitle(Predicted No. of Paid Claims) 

 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Baseline complication deaths
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

 eststo clear
 eststo: xi: xtreg comprate female mcap dcap i.year, re
 
 estat ic
 
 *fe
 xtreg comprate cap i.year, fe
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 2: increases in medmal claims are associated with deaths due to complications 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

 eststo: xi: xtreg comprate mlagmp dlagmp female mcap dcap i.year, re

 estat ic
 
 *fe
 xtreg comprate lagmprate cap i.year, fe
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 3: spike -- first difference models same as H2
*http://www.statalist.org/forums/forum/general-stata-discussion/general/193879-first-difference-regression
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

 eststo: xi: xtreg comprate female mcap dcap mlagmp mdmp90 dlagmp ddmp90 i.year, re
estat ic 
 
 esttab using "H:/projects/malpractice/output/hypothesis2-3.rtf", replace
 
 *fe
 xtreg comprate cap lagmp dmp90, fe
 
 ****************************
 *marginal effects
 ****************************
 
 *h2
 
quietly: xtnbreg compdeaths mlagmp dlagmp female mpop mcap dpop dcap i.year, re
 quietly: margins, at(mlagmp=(0(20)200)) atmeans expression(exp(predict(xb))) 
 marginsplot, xlabel(0(20)200) recast(line) recastci(rarea) ytitle(Predicted No. Deaths due to Med. Complications) 
 
margins, at(dlagmp=(-60(20)120)) atmeans expression(exp(predict(xb))) 
 quietly: marginsplot, xlabel(-60(20)120) recast(line) recastci(rarea) ytitle(Predicted No. Deaths due to Med. Complications) 
 

 *h3
 quietly: xtnbreg compdeaths female mpop mcap dpop dcap mlagmp mdmp90 dlagmp ddmp90 i.year, re
margins, at(mdmp90=(0(.166666).5)) atmeans expression(exp(predict(xb))) 
 marginsplot, xlabel(0(.166666).5) recast(line) recastci(rarea) ytitle(Predicted No. Deaths due to Med. Complications) 

 
 
