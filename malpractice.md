---
author: Bryce Bartlett
title: "Coevolution of Medical Malpractice Claims and Causes of Death Over Time"
csl: ./citations/law-and-society.csl
bibliography: ./citations/malpractice.bib
date: 7/10/2016
---

#Abstract



#Introduction

A number of studies have identified trends and changes in medical malpractice claims over time, including the waxing and waning of claims (sometimes called crises) and responses to these changes, primarily through tort reform [@paik_receding_2013; @baker_medical_2005]. The thrust for most of this literature and analysis is to distinguish malpractice claims that result from misconduct and error, and malpractice claims that are merely spurious [@baker_medical_2005]. Separating these claims is both a theoretical and empirical project. The fundamental issue is identifying the inter-relationship between malpractice claims and medical care. The particular pathways from medical care to malpractice claims focus on quality of care. The suggested include assertions that better medical care leads to more claims, and conversely that worse medical care leads to fewer claims [@paik_receding_2013]. 

Importantly, there are also assertions that the tenor and quality of malpractice claims impacts the quality of patient care, commonly under the moniker of "defensive medicine." Literature in this vein ordinarily focuses on physician practice, and increases in health care costs from unnecessary tests and procedures```citations```. However, an even more troubling implication for "defensive medicine" is that an increase in unnecessary medical care should also lead to poorer patient health. Any health procedure has an inherent risk, and over-treatment should leads to larger numbers of detrimental outcomes. All medical care comes at a cost, and the suboptimal care suggested by defensive medicine should be observable in population health, and not solely physician practice and health care costs. 

This study focuses on these three simple predictions: (1) that better patient outcomes lead to fewer malpractice claims, (2) increases in malpractice claims lead to poorer reported patient outcomes, and (3) larger spikes in malpractice claims have more pronounced effects on patient outcomes. I address these fundamental expections from a population health and social epidemeological perspective, slicing nationwide mortality statistics by states, and controlling for state characteristics on tort reform and medical malpractice claims. 

Consistent with its focus on population health, this study uses the multiple morbidity file collected from each state and aggregated by the National Vital Statistics System under the auspices of the Centers for Disease Control (NVSS) for ```date-date```. Using this file, I identify trends for causes of death related to complications or "misadventures" of medical care. While this measure has not been used for quality of care in prior work on medical malpractice, it is similar to the adverse events measures used in prior studies focused on a small subsection of hospitals ```citations```. Expanding to this broader measure allows for a nationwide analysis instead of a few states, or a few hospitals within states. I combine this data with information on malpractice claims against physicians from the National Practitioner Databank (NPDB). As discussed more fully below, to maintain the comparability of the claims and the mortality dataset, only serious malpractice claims, *i.e.* those alleging death are utilized. 

These two datasets provide for parallel time series across states. Employing ```method```, I find (1) , (2), and (3) .

#Background

Fundamentally, law and policy surrounding medical malpractice relates directly to public health and safety. Medical practice is subject to both licensure and standard-of-care rules and regulations. These are intended to protect the public and protect the health and safety of the populace. In fact, some of the most basic medical practices, like washing hands, have made profound differences in patient outcomes, including reductions in mortality rates ```citation```. In addition, as with all tort law, medical malpractice is designed to take care of individuals wronged by the failure of the medical system to meet reasonably expected standards of care ```citation```. Of course, these ideal designs are subject to the imperfections related to laws and agency externalities. One of the more concretely defined arguments against law and policy, is a fear that too aggressively protection or reimbursement leads to "defensive medicine" ```citations```. In this instance, instead of medical procedures and practice focused on patient safety and clinical considerations, physician decisions are driven by their desire to avoid litigation and malpractice risk.

It is a well-known fact from social science that the breadth, importance, and jurisdiction of medical care and medical services have increased exponentially over the past century, a process known as "medicalization" ```medicalization cites```. At the same time, the various states of the United States have struggled with the appropriate level and manner of medical malpractice, introducing a great deal of variability in malpractice treatment. Given the breadth and changes across medical care and malpractice context, most studies focus on some small piece of the puzzle, often slicing by geographical closeness or medical practice, such as ___ ```examples and citations```.

Similarly, this study limits analysis of malpractice claims to those resulting in death. This limitation provides to important benefits. First, cause-of-death statistics reported by each state have been aggregated and reported by the Center for Disease Control for decades. Combining this administrative data with the National Practitioner Data Bank provide the opportunity to investigate the cross-influence for causes of death and malpractice claims. Second, the seriousness of the allegation--death--diminishes the the possibility that claims are foregone, because they are not worth litigating. In this way, this study can provide a nationwide representative analysis of the co-relation between malpractice claims and public health (as measured by mortality), but minimizes difficulties in making cross-state comparaisons. 

