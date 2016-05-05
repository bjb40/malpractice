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

The literature sumamrized in "Preliminary research on front end" (errors_lit) identifies a cross-causal relationship between medical malpractice claims and medical care. In one direction, good medical care is predicted to decrease malpractice claims (these are supported by patient safety studies). In the other direction, malpractice claims (or the threat of malpractice)is supposed to increase the practice of defensive medicine (or increase deaths related to bad medical care). 

One other possible effect is a spurious effect based on changing perceptions of malpractice (here think of Noymer's influenza/pneumonia cases for changes in cause-of-death coding when there are outbreaks). The argument here goes like so: there is a spike in malpractice filings at the time of tort reform (see Mississippi claims from state bank), this spike sensitizes physicians to issues of malpractice, and this sensitization makes them less inclined to code "misadventures". In this case, tort reform should lead to a short-term spike in settlements (possibly--depends on how the glut is taken care of), and a short term drop in complication causes-of-death. In any case, it can use a cross-lag design as well.

##Data Design

It's fairly easy to identify deaths from complications from CDC wonder (and use relative rates). It is more difficult to identify the denominator for wrongful death malpractice payments. This is because the NPDB identifies the date of the malpractice action and the date of the payment, but not the date of death. The median lag is 4 years with a 95% interval between 1 and 10 years of lag. The lag is known, so this is an interval censored problem, and the reates (or relative rates) can be imputed (perhaps building a multiple imputation dataset). 

##Model and Analytic Strategy

```I can follow some sort of ALT strategy (or the strategy from the applied statistics journal used in mh_isolation)```
