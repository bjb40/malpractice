---
author: Bryce Bartlett
date: 5/4/2016
title: "Preliminary analysis and data."
tags: malpractice, law, demography, mortality
csl: ./citations/bluebook19.csl
bibliography: ./citations/malpractice.bib
---

#Overview

Looking to analyze data by extending models in mortality project (2d year paper) to malpractice issues.

#Summary

##Malpractice Data

I downloaded data from the National Practitioner Databank. This includes both professional actions and med mal claims. Med mal claims include information about the severity of the claim, including identification of those claims leading to death beginning in 2004. At this time, it also includes information on patient gender and patient age, but not race. 27% to 29% of the claims for each year are malpractice claims.

There are a number of "year" variables, including the year of the payment/report ("origyear") and the year of the claims origin ("malyear1","malyear2"). I assumed that all adverse events occurred in the year of the most recent "malyear", (though this is not necessarily the case, the death technically occurs between the malpractice allegation and the date of the claim). The median lag between this value and origin year is 4 years, with a minimum of 1 and an almost infinite maximum (not sure why the max is unbounded). Third quartile is 5 years.

These values are relatively small leading to a lot of structural zeros (especially where age is included).

##Death Data

I downloaded death stats from CDC wonder and included deaths for the NCHS 113 code for "complications" on the idea that this provides a hook for "defensive" medicine or the prevalence of errors. I merged these numbers into a cross-tab of the NPDB data by year and gender (treating year as the max of the malyear1,malyear2 value).

##Some Preliminary Models

Included in the model were the outcomes outlined above stratified by state and gender. In addition, state-level tort reform characteristics were added (solely based on damage caps), which were taken directly from the table in a recent survey on malpractice models [@paik_receding_2013].

Limiting year from 2003 to 2008 (because of the truncation issue on the lag) provides a number of findings. Logged relative rates in a cross-classified context by state and year (like the 2d year paper model) don't estimate. Disaggregating to "Frequency" of deaths gets a lot of significance (but this may be a population effect, because that isn't controlled out). Fixed effect models across cap states don't show a lot(however the time frame is a little late, and a data imputation strategy to include 1999-2002 would give a lot more leverage to the "nocap" years). In contrast FGLS models show stationarity in an AR1 process, and do show some differences (at least with states that switch caps... but that makes sense if there is a discontinuity...).

#Conclusion

There is a lot of moving around in preliminary models with respect to significance of cap or no cap, but a lot of this is "close." This is sufficient for a paper, though. The next step is to look into lit review to the "errors" and defensive medicine literature to see if I can make a question relating tort reform to errors in litigation.

One possible question: does the tort reform affect reported all-cause "complications" across states?

**References**

