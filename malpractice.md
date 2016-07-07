---
author: Bryce Bartlett
title: "Coevolution of Medical Malpractice Claims and Causes of Death Over Time"
csl: ./citations/law-and-society.csl
bibliography: ./citations/malpractice.bib
date: 7/10/2016
---

#Abstract



#Introduction

A number of studies have identified trends and changes in medical malpractice claims over time, including the waxing and waning of claims (sometimes called crises) and responses to these changes, primarily through tort reform [@paik_receding_2013; @baker_medical_2005]. The thrust for most of this literature and analysis is to distinguish malpractice claims that result from misconduct and error, and malpractice claims that are merely spurious [@baker_medical_2005]. Separating these claims is both a theoretical and empirical project. The fundamental issue is identifying the inter-relationship between malpractice claims and medical care. The particular pathways from medical care to malpractice claims focus on quality of care. The suggested association is that better medical care leads to more claims, and conversely that worse medical care leads to fewer claims [@paik_receding_2013].

Importantly, there are also assertions that the tenor and quality of malpractice claims impacts the quality of patient care, commonly under the moniker of "defensive medicine." Literature in this vein ordinarily focuses on physician practice, and increases in health care costs from unnecessary tests and procedures```citations```. However, an even more troubling implication for "defensive medicine" is that an increase in unnecessary medical care should also lead to poorer patient health. Any health procedure has an inherent risk, and over-treatment should leads to larger numbers of detrimental outcomes. All medical care comes with inherent risks, and the suboptimal care suggested by defensive medicine should be observable in population health, and not solely physician practice and health care costs.

This study focuses on these three simple predictions: (1) that better patient outcomes lead to fewer malpractice claims, (2) increases in malpractice claims lead to poorer reported patient outcomes, and (3) larger spikes in malpractice claims have more pronounced effects on patient outcomes. I address these fundamental expections from a population health and social epidemeological perspective, slicing nationwide mortality statistics by states, and controlling for state characteristics on tort reform and medical malpractice claims.

Consistent with its focus on population health, this study uses the multiple morbidity file collected from each state and aggregated by the National Vital Statistics System under the auspices of the Centers for Disease Control (NVSS) for ```date-date```. Using this file, I identify trends for causes of death related to complications or "misadventures" of medical care. While this measure has not been used for quality of care in prior work on medical malpractice, it is similar to the adverse events measures used in prior studies focused on a small subsection of hospitals ```citations```. Expanding to this broader measure allows for a nationwide analysis instead of just a few states, or a few hospitals within states. I combine this data with information on malpractice claims against physicians from the National Practitioner Databank (NPDB). As discussed more fully below, to maintain the comparability of the claims and the mortality dataset, only serious malpractice claims, *i.e.* those alleging death are utilized.

These two datasets provide for parallel time series across states. Employing ```method```, I find (1) , (2), and (3) .

#Background

Fundamentally, law and policy surrounding medical malpractice relates directly to public health and safety. Medical practice is subject to both licensure and standard-of-care rules and regulations. These are intended to protect the public and protect the health and safety of the populace. In fact, some of the most basic medical practices, like washing hands, have made profound differences in patient outcomes, including reductions in mortality rates ```citation```. In addition, as with all tort law, medical malpractice is designed to take care of individuals wronged by the failure of the medical system to meet reasonably expected standards of care ```citation```. Of course, these ideal designs are subject to the imperfections related to laws and agency externalities. One of the more concretely defined arguments against law and policy, is a fear that too aggressively protection or reimbursement leads to "defensive medicine" ```citations```. In this instance, instead of medical procedures and practice focused on patient safety and clinical considerations, physician decisions are driven by their desire to avoid litigation and malpractice risk.

It is a well-known fact from social science that the breadth, importance, and jurisdiction of medical care and medical services have increased exponentially over the past century, a process known as "medicalization" ```medicalization cites```. At the same time, the various states of the United States have struggled with the appropriate level and manner of medical malpractice, introducing a great deal of variability in malpractice treatment. Given the breadth and changes across medical care and malpractice context, most studies focus on some small piece of the puzzle, often slicing by geographical closeness or medical practice, such as ___ ```examples and citations```.

Similarly, this study limits analysis of malpractice claims. In particular, this stody limits its analysis mortality and malpractice allegedly resulting in death. This limitation provides three important benefits. First, cause-of-death statistics reported by each state have been aggregated and reported by the Center for Disease Control for decades. Combining this administrative data with the National Practitioner Data Bank (NPDB) provide the opportunity to investigate the cross-influence for causes of death and malpractice claims. Second, the seriousness of the allegation--death--diminishes the the possibility that claims are foregone, because they are not worth litigating. In this way, this study can provide a nationwide representative analysis of the co-relation between malpractice claims and public health (as measured by mortality), but minimizes difficulties in making cross-state comparaisons. Third, and perhaps most importantly, the NPDB tracks only malpractice payaments; it does not provide a baseline of similar medical events which do not result in malpractice claims. Because death, and cause of death, are so carefully recorded by the NVSS, it is much easier to produce a series of state-wide aggregate baselines for such events.

