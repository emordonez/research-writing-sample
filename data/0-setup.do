/*
 * SETUP DO FILE FOR ECON 451 FINAL PAPER
 * Author: Eric Ordonez
 * Date: December 2018, v1.1 
 */

/*
 * Merging datasets. Need household data for urban/rural setting and wealth 
 * indexes.
 */
set maxvar 10000

// Match household variables to base women variables
use "PHHR70FL.DTA", clear
gen int v001 = hv001
gen int v002 = hv002
sort v001 v002
save "PH-HR_sort.DTA", replace

// Merge household data into women base file
use "PHIR70FL.DTA", clear
sort v001 v002
merge m:1 v001 v002 using "PH-HR_sort.DTA"
save "PH-HR-IR_merged.DTA", replace

/* 
 *	Control variables for baseline comparison.
 */ 
// Respondent's age
gen age = v012

// Total years of education
gen yearseduc = v133 if v133 < 98

// If respondent lives in urban or rural area
gen urban = 1 if hv025 == 1
replace urban = 0 if hv025 == 2

// If respondent belongs to bottom two wealth quintiles
gen poor = 1 if v190 == 1 | v190 == 2
replace poor = 0 if poor == .

// If respondent is married
gen married = 1 if v501 == 1
replace married = 0 if married == .

// If respondent is currently working
gen employed = 1 if v717 >= 1 & v717 <= 9
replace employed = 0 if v717 == 0

// If respondent is Catholic
gen catholic = 1 if v130 == 1
replace catholic = 0 if catholic == .

// If respondent is Muslim
gen muslim = 1 if v130 == 5
replace muslim = 0 if muslim == .

// If respondent has a television
gen hastv = 1 if v121 == 1
replace hastv = 0 if hastv == .

// If respondent has read about contraception online
gen readonline = 1 if s815e == 1
replace readonline = 0 if s815e == 0

/*
 * Assignment to treatment and control. Treatment taken to be those aged 15-16 
 * in 2014 so as to experience at least one year in high school pre- and 
 * post-RH Law.
 */
gen treatment = 1 if age - 3 == 15 | age - 3 == 16
replace treatment = 0 if age - 3 == 18 | age - 3 == 19

// Helper variable to isolate gropus under study from rest of the population
gen study = 1 if treatment == 1 | treatment == 0

/*
 * Cleaning any missing variables. Only @var:employed had missing values 
 * compared to the rest.
 */
replace treatment = . if employed == .

/*
 * Set use of or intent to use modern contraceptive methods as outcome variable.
 */
gen outcome = 1 if v364 == 1 | v364 == 3
replace outcome = 0 if outcome == .
