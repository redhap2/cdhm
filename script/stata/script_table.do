capture clear
clear matrix
clear mata
capture log close
set memory 1000m
set maxvar 20000
set matsize 8000
set more off

global mypath "C:\Users\Redha CHABA\Documents"

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year
global c_cov L_ln_gdppc L_vargdppc L_polityD77
global n_cov L_ln_gdppc L_vargdppc L_polityD77 L_polityD77_neighbor


*** Table 1: Summary statistics for baseline sample (since 1951) ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

summarize transD77 ratio_15_19_t ratio_20_24_t ratio_25_29_t ratio_30_34_t ratio_15_34_t ln_gdppc vargdppc polityD77 if year >1950 & transD77 !=.

*** Table 2: Effect of youth bulges on democratic improvements — Regression with controls ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t2_1: xi: xtreg transD77 L_ratio_15_19_t i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t2_2: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t2_3: xi: xtreg transD77 L_ratio_15_19_t L_vargdppc   i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t2_4: xi: xtreg transD77 L_ratio_15_19_t L_polityD77  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t2_5: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t2_6: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77 L_ln_poptotal L_ls_2 L_gini_disp L_urb_harm L_indust i.year if inrange(year, 1950, 2018), fe cluster(ccode)

***** Export Table *****

estout t2_1 t2_2 t2_3 t2_4 t2_5 t2_6 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\table\final_tables\t2_reg_ctl.tex", replace style(tex) varlabels(_cons "Constant") cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 3: Effect of youth bulges on democratic improvements — Lagged fertility variables as instruments ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

***** Panel A: Reduced Form & Second Stage Results Regressions *****

**** Country Net Fertility Rate Instrument ****

*** Reduced Form Regressions ***

* Col 1, OLS (no covariates)
eststo t3_iv1_ols_1: xtreg transD77 L16_netfertility5 i.year if inrange(year, 1950, 2018), fe cluster(ccode)

* Col 2, OLS (covariates)
eststo t3_iv1_ols_2: xtreg transD77 L16_netfertility5 $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

* Col 3, IV (no covariates)
eststo t3_iv1_ss_1: xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 4, IV (covariates)
eststo t3_iv1_ss_2: xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

**** Neighbor Net Fertility Rate Instrument ****

*** Reduced Form Regressions ***

* Col 5, OLS (no covariates)
eststo t3_iv2_ols_1: xtreg transD77 L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018), fe cluster(ccode)

* Col 6, OLS (covariates)
eststo t3_iv2_ols_2: xtreg transD77 L21_netfertility_neighbor5 $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

** Youth Ratio Instrumentation **

* Col 7, IV (no covariates)
eststo t3_iv2_ss_1: xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 8, IV (covariates)
eststo t3_iv2_ss_2: xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

** Country Net Fertility Instrumentation **

* Col 9, IV (no covariates)
eststo t3_iv2_ss_3: xi: xtivreg2 transD77 (L16_netfertility5 = L21_netfertility_neighbor5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 10, IV (covariates)
eststo t3_iv2_ss_4: xi: xtivreg2 transD77 (L16_netfertility5 = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

***** Panel B: First Stage Results Regressions *****

**** Country Net Fertility Rate Instrument ****

*** First Stage Regressions ***

* Col 3, First Stage (no covariates)
eststo t3_iv1_fs_1: xtreg L_ratio_15_19_t L16_netfertility5 i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

* Col 4, First Stage (covariates)
eststo t3_iv1_fs_2: xtreg L_ratio_15_19_t L16_netfertility5 $c_cov i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

**** Neighbor Net Fertility Rate Instrument ****

*** First Stage Regressions ***

** Youth Ratio Instrumentation **

* Col 7, First Stage (no covariates)
eststo t3_iv2_fs_1: xtreg L_ratio_15_19_t L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

* Col 8, First Stage (covariates)
eststo t3_iv2_fs_2: xtreg L_ratio_15_19_t L21_netfertility_neighbor5 $n_cov i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

** Country Net Fertility Instrumentation **

* Col 9, First Stage (no covariates)
eststo t3_iv2_fs_3: xtreg L16_netfertility5 L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

* Col 10, First Stage (covariates)
eststo t3_iv2_fs_4: xtreg L16_netfertility5 L21_netfertility_neighbor5 $n_cov i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

***** Export Tables *****

** Panel A: Reduced Form & Second Stage Results Table **

estout t3_iv1_ols_1 t3_iv1_ols_2 t3_iv1_ss_1 t3_iv1_ss_2 t3_iv2_ols_1 t3_iv2_ols_2 t3_iv2_ss_1 t3_iv2_ss_2 t3_iv2_ss_3 t3_iv2_ss_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\table\final_tables\t3_iv1_iv2_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=*.year") drop(_cons)

** Panel B: First Stage Results Table **

estout t3_iv1_fs_1 t3_iv1_fs_2 t3_iv2_fs_1 t3_iv2_fs_2 t3_iv2_fs_3 t3_iv2_fs_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\table\final_tables\t3_iv1_iv2_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=*.year") drop(_cons)
