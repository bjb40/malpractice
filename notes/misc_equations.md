---
author: Bryce Bartlett
date: 4/24/2017
title: "Misc. equations for measures"
---

#Patient safety analysis.

Focusing on death as an outcome, a simple decision-making summary to minimize patient harm (death) is to focus on the probable harm of performing a procedure to the probable harm of not performing the procedure. More partitcularly, a physician should perform a procedure ($p$) if it has a lesser probability of causing harm (death in this case) for the patient than not performing the procedure. In other words, patient safety is maximized using the following iniequality:

Perform the procedure iff $r(h|p=1) < r(h|p=0)$.

With respect to deaths, the decision rule above minimizes the total number of deaths ($min(D)$), because it exposes the population to the lowest risk of death. At the population level, deaths ($D$) are classified as either relating to harm related to medical procedures (*iatrogenic* harm, $c$) or not ($-c$). All things equal, an increase in the number of medical procedures will lead to an increase in iatrogenic harm, or the number of deaths due to medical complications divided by the population at risk ($\frac{D_c}{P}$). This increased number is safe, if and only if it *decreases* the total number of deaths ($D$). This can be measured using relative ratios of deaths due to complications by total deaths:

$$
\frac{D_c}{D}
$$

Where larger numbers represent better patient safety, and lower numbers represent worse patient safety.

(Can simplify this by just looking at population level statistics).

