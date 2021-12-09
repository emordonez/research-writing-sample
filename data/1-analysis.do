/*
 * ANALYSIS DO FILE FOR ECON 451 FINAL PAPER
 * Author: Eric Ordonez
 * Date: December 2018, v1.1
 */

/*
 * ---TABLE 1---
 *
 * Baseline comparison of control variables across treatment and control groups. 
 * Output t-tests for differences in means.
 */
ttest age, by(treatment)
ttest yearseduc, by(treatment)
ttest urban, by(treatment)
ttest poor, by(treatment)
ttest married, by(treatment)
ttest employed, by(treatment)
ttest catholic, by(treatment)
ttest muslim, by(treatment)
ttest hastv, by(treatment)
ttest readonline, by(treatment)

/*
 * Age often exhibits nonlinear relationships, thus introduce a higher order
 *	term against the outcome.
 */
egen usageprob_age = mean(outcome), by(age)

// Shaped like a downward parabola, suggesting a negative squared relationship
scatter usageprob_age age, title("Contraceptive Usage Probability vs Age") ///
	xtitle("Age") ytitle("P(Using Modern Method)")

// Suffices to introduce a quadratic term instead of a cubic or B-spline 
//	interpolant
gen age2 = age^2

/*
 * ---TABLE 2---
 *
 * Regressions for hypothesized effect due to treatment alone and with covariate 
 * effects of control variables.
 */
// Naive model
reg outcome treatment

// Sequentially add imbalanced variables to model
reg outcome treatment age age2
reg outcome treatment age age2 yearseduc
reg outcome treatment age age2 yearseduc urban
reg outcome treatment age age2 yearseduc urban married
reg outcome treatment age age2 yearseduc urban married employed

/*
 * ---TABLE 3---
 *
 * Differential effect of employment across treatment and control groups.
 * Generate interaction terms and re-run regressions.
 */
gen treatment_employed = treatment * employed
 
// Difference-in-difference specification alone
reg outcome treatment treatment_employed employed

// With controls
reg outcome treatment treatment_employed employed age age2 yearseduc urban married
