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

estout t2_1 t2_2 t2_3 t2_4 t2_5 t2_6 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\main\t2_reg_ctl.tex", replace style(tex) varlabels(_cons "Constant") cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 3: Effect of youth bulges on democratic improvements — Lagged fertility variables as instruments ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

***** Panel A: Reduced Form & Second Stage Results Regressions *****

**** Country Net Fertility Rate Instrument ****

*** Reduced Form Regressions ***

* Col 1, OLS (no covariates)
eststo t3_iv1_ols_1: xi: xtreg transD77 L16_netfertility5 i.year if inrange(year, 1950, 2018), fe cluster(ccode)

* Col 2, OLS (covariates)
eststo t3_iv1_ols_2: xi: xtreg transD77 L16_netfertility5 $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

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
eststo t3_iv2_ols_1: xi: xtreg transD77 L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018), fe cluster(ccode)

* Col 6, OLS (covariates)
eststo t3_iv2_ols_2: xi: xtreg transD77 L21_netfertility_neighbor5 $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

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
eststo t3_iv1_fs_1: xi: xtreg L_ratio_15_19_t L16_netfertility5 i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

* Col 4, First Stage (covariates)
eststo t3_iv1_fs_2: xi: xtreg L_ratio_15_19_t L16_netfertility5 $c_cov i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

**** Neighbor Net Fertility Rate Instrument ****

*** First Stage Regressions ***

** Youth Ratio Instrumentation **

* Col 7, First Stage (no covariates)
eststo t3_iv2_fs_1: xi: xtreg L_ratio_15_19_t L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

* Col 8, First Stage (covariates)
eststo t3_iv2_fs_2: xi: xtreg L_ratio_15_19_t L21_netfertility_neighbor5 $n_cov i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

** Country Net Fertility Instrumentation **

* Col 9, First Stage (no covariates)
eststo t3_iv2_fs_3: xi: xtreg L16_netfertility5 L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

* Col 10, First Stage (covariates)
eststo t3_iv2_fs_4: xi: xtreg L16_netfertility5 L21_netfertility_neighbor5 $n_cov i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

***** Export Tables *****

** Panel A: Reduced Form & Second Stage Results Table **

estout t3_iv1_ols_1 t3_iv1_ols_2 t3_iv1_ss_1 t3_iv1_ss_2 t3_iv2_ols_1 t3_iv2_ols_2 t3_iv2_ss_1 t3_iv2_ss_2 t3_iv2_ss_3 t3_iv2_ss_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\main\t3_iv1_iv2_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

** Panel B: First Stage Results Table **

estout t3_iv1_fs_1 t3_iv1_fs_2 t3_iv2_fs_1 t3_iv2_fs_2 t3_iv2_fs_3 t3_iv2_fs_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\main\t3_iv1_iv2_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

******  Table 4: Effect of youth bulges on democratic improvements — Climatic variables interacted with the share of agriculture in GDP as instruments ******

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

***** Panel A: Reduced Form & Second Stage Results Regressions*****

**** Reduced Form Regressions ****

* Col 1, OLS (no covariates)
	eststo t4_iv3_ols_1: xi: xtreg transD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & L_ratio_15_19_t !=., fe cluster(ccode)

* Col 2, OLS (covariates)
	eststo t4_iv3_ols_2: xi: xtreg transD77  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 L.ln_gdppc L.vargdppc L.polityD77   i.year if inrange(year, 1950, 2018) & L_ratio_15_19_t !=., fe cluster(ccode)

*** Youth Ratio Instrumentation ***

** Second Stage Regressions **

* Col 3, IV (no covariates)
	eststo t4_iv3_ss_1: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
* Col 4, IV (covariates)
	eststo t4_iv3_ss_2: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
*** Country Net Fertility Rate Instrumentation ****

** Second Stage Regressions **

