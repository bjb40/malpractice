*dev Stata 14
*models for draft submission to CELS
*Bryce Bartlett

clear

import delimited ///
using H:/projects/malpractice/output/private~/analysis_dat.csv, ///
numericcols(_all)

drop if (year<2003 | year>2008 | statecode == 0)

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
 egen mlagcomp = mean(lagcompdeaths), by(statecode)
 egen mcap = mean(cap), by(statecode)
 egen mlagmp = mean(lagmp), by(statecode)
 
 *time-varying deviations from means
 gen dlagcomp = lagcompdeaths - mlagcomp
 gen dcap = cap - mcap
 gen dlagmp = lagmp - mlagmp
 
 *******************************************************************************
 *******************************************************************************
 *Difference Model recodes
 *******************************************************************************
 *******************************************************************************
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
 
egen mdmp = mean(dmp), by(statecode)
egen mdmp90 = mean(dmp90), by(statecode)
gen ddmp = dmp - mdmp
gen ddmp90 = dmp90-mdmp90
 
 
 label variable mlagcomp "Deaths from Complications (Between)"
 label variable dlagcomp "Differnce in Deaths from Complications (Within)"

 label variable mlagmp "Paid Claims for Wrongful Death (Between)"
 label variable dlagmp "Difference in Paid Claims for Wrongful Death (Within)"

 label variable mdmp90 "Proportion of years Experiencing Spikes in Paid Claims (Between)"
 
 eststo clear
 
  xtset statecode
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Baseline malpractice claims
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

eststo: xi: xtnbreg freq female mcap dcap i.year, re

estat ic 
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 1: lower patient safety (large compdeaths) are associated with increased claims 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 
 eststo: xi: xtnbreg freq mlagcomp dlagcomp female mcap dcap i.year, re
	*estimates save h1
	
estat ic 

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

 quietly: xtnbreg freq mlagcomp dlagcomp female mcap dcap i.year, re 
 quietly: margins,at(mlagcomp=(25(25)500)) atmeans expression(exp(predict(xb)))
 marginsplot, xlabel(25(50)500) recast(line) recastci(rarea) ytitle(Predicted No. of Paid Claims) 
 
 *for some bullshit reason estposting the estimates clears the regression estimates
 *save and restore don't work for some reason
 *quietly: xtnbreg freq mlagcomp dlagcomp female mcap dcap i.year, re 
 quietly: margins,at(dlagcomp=(-200(25)200)) atmeans expression(exp(predict(xb)))
    *putexcel A1=matrix(e(table), names) ///
*using "H:/projects/malpractice/output/m1_dlagcomp_margins.xls", replace
 marginsplot, xlabel(-200(25)200) recast(line) recastci(rarea) ytitle(Predicted No. of Paid Claims) 

 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Baseline complication deaths
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

 eststo clear
 eststo: xi: xtnbreg compdeaths female mcap dcap i.year, re
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 2: increases in medmal claims are associated with deaths due to complications 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

 eststo: xi: xtnbreg compdeaths mlagmp dlagmp female mcap dcap i.year, re
 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*Hypothesis 3: spike -- first difference models same as H2
*http://www.statalist.org/forums/forum/general-stata-discussion/general/193879-first-difference-regression
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 

 eststo: xi: xtnbreg compdeaths female mcap dcap mlagmp mdmp90 dlagmp ddmp90 i.year, re
 
 esttab using "H:/projects/malpractice/output/hypothesis2-3.rtf", replace
 
 ****************************
 *marginal effects
 ****************************
 
 *h2
 
quietly: xtnbreg compdeaths mlagmp dlagmp female mcap dcap i.year, re
 quietly: margins, at(mlagmp=(0(20)200)) atmeans expression(exp(predict(xb))) 
 marginsplot, xlabel(0(20)200) recast(line) recastci(rarea) ytitle(Predicted No. Deaths due to Med. Complications) 
 
margins, at(dlagmp=(-60(20)120)) atmeans expression(exp(predict(xb))) 
 quietly: marginsplot, xlabel(-60(20)120) recast(line) recastci(rarea) ytitle(Predicted No. Deaths due to Med. Complications) 
 

 *h3
 quietly: xtnbreg compdeaths female mcap dcap mlagmp mdmp90 dlagmp ddmp90 i.year, re
 quietly: margins, at(mdmp90=(0(.166666).5)) atmeans expression(exp(predict(xb))) 
 marginsplot, xlabel(0(.166666).5) recast(line) recastci(rarea) ytitle(Predicted No. Deaths due to Med. Complications) 

 
 