##Public Heatlh and Mortality Due to Medical Care

Collecting cause-of-death statistics is perhaps the longest and most comprehensive public health data project ever. Some historians point to the origins of cause-of-death reporting to the institution of coroners in the Articles of Eyre in 1194 ```(Nemec, 1976, p. 15)``` while others prefer to anchor it to the creation of boards of health in 15th century Europe ```(Moriyama & Loy, 2011)```. These two origins express the dual nature of cause-of-death reporting in the contemporary United States. The former arose with coroners as agents of state surveillance over death, and continues today to assist the state in maintaining its monopoly of lethal violence ```(Foucault, 2003, p. 240)```, to collecting fines and taxes ```(Godwin, 2005)```, and demarcating the beginning or end of legal obligations and rights, like an inheritance or Social Security payments. The latter arose out of serious pandemics and now employs statisticians and public health professionals to understand and eliminate public health hazards ```(Moriyama & Loy, 2011)```. The basic categorization of death was dichotomous: deaths were either unnatural/suspicious, resulting directly from human intervention or natural, death from nonhuman means.

At the advent of germ theory, the classification of medical cause of death, nosology, became an expertise in its own right. The systems of classification and standardization of clinical objects have been an international project since the late 19th century under the expertise of nosology and the auspices of the World Health Organization (WHO) and its International Classification of Disease (ICD) system. The United States has used the International Classification of Disease (ICD) since 1900 ```(AM Hetzel, 1997)```, and has been at the forefront of initiatives in revising the ICD and  the automated coding of the ICD ```(Moriyama & Loy, 2011)```. The ICD system consists of a preset list of acceptable clinical diagnoses causing or contributing to death, and a set of decision rules for selecting the underlying cause of death from among clinical diagnoses presented on any death certificate. The list and the coding rules, if implemented, provide comparability of death statistics across geographical space and over time.