##Public Heatlh, Mortality, and Malpractice Rates

The oldest and simplest measures of public health involve mortality statistics. Collecting cause-of-death statistics is perhaps the longest and most expensive data collection projects to date. It is a continuous, population-level project: most deaths require a formal death certificate executed by a medical professional. This certificate identifies the medical reason for death, such as, suicide, vehicular accident, heart attack, or influenza. More specifically, the cause-of-death information in is the single, underlying cause representing "the disease or injury that initiated the train of events leading directly to death" (World Health Organization, 2011, p. 31).

The ICD contains a number of causes for "complications," which include adverse reactions and "misadventures." In at least one case, these are referred to as insufficient for mens rea, like an accident, but perhaps does not preclude negligence [@_state_1995, p. 862; *but see* @_mcilraith_2001]. One expert physician was quoted using "misadventure" to be synonymous with "accident" [@_pavey_2010]. Ultimately, these include accidents or complications directly related to care, but do not necessarily include an "error" in the medical care or imply preventability.

##Law and the Medical Field

A few years ago, the Journal of Empirical Legal Studies published some (primarily) descriptive stats on changes in medmal claims [@paik_receding_2013]. The article looked at rates (usually relative to physicians), and noted general declines in payouts for medical malpractice. Explanations for changes in payouts/claims: (1) tort reform, (2) health care quality, (3) Rising litigation costs, (4) more hospital-employed physicians (hospitals pay instead of physicians, declining the amount of payments), (5) NPDB and settlement, (6) changes in personal injury claims in general.

```
I am interested in two concepts: improvements (or lack thereof) in health care quality and in defensive medicine. I can gloss these with medicalization concepts from the second year paper and add an aging component without too much trouble (initial thoughts are in the note entitled "Preliminary analysis and data" (prelim_code...)). This memo provides an overview of the legal research on these terms, primarily through the jumping point outlined in this JELS article [@paik_receding_2013].
```

##Health Care Quality

Medical care does produce errors, but most errors do not lead to legal claims [@baker_medical_2005]. However, most legal claims do involve errors (though 37% did not in this study) [@studdert_claims_2006]. Using a sample of claims from California (using county fixed effects), researchers associated with RAND have identified a strong negative correlation between increased patient safety indicators (PSI) (as reported by hospital adverse events) and decreased malpractice claims [@greenberg_is_2010]. A similar data strategy is employed by Black and Zabinski in Texas and Florida [@black_association_2015],and they make similar findings using hospital and county fixed effects regarding claim rates (this is a working paper on SSRN, not sure if it is published, yet). This study also makes adjustments for truncated data and medical malpractice (simple mean regression imputation--not multiple imputation, though). These provide a perfect hook for statewide analysis of paid claims (relative to some sensible lag in causes of death due to "complications" or physician error).


**Hypothesis 1:** Increasing rates in complications causes-of-death 

suboptimal care -> increasing malpractice claims


Error rates are high with respect to medicine and hospitals [@classen_global_2011; @landrigan_temporal_2010; @farmer_tension_2013]. With respect to causes of death, Makary and Daniel [@makary_medical_2016] claim that medical error is the third leading cause of death in the U.S. They provide an overview of medical error, which basically sums to not following the standard of care, error of omission or commission, error of execution, or error in planning. They note that there is no specific to identify cause of death relating to error under the ICD, and they use a meta-analysis from studies to extrapolate the rate of errors causing deaths (but these are like 4 studies on half  dozen hospitals...). Notably, some believe that these are mostly preventable, and often structural because of the complexity of modern care [leape_preventing_1993]. As with the citation above, these are focused on adverse events in hospitals.

##Defensive Medicine

Two major definitions of defensive medicine and the key original studies are outlined in an article which seeks to identify medical costs related to medical malpractice litigation [@mello_national_2010].





H2: malpractice claims -> suboptimal care (i.e. more dangerous) medical care

H3: unusual spikes in malpractice claims -> drop in the measure of care

##Cause of Death

medical malpractice in purely in legal studies. Or studies of medical errors for patient safety.

Why COD is a good place to study:  (1) 1/3 of all malpractice payments are COD. Wrongful death is also highest payouts (confirm), and minimizes the barriers of small-scale claims. (2) practically, it includes the best large-scale data. Distinguish from state-level tests of hospital safety.

#Data and Methods



#Results



#Discussion and Conclusion