* Col 5, IV (no covariates)
	eststo t4_iv3_ss_3: xi: xtivreg2 transD77 (L16_netfertility5 =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
* Col 6, IV (covariates)
	eststo t4_iv3_ss_4: xi: xtivreg2 transD77 (L16_netfertility5 =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

***** Panel B: First Stage Results Regressions *****

*** Youth Ratio Instrumentation ***

** First Stage Regressions **

* Col 3, First Stage (no covariates)
eststo t4_iv3_fs_1: xi: xtreg L_ratio_15_19_t  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

* Col 4, First Stage (covariates)
eststo t4_iv3_fs_2: xi: xtreg L_ratio_15_19_t  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 L.ln_gdppc L.vargdppc L.polityD77 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

*** Country Net Fertility Rate Instrumentation ****

** First Stage Regressions **

* Col 5, First Stage (no covariates)
eststo t4_iv3_fs_3: xi: xtreg L16_netfertility5 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

* Col 6, First Stage (covariates)
eststo t4_iv3_fs_4: xi: xtreg L16_netfertility5 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 L.ln_gdppc L.vargdppc L.polityD77 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

***** Export Tables *****

** Panel A: Reduced Form & Second Stage Results Table **

estout t4_iv3_ols_1 t4_iv3_ols_2 t4_iv3_ss_1 t4_iv3_ss_2 t4_iv3_ss_3 t4_iv3_ss_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\main\t4_iv3_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

** Panel B: First Stage Results Table **

estout t4_iv3_fs_1 t4_iv3_fs_2 t4_iv3_fs_3 t4_iv3_fs_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\main\t4_iv3_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

****** Table 5: Effect of youth bulges on democratic improvements — Longer-run panel ******

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1800
tsset ccode year

eststo t5_lr_1: xi: xtreg transD77 L15_fenetre_15_15 i.year , fe cluster(ccode)
eststo t5_lr_2: xi: xtreg transD77 L15_fenetre_15_15 L_vargdppc L_ln_gdppc L_polityD77 i.year , fe cluster(ccode)
eststo t5_lr_3: xi: xtreg transD77 L15_fenetre_15_15 L_vargdppc L_ln_gdppc  L_polityD77  L_indust L_urb_harm  i.year , fe cluster(ccode)

estout t5_lr_1 t5_lr_2 t5_lr_3 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\main\t5_lr.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

****** Table 6  Effect of youth bulges on riots — Add other controls ******

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year


eststo t6_1:xi:xtreg log1_domestic6 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)
eststo t6_2:xi:xtreg log1_domestic6 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77 L_indust L_urb_harm i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)
eststo t6_3:xi:xtreg ln2_domestic6 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)
eststo t6_4:xi:xtreg ln2_domestic6 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77 L_indust L_urb_harm i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

estout t6_1 t6_2 t6_3 t6_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\main\t6_riots_ols.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)


****** Table 7: Effect of riots driven by a high youth ratio on democratic improvements—Lagged fertility as instrument ******

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

***** Panel A: Reduced Form & Second Stage Results Regressions *****

**** ln(1 + riots_(t−1)) ****

*** Reduced Form Regression ***

eststo t7_iv4_ols: xi: xtreg transD77 L_log1_domestic6 L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

eststo t7_iv4_ss_1: xi: xtivreg2 transD77 (L_log1_domestic6 = L17_netfertility5) i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

eststo t7_iv4_ss_2: xi: xtivreg2 transD77 (L_log1_domestic6 = L17_netfertility5)L_ln_gdppc L_vargdppc L_polityD77 i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

**** sinh(riots(t−1)) ****

*** Reduced Form Regression ***

eststo t7_iv5_ols: xi: xtreg transD77 L_ln2_domestic6 L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

eststo t7_iv5_ss_1: xi: xtivreg2 transD77 (L_ln2_domestic6 = L17_netfertility5) i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

eststo t7_iv5_ss_2: xi: xtivreg2 transD77 (L_ln2_domestic6 = L17_netfertility5)L_ln_gdppc L_vargdppc L_polityD77 i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)


***** Panel B: First Stage Results Regressions *****

**** ln(1 + riots_(t−1)) ****

*** First Stage Regressions ***

eststo t7_iv4_fs_1: xi:xtreg L_log1_domestic6 L17_netfertility5 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)
eststo t7_iv4_fs_2: xi:xtreg L_log1_domestic6 L17_netfertility5 L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

**** sinh(riots(t−1)) ****

*** First Stage Regressions ***

eststo t7_iv5_fs_1: xi:xtreg L_ln2_domestic6 L17_netfertility5 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)
eststo t7_iv5_fs_2: xi:xtreg L_ln2_domestic6 L17_netfertility5 L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

***** Export Tables *****

** Panel A: Reduced Form & Second Stage Results Table **

estout t7_iv4_ols t7_iv4_ss_1 t7_iv4_ss_2 t7_iv5_ols t7_iv5_ss_1 t7_iv5_ss_2 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\main\t7_iv4_iv5_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

** Panel B: First Stage Results Table **

estout t7_iv4_fs_1 t7_iv4_fs_2 t7_iv5_fs_1 t7_iv5_fs_2 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\main\t7_iv4_iv5_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
