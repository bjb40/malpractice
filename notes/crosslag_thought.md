---
author: Bryce Bartlett
date: 5/4/2016
title: "Cross-lag concept."
tags: malpractice, law, demography, SEM
csl: ./citations/bluebook19.csl
bibliography: ./citations/malpractice.bib
---

#Overview#

This is one way to include an interesting modeling/statistical strategy. The basic concept is to regress both paid malpractice claims and deaths resulting from complications on each other.

#Summary


##Literature Outline

The literature summarized in "Preliminary research on front end" (errors_lit) identifies a cross-causal relationship between medical malpractice claims and medical care. In one direction, good medical care is predicted to decrease malpractice claims (these are supported by patient safety studies). In the other direction, malpractice claims (or the threat of malpractice)is supposed to increase the practice of defensive medicine (or increase deaths related to bad medical care). 

One other possible effect is a spurious effect based on changing perceptions of malpractice (here think of Noymer's influenza/pneumonia cases for changes in cause-of-death coding when there are outbreaks). The argument here goes like so: there is a spike in malpractice filings at the time of tort reform (see Mississippi claims from state bank), this spike sensitizes physicians to issues of malpractice, and this sensitization makes them less inclined to code "misadventures". In this case, tort reform should lead to a short-term spike in settlements (possibly--depends on how the glut is taken care of), and a short term drop in complication causes-of-death. In any case, it can use a cross-lag design as well.

##Data Design

It's fairly easy to identify deaths from complications from CDC wonder (and use relative rates). It is more difficult to identify the denominator for wrongful death malpractice payments. This is because the NPDB identifies the date of the malpractice action and the date of the payment, but not the date of death. The median lag is 4 years with a 95% interval between 1 and 10 years of lag. The lag is known, so this is an interval censored problem, and the rates (or relative rates) can be imputed (perhaps building a multiple imputation dataset). More specific coding is included under analytic strategy below.

##Model and Analytic Strategy

Controls ($x$) for all models should include adjustments for alternative explanations, including tort reform, relative number of hospital-employed physicians, and changes in broader personal injury claims (if possible), and perhaps changing cost of medical care (as proxy for defensive medicine).

I will operationalize $PC$ from the NPDB reported claims. $PS$ will be operationalized with some specification related to the number of "complication" deaths (from NCHS 113 claims). Why use this? It is a relative measure of "unexpected" deaths that occur from medical care, even if it is not exclusive and does not include errors only. But, it is universally applicable, and cause of death statistics are widely available and have been collected for a long time, and in the same way across all states. While I lose some precision to noise, it maximizes generalizability.

*Simple Model:*

H1: increases in the patient safety ($PS$) leads to decreases in paid medmal claims ($PC$) between time periods ($t$) -- can make claim that *perception* of patient safety may be more important than actual patient safety.

$$
PC_t = \rho PS_{t-1} + \beta x
$$


*Logged relative ratio specification:*

Note that this is actually quite different from the mortality change dataset because it relates the rates from the same equation.

$$
\frac{ln(PC_t)}{ln(PS_{t-1})} = ln(\beta x)
$$

**Data Structure for H1**

Because paid claims in a particular year (NPDB 'origyear') occur from a number of different years, the "lag" has to take into account multiple years prior to the date of the paid claim. Assuming that the death occurred at the last time of the last malpractice claim in the file (alternatively this is a pretty straightforward interval-censored data problem for survival), the distribution is as follows:

![../draft_img~/lag_hist.png](../draft_img~/lag_hist.png)

The actual proportions for the first six years are outlined below (need to confirm whether this includes too many years and thus is too heavily weighted to the earlier years than would otherwise be the case...):

|Lag (years)|Proportion|Cumulative Proportion|
|:--|---:|---:|
|0|0.014|0.014|
|1|0.067|0.081|
|2|0.138|0.219|
|3|0.186|0.405|
|4|0.181|0.586|
|5|0.140|0.726|
|6|0.094|0.820|

With this, a balanced central distribution is lag years 2-5, which includes 64% (0.726-0.081) of the observations. So, a solid initial strategy is to take the mean rate between years 2 and 5 (or 3 and 4) as the lagged value of $PS$ which should influence the observation date of $PC$. More sophisticated methods and tests are possible, but I will begin with this. Because there is no bottom truncation on this, I can take 2004 to 2009 or 2010 as the claim series (will need a sensible imputation strategy for longer periods). I can code and call these "PSlag" variables. (Longer series are possible if I include all paid claims without regard to it resulting in a wrongful death, but that weakens my claim for new and special analysis...).

**Preliminary Results for H1**

Table of results (using Stata). FGLS is linear (AR1 with heterskeastic effects within panels); fixed effects are negative binomial (poisson provides substantivley similar results).

Linear FGLS

|      | Model 1 | Model 2  | 
|:-----|---------------:|---------------:|
|female|             -1.453|          -0.195|   
|      |            (-1.16)|         (-0.37)|   
|oldcap|             -7.560^\*\*\*^|       -1.359^\*^|  
|      |            (-6.01)|         (-2.45)|   
|switchcap|           23.21^\*\*\*^|       -8.884^\*\*\*^|
|         |          (9.88)|         (-6.72)|   
|year      |         -1.188^\*\*\*^|       -0.192 |  
|         |         (-5.62)|         (-1.67)|   
|$\overline{PS}_{\{t-2,...t-5\}}$| |      0.104^\*\*\*^|
|         |                 |        (31.46)|   
|Constant |              2407.4^\*\*\*^|     383.8|   
|         |          (5.69)|          (1.66)|   
|N        |             612|             612|  


Negative Binomial Fixed Effects (with year fixed effects)

~~~~

--------------------------------------------
                      (1)             (2)   
                     freq            freq   
--------------------------------------------
freq                                        
cap                -0.286***       -0.277***
                  (-4.31)         (-4.31)   

2003.year               0               0   
                      (.)             (.)   

2004.year          -0.121***       -0.121***
                  (-3.34)         (-3.39)   

2005.year          -0.175***       -0.177***
                  (-4.68)         (-4.80)   

2006.year          -0.218***       -0.207***
                  (-5.66)         (-5.42)   

2007.year          -0.236***       -0.206***
                  (-6.11)         (-5.21)   

2008.year          -0.305***       -0.253***
                  (-7.76)         (-5.90)   

lagcompdea~s                     0.000684** 
                                   (2.91)   

_cons               4.141***        3.764***
                  (22.22)         (16.58)   
--------------------------------------------
N                     612             612   
--------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001

~~~~~~~~~~~~~~~~~~~

Code (stata):

~~~~{.numberLines .stata}

drop if (year<2003 | year>2008 | statecode == 0)

gen stategender = statecode
replace stategender = statecode + 100 if female == 1

xtset stategender year

 *this is the fgls n woolrdge p. 421 / inefficient
 
eststo: xtgls freq female oldcap switchcap year, panels(hetero) corr(psar1)
eststo: xtgls freq lagcompdeaths female oldcap switchcap year, panels(hetero) corr(psar1)
  esttab

eststo clear
eststo: xtnbreg freq cap female i.year, fe
eststo: xtnbreg freq lagcompdeaths cap female i.year, fe  
  esttab

~~~~~~~~~~~~~~~


H2: increases in medmal claims ($PC$) leads to increases in defensive medicine, and suboptimal care, or decreases in patient safety ($PS$) (literature usually focuses on expense of medical care; could respecify $PS$ to expenses per complication deaths -- but the expense issue goes both ways; whereas, the over-treatment/under-treatment combination will always lead to less patient safety; just need support for the claim that all medical procedures include inherent risk). 

$$
PS_t = \rho PC_{t-1} + \beta x
$$

*Logged relative ratio specification:*

$$
\frac{ln(PS_t)}{ln(PC_{t-1})} = ln(\beta x)
$$

**Data structure for H2**

Unlike the data structure above, there is no lag. Instead, doctors can start changing their work immediatley, as such, this is a basic autoregressive problem. But, I can smooth (and reduce structural zeros) by taking a mean of the prior two years---this will also allow for age-structure analysis. The outcomes are staggered more closely for this problem, and begin 2005 or 2006; ending 2014 (or last year there is data).

**Preliminary Results**

~~~~
Linear FGLS Results
--------------------------------------------
                      (1)             (2)   
               compdeaths      compdeaths   
--------------------------------------------
female             -25.72**        -27.72***
                  (-3.12)         (-4.75)   

cap                -21.62**         20.79***
                  (-2.84)          (3.77)   

switchcap           275.0***        205.0***
                  (25.96)         (14.99)   

year               -5.211***        2.905** 
                  (-4.95)          (3.21)   

lagmp                               3.557***
                                  (28.95)   

_cons             10695.0***      -5690.0** 
                   (5.07)         (-3.13)   
--------------------------------------------
N                     612             612   
--------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001

~~~~~~~~~~~~~~

Fixed Effect (Negative Binomial) results

~~~~~~~~~~~

--------------------------------------------
                      (1)             (2)   
               compdeaths      compdeaths   
--------------------------------------------
compdeaths                                  
cap               -0.0323         -0.0197   
                  (-1.06)         (-0.62)   

female            -0.0844***      -0.0837***
                  (-9.14)         (-9.07)   

2003.year               0               0   
                      (.)             (.)   

2004.year         -0.0305         -0.0298   
                  (-1.96)         (-1.92)   

2005.year         -0.0673***      -0.0641***
                  (-4.27)         (-4.01)   

2006.year          -0.114***       -0.109***
                  (-7.03)         (-6.60)   

2007.year          -0.117***       -0.111***
                  (-7.22)         (-6.64)   

2008.year          -0.102***      -0.0969***
                  (-6.35)         (-5.80)   

lagmp                            0.000512   
                                   (1.28)   

_cons               5.054***        5.025***
                  (47.91)         (46.16)   
--------------------------------------------
N                     612             612   
--------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001

~~~~~~~~~~~~~~~~~~~


H3: Spikes in medmal claims that are recognized by physicians (like with the implementation or loss of tort reform), lead to a decrease in comp deaths as a social construction deal (this is somewhat equivalent to H2, but relies is conditional on a visibility function or level ($f(v)$); could include news coverage on medmal for the state at issue...).

Somewhat identical to H3, but includes an interaction between tort reform years and compdeaths (as exogenous proxy). Additionally, can take some more complicated specification related to malpractice visibility ($f(v)$), like this:

$$
PS_t = \rho PC_{t-1} + \beta x
$$

Where,

$$
\rho
\begin{cases}	
 = 0, if f(PC,t) < f(v) \\
 \ne 0, if f(PC,t) > f(v)
\end{cases}
$$

**Data Structure for H3**

The structure is the same as H2, but I need to include an interaction term for a spike in malpractice claims; it is possible to do this, potentially, by just including a first-difference model of analysis.

~~~~~~~~~~~~~~~~~~



----------------------------------------------------------------------------
                      (1)             (2)             (3)             (4)   
             D.compdeaths    D.compdeaths    D.compdeaths    D.compdeaths   
----------------------------------------------------------------------------
2004.year               0               0               0               0   
                      (.)             (.)             (.)             (.)   

2005.year           0.373           0.805           0.373           0.866   
                   (0.07)          (0.14)          (0.07)          (0.15)   

2006.year           3.863           3.867           3.712           3.633   
                   (0.69)          (0.69)          (0.66)          (0.65)   

2007.year           12.94*          12.75*          13.09*          12.95*  
                   (2.31)          (2.27)          (2.33)          (2.31)   

2008.year           17.44**         17.00**         17.59**         17.17** 
                   (3.11)          (3.02)          (3.13)          (3.05)   

D.lagmp                             0.200                           0.228   
                                   (1.24)                          (1.38)   

D.cap                                               7.710           11.95   
                                                   (0.54)          (0.81)   

_cons              -14.38***       -13.90***       -14.53***       -14.07***
                  (-3.62)         (-3.49)         (-3.65)         (-3.52)   
----------------------------------------------------------------------------
N                     510             510             510             510   
----------------------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*More Sophisticated Joint Models:*

```I can follow some sort of ALT strategy (or the strategy from the applied statistics journal used in mh_isolation)```

--------------------------------------------
                      (1)             (2)   
             D.compdeaths    D.compdeaths   
--------------------------------------------
D.cap               7.710           17.23   
                   (0.54)          (1.18)   

2004.year               0               0   
                      (.)             (.)   

2005.year           0.373           0.906   
                   (0.07)          (0.16)   

2006.year           3.712           3.909   
                   (0.66)          (0.70)   

2007.year           13.09*          12.70*  
                   (2.33)          (2.30)   

2008.year           17.59**         16.75** 
                   (3.13)          (3.03)   

dmp                                 0.760***
                                   (3.32)   

0.dmp_high~p                            0   
                                      (.)   

1.dmp_high~p                       -6.502   
                                  (-1.77)   

2.dmp_high~p                        0.109   
                                   (0.09)   

3.dmp_high~p                       -3.294***
                                  (-3.58)   

4.dmp_high~p                       -1.679***
                                  (-3.37)   

_cons              -14.53***       -8.373   
                  (-3.65)         (-1.85)   
--------------------------------------------
N                     510             510   
--------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001

. 
end of do-file

. tab dmp_high

   dmp_high |      Freq.     Percent        Cum.
------------+-----------------------------------
      -100- |        258       50.59       50.59
         0- |        111       21.76       72.35
         3- |         87       17.06       89.41
         8- |         27        5.29       94.71
        13- |         27        5.29      100.00
------------+-----------------------------------
      Total |        510      100.00

. do "C:\Users\bjb40\AppData\Local\Temp\STD00000000.tmp"

. centile(dmp), centile(50 75 90 95)

                                                       -- Binom. Interp. --
    Variable |       Obs  Percentile    Centile        [95% Conf. Interval]
-------------+-------------------------------------------------------------
         dmp |       510         50          -1              -1           0
             |                   75           3               2           4
             |                   90           8               6          10
             |                   95          13              10    15.44566

. 
end of do-file