The ICD provides a comprehensive classification system, forking dramatically from the simple division between natural and unnatural causes to include detailed clinical descriptions. The most recent version of the ICD, ICD-10 became effective in the United States beginning 1999. And the nosological classifications are extremely detailed and comprehensive. ICD-10 contains over 8,000 separate and independent causes of death```citation--my stuff with footnote```. These causes of death include things like ```provide a comical and a misadventure example```. Analyzing causes of death categorized under the ICD usually utilizes a clinically significant aggregation classification. The most common aggregation is the 113 clinically significant causes of death prepared and published by Federal agency the National Center for Health Statistics ```cite```. Lists of these clinically significant aggregations are readily available and updated along with changes in the ICD. One of these clinically significant categories is "Complications of medical and surgical care" ````cite```.

```need a transition statement that sets up the dichotomy explained below```

One of the significant Part of the The ICD contains a number of causes (314) for "complications," which include adverse reactions and "misadventures." A comprehensive list of these cataloged in supplemental Table S-1. The exact relation of these sorts of causes of death to medical malpractice and the standard of care is somewhat complicated. These causes of death are not, strictly, related to medical errors or failures to follow the standard of care, but they *are* causes of death that are specifically related to medical care. In other words, these causes of death indicate that some medical intervention was a direct cause of death for the individual in question. Occasionally these sorts of causes of death have appeared in case law. Some deciding that such an indication is insufficient for mens rea to support a criminal conviction, although this does not preclude negligence [@_state_1995, p. 862; *but see* @_mcilraith_2001]. Some expert physicians have used these sorts of "misadventures" as synonymous with "accident" [@_pavey_2010]. Ultimately, these include accidents or complications directly related to care, but do may not necessarily include a legally actionable "error" in the medical care or imply preventability of the death. From this perspective, causes of death due to medical complications are likely to represent an over-reporting of deaths due to mediacal error and malpractice.

On the other hand, some medical doctors analyzing medical errors in hospitals claim that these identification of these causes of death far understate deaths resulting from preventable medical errors. Generally, medical error rates are high in hospitals [@classen_global_2011; @landrigan_temporal_2010; @farmer_tension_2013]. With respect to causes of death, Makary and Daniel [@makary_medical_2016] claim that medical error is the third leading cause of death in the U.S. They provide an overview of medical error, which includes the failure to follow a the standard of care. They note that there is no specific way to identify cause of death relating to error under the ICD, and use a meta-analysis from studies to extrapolate the rate of errors causing deaths. Similarly, other physicians involved in epidemiology suggest that adverse events (many of which are contained in Table S-1) are essentially preventable [@leape_preventing_1993]. From this perspective, causes of death due to medical complications are likely to represent an under-reporting of death due to medical error and malpractice.

```the solution: relative rates!!! make sure it fits okay...```

```maybe need to switch this and the other```

##Patient Safety and Malpractice Rates

*Quality of Ptient Care.* Unlike empirical studies in public health and medicine which measure error rates and adverse events rates relative to the population, empirical studies of  malpractice rates are measured relative to physicians, and sometimes weighted by the amounts paid in medical malpractice. Most of these studies are concerned with explaining changes in these rates over time, and they advance a number of reasons to explain changes in the numbers of medical malpractice claims [@paik_receding_2013].  Explanations for changes include the following: (1) tort reform, (2) health care quality, (3) Rising litigation costs, (4) more hospital-employed physicians (hospitals pay instead of physicians, declining the amount of payments), (5) NPDB and settlement, (6) changes in personal injury claims in general.

The link to public health, and the focus of this study, is the inter-relation between health care quality (as measured by mortality by complications) and malpractice rates. Studies examining the link between the quality of medical care and malpractice focus on the errors produced by medical care (often measured as hospital adverse events). Generally, medical care does result in errors, but most errors do not lead to legal claims [@baker_medical_2005]. However, the majority of legal claims do involve errors [@studdert_claims_2006]. Using a sample of claims from California (using county fixed effects), researchers associated with RAND have identified a strong negative correlation between increased patient safety indicators (PSI) (as reported by hospital adverse events) and decreased malpractice claims [@greenberg_is_2010]. A similar data strategy is employed by Black and Zabinski in Texas and Florida [@black_association_2015], making similar findings using hospital and county fixed effects regarding claim rates.

The basic relation here is that the quality of patient care is associated with subsequent malpractice rates. Better patient care is associated with subsequent drops in malpractice rates, while worse patient care leads to increases in malpractice rates. Measuring patient care in terms of mortality form complications, this leads to the following hypothesis:

**Hypothesis 1:** Changes in rates for causes-of-death resulting from medical care (complication causes) are associated with subsequent changes in malpractice rates in the same direction.

```need to include citations below```

*Defensive Medicine.* On the other side of the coin, changes in malpractice rates should be associated with changes in future quality of patient care. In particular rising medical malpractice claims (particularly when these are known to physicians) are predicted ot lead to suboptimal patient care. Instead of focusing solely on clinically appropriate treatment for th patient, doctors become increasingly concerned with minimizing malpractice risk. Accordingly, they overtreat by providing additoinal and unnecessary tests and procedures. While most defensive medicine studies are focused on costs of care, inappropriate over-treatment also carries with it risks (including death). As such, this sort of defensive medicine, if it occurs, should be oobservable in population health statistics, such as an increaase in deaths due to complicatons of medical care. This leads to the following hypothesis.

**Hypothesis 2:** Increasing rates of of malpractice claims are associaated with subsequent increases in the relative rate of deaths due to complications.

Finally, the association of increases in medical malpractice claims with defensive medicine relies on physician awareness of changes. Small perturbations in malpractice rates are unlikely to be noted by physicians. However, spikes in malpractice rates that are out of the ordinary, or significant changes to medical malpractice law are almost certain to be reported on and noted by medical providers. Given the foregoing, the association between malpractice rates and complication deaths should exist (and more strongly) spikes or significant changes in malpractice laws. This leads to the following, related hypotheses:

**Hypothesis 3a:** Spikes in malpractice claims are asociated with subsequent increases in the relative rate of deaths due to complications.

**Hypothesis 3b:** Tort reform changes are asociated with subsequent changes in the relative rate of deaths due to complications.

#Data and Methods

This study two sorts of publicly available administrative data available at the state level. First is the multiple cause of death file from the CDC Wonder database. This is an aggregation of all cause of death statistics throughut the United States. Whenever an individual dies in the United States--man, woman, or child--a coroner or medical examiner (depending on the context of death and the local laws) executes a death certificate identifying up to 20 separate causes of death. The death certificate is collected by each state and delivered to the CDC. At the CDC, the death certificates are subject to a nosological analysis which translates the clinical identification from the death certificate into one of the 8,000 acceptable diagnoses, again, allowing up to 20 different causes of death. CDC Wonder allows aggregation of these by cuase of death, including those deaths resulting from complications (a list of which is attached as Table S-1 in the supplement).

The second dataset I use is the paid claims data from the NPDB public use data file ```cite```. The NPDB collects national data on claims paid for medical malpractice, and, since 2004 includes the severity of the claim. This inlcudes data from physicians (and occasionally other medical practioners) who make payments due to a claim of medical malpractice.

These two files provide measures of cross-influence of malpractice claims related to mortality, and mortality directly related to complications of medical care. First, patient safety is operationalized as the number of deaths in a state due to *complications*, which is measued from CDC wonder simply as the number deaths from complications of medical care in each state, each year. *Malpractice rates* are measured from the NPDB as the number of paid claims resulting from death (which amounts to approximatley 1/3 of the paid claims in any given year). Because mortality rates and cause of death differ significantly between men and women ```cite```, these figures are also sliced by gender, with *female* standing as a dummy indicator for numbers of women.

*Tort Reform Controls.* To adjust for the malpractice and tort reform context in each state, I include a dummy vairable series for each state to indicate whether it has no damage cap for malpractice claims, whether it has a long-standing damage cap, or whether there is a change in the status of the cap between ```date``` and ```date```, following [@paik_receding_2013].

*Testing the Cross-Influence of Malpractice Rates and Patient Safety.* In order to appropriatley test the cross-influence of malpractice rates and patient safety on one another, estimated models include a time-lagged component. The most straightforward approach is to demean or use a first-difference estimator in the relevant models. This works in a staightforward manner for the association of malpractice claims to subsequent causes of death (hypothesis 2), because paid claims occur in a particular year and deaths related to complications occur in another year.

For the influence of patient safety on malpractice claims, the issue is more complicated because there is a lag between the occurence of the event (death) and the paid malpractice claims. This lag means that each year of reporting for malpractice claims contains a mixture of years related to patient safety. Figure 1 and Table 1 below identify the distribution and cumulative proportion of claims related to the lag as observed in the NPDB. As illustrated below, teh bulk of paid claims for mortality occurence happen between 2 and 5 years after the occurence (approximatley 64% of the sample). ```include some justification```

This means that a simple state-level fixed effect will not be comparing the relative rates of deaths to complications and paid claims; it would instead be comparing complications deaths 2-5 years *after* the occurence. To correct for this timing differential, models testing the influence of patient safety on malpractice rates (hypothesis 1 and 2) use the mean number of deaths related to complications from 2 to 5 years prior to year of the paid claims. This provides a smooth and sensible imputation for patient safety given the distributions pictured in Figure 1.

*Time Series Analysis.* Exploiting the panel nature of the data, I estimate hybrid random/fixed effects negative binomial models, adjusting for state and gender-specific effects [@allison_fixed_2009, pp. 65-68].

```correct the stuff below```


I utilize this approach rather than an individual fixed-effects approach for thee reasons. First, the dependant variable in all instances is a count variable, and the fully conditional "fixed effects" models do not control for all stable state-level characteristics ```citation from allison```. The hybrid model is both more efficient and less biased than the fully conditional count models. Second, because the measures of patient safet and paid claims are measured grossly, I anticipate small effects, making efficiency of the method an important consideration. And third, the model allows for inclusion of fixed characteristics of the states, such as it's damages cap status (an important control) [@allison_fixed_2009].

Written as a two-level model, these take the following form:

Level 1 (within-state effects):

$$
g(y_{it}) =  \beta_i +  \delta (\bar{x}_{i \cdot} - x_{it}) + \omega_{it}
$$

Level 2 (between-state effects):

$$
\beta_i = \lambda z_i + \gamma \bar{x}_{i \cdot} + \epsilon_i
$$

Where $g(y_{it})$ is the count of paid malpractice claims or deaths due to medical complications (dependant on the model) in year $t$ for state $i$ with a negative binomial link function [@allison_fixed_2009, p. 61]. $x$ is the time-varying independent variable for each state: the lagged value of paid malpractice claims or medical complications (depending on the model). $z$ is a matrix of fixed state characteristics, including a dummy variable series indicator for the patient gender, a dummy variable series for the state's law regarding damages cap (reference no damages cap), and year fixed effects (to adjust for the declining trend of paid claims). This hybrid model identifies the *within-state* effects ($\delta$) over time, which indicate the predicted effect of a change in the relevant variable $x$ on any state $i$ with respect to the predicted count of paid malpractice claims or deaths due to medical complications. It also identifies the *between-state* effects at level 2, including a vector of effects for constant state characteristics along with a constant (intercept) effect ($\lambda$) and the between-state effects of time-varying variables ($\gamma$). The random errors of level two across states ($\epsilon_i$) are assumed to be distributed normally with mean 0 and variance $\tau^2$ [@raudenbush_hierarchical_2002]. These models are estimated using Stata's xtnbreg function.


#Results

Table 1 descriptives ...

medical malpractice in purely in legal studies. Or studies of medical errors for patient safety.

Why COD is a good place to study:  (1) 1/3 of all malpractice payments are COD. Wrongful death is also highest payouts (confirm), and minimizes the barriers of small-scale claims. (2) practically, it includes the best large-scale data. Distinguish from state-level tests of hospital safety.



#Discussion and Conclusion
