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
 > 0, if f(PC,t) > f(v)
\end{cases}
$$

**Data Structure for H3**

The structure is the same as H2, but I need to include an interaction term for a spike in malpractice claims; it is possible to do this, potentially, by just including a first-difference model of analysis.

*More Sophisticated Joint Models:*

```I can follow some sort of ALT strategy (or the strategy from the applied statistics journal used in mh_isolation)```
