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

******  Table 21: Effect of youth bulges on improvements in the Polyarchy index — Climatic variables interacted with the share of agriculture in GDP as instrument ******

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

***** Panel A: Reduced Form & Second Stage Results Regressions*****

**** Reduced Form Regressions ****

* Col 1, OLS (no covariates)
	eststo t21_iv3_ols_1: xi: xtreg vdem_trans_2 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & L_ratio_15_19_t !=., fe cluster(ccode)

* Col 2, OLS (covariates)
	eststo t21_iv3_ols_2: xi: xtreg vdem_trans_2  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 L_ln_gdppc L_vargdppc L_v2x_polyarchy   i.year if inrange(year, 1950, 2018) & L_ratio_15_19_t !=., fe cluster(ccode)

*** Youth Ratio Instrumentation ***

** Second Stage Regressions **

* Col 3, IV (no covariates)
	eststo t21_iv3_ss_1: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
* Col 4, IV (covariates)
	eststo t21_iv3_ss_2: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) L_ln_gdppc L_vargdppc L_v2x_polyarchy i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
*** Country Net Fertility Rate Instrumentation ****

** Second Stage Regressions **

* Col 5, IV (no covariates)
	eststo t21_iv3_ss_3: xi: xtivreg2 vdem_trans_2 (L16_netfertility5 =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
* Col 6, IV (covariates)
	eststo t21_iv3_ss_4: xi: xtivreg2 vdem_trans_2 (L16_netfertility5 =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) L_ln_gdppc L_vargdppc L_v2x_polyarchy i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

***** Panel B: First Stage Results Regressions *****

*** Youth Ratio Instrumentation ***

** First Stage Regressions **

* Col 3, First Stage (no covariates)
eststo t21_iv3_fs_1: xi: xtreg L_ratio_15_19_t  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & vdem_trans_2!=., fe  cluster(ccode)

* Col 4, First Stage (covariates)
eststo t21_iv3_fs_2: xi: xtreg L_ratio_15_19_t  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 L_ln_gdppc L_vargdppc L_v2x_polyarchy i.year if inrange(year, 1950, 2018) & vdem_trans_2!=., fe  cluster(ccode)

*** Country Net Fertility Rate Instrumentation ****

** First Stage Regressions **

* Col 5, First Stage (no covariates)
eststo t21_iv3_fs_3: xi: xtreg L16_netfertility5 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & vdem_trans_2!=., fe  cluster(ccode)

* Col 6, First Stage (covariates)
eststo t21_iv3_fs_4: xi: xtreg L16_netfertility5 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 L_ln_gdppc L_vargdppc L_v2x_polyarchy i.year if inrange(year, 1950, 2018) & vdem_trans_2!=., fe  cluster(ccode)

***** Export Tables *****

** Panel A: Reduced Form & Second Stage Results Table **

estout t21_iv3_ols_1 t21_iv3_ols_2 t21_iv3_ss_1 t21_iv3_ss_2 t21_iv3_ss_3 t21_iv3_ss_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t21_iv3_vdem_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excL_ IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

** Panel B: First Stage Results Table **

estout t21_iv3_fs_1 t21_iv3_fs_2 t21_iv3_fs_3 t21_iv3_fs_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t21_iv3_vdem_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

****** Table 22: Effect of youth bulges on improvements in the Polyarchy index — Longer-run panel ******

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1800
tsset ccode year


eststo t22_lr_1: xi: xtreg vdem_trans_2 L15_fenetre_15_15 i.year , fe cluster(ccode)
eststo t22_lr_2: xi: xtreg vdem_trans_2 L15_fenetre_15_15 L_vargdppc L_ln_gdppc L_v2x_polyarchy i.year , fe cluster(ccode)
eststo t22_lr_3: xi: xtreg vdem_trans_2 L15_fenetre_15_15 L_vargdppc L_ln_gdppc  L_v2x_polyarchy  L_indust L_urb_harm  i.year , fe cluster(ccode)

estout t22_lr_1 t22_lr_2 t22_lr_3 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t22_lr_vdem.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
