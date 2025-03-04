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

*** Table 8: Effect of youth bulges on democratic improvements — Regression with additional controls ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t8_1: xi: xtreg transD77 L_ratio_15_19_t L_urb_harm  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t8_2: xi: xtreg transD77 L_ratio_15_19_t L_ln_poptotal  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t8_3: xi: xtreg transD77 L_ratio_15_19_t L_ls_2   i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t8_4: xi: xtreg transD77 L_ratio_15_19_t L_gini_disp i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t8_5: xi: xtreg transD77 L_ratio_15_19_t L_indust i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t8_6: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77 L_propurban L_ln_poptotal L_ls_2 L_gini_disp  L_indust L_urb_harm i.year if inrange(year, 1950, 2018), fe cluster(ccode)

estout t8_1 t8_2 t8_3 t8_4 t8_5 t8_6 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t8_other_ctl.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)


*** Table 9: 2SLS estimations with control for democratic transitions in neighbors' countries ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t9_iv2_ss_1: xi: xtivreg2 transD77 (L_ratio_15_19_t = L22_netfertility_neighbor5) L_transD77_neighbor i.year if inrange(year, 1950, 2018), fe  cluster(ccode)	
estadd scalar kp_fstat = e(rkf)
eststo t9_iv2_ss_2: xi: xtivreg2 transD77 (L_ratio_15_19_t = L22_netfertility_neighbor5) $n_cov L_transD77_neighbor i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

eststo t9_iv3_ss_1: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) L_transD77_neighbor i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo t9_iv3_ss_2: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov L_transD77_neighbor i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
eststo t9_iv2_fs_1: xi :xtreg L_ratio_15_19_t L22_netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)
eststo t9_iv2_fs_2: xi: xtreg L_ratio_15_19_t L22_netfertility_neighbor5 $n_cov L_transD77_neighbor i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

eststo t9_iv3_fs_1: xi :xtreg L_ratio_15_19_t L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)
eststo t9_iv3_fs_2: xi: xtreg L_ratio_15_19_t L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov L_transD77_neighbor i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

estout t9_iv2_ss_1 t9_iv2_ss_2 t9_iv3_ss_1 t9_iv3_ss_2 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t9_iv2_iv3_neigh_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*")

estout t9_iv2_fs_1 t9_iv2_fs_2 t9_iv3_fs_1 t9_iv3_fs_2 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t9_iv2_iv3_neigh_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 10: Anderson-Rubin (AR) test ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

* Col 1, IV 1
	eststo t10_iv1: xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
	estadd scalar kp_fstat = e(rkf)
	weakiv
	* p-value: 0.0072 | Conf. level: 95% | Conf. Set: [ .207443,  1.2496] 

* Col 2, IV 2
	eststo t10_iv2: xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
	estadd scalar kp_fstat = e(rkf)
	weakiv
	* p-value: 0.0400 | Conf. level: 95% | Conf. Set: [ .104946, 2.88594]  

* Col 3, IV 3
	eststo t10_iv3: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2 L17_mean5_spei12 L17_agrgdp) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
	estadd scalar kp_fstat = e(rkf)
	weakiv
	* p-value: 0.0222 | Conf. level: 95% | Conf. Set: [ .748427, 8.37267]  

estout t10_iv1 t10_iv2 t10_iv3 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t10_ar_iv.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*")

*** Table 11: Effect of output contractions on democratic improvements — Interactions with the Youth ratio ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

eststo t11_1: xi: xtreg transD77 L_ratio_15_19_t   L_vargdppc L_youth_rece_4    i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t11_2: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc  L_vargdppc L_youth_rece_4  L_polityD77     i.year if inrange(year, 1950, 2018), fe cluster(ccode)	

eststo t11_3: xi: xtreg transD77 L_ratio_15_19_t  L_neggrowth_3   L_youth_rece_5    i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t11_4: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_neggrowth_3   L_youth_rece_5 L_polityD77    i.year if inrange(year, 1950, 2018), fe cluster(ccode)

eststo t11_5: xi: xtreg transD77 L_ratio_15_19_t  L_neggrowth_4   L_youth_rece_6    i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t11_6: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_neggrowth_4   L_youth_rece_6 L_polityD77    i.year if inrange(year, 1950, 2018), fe cluster(ccode)	

estout t11_1 t11_2 t11_3 t11_4 t11_5 t11_6 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t11_rece.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 12: Effect of youth bulges on democratic improvements—Longer-run panel – Peak window sub-samples ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1800
tsset ccode year

eststo t12_lr_1_a: xi: xtreg transD77 L_neggrowth_3 i.year if L15_fenetre_15_15==0, fe cluster(ccode)
eststo t12_lr_2_a: xi: xtreg transD77 L_neggrowth_3 L_ln_gdppc L_polityD77 i.year if L15_fenetre_15_15==0, fe cluster(ccode)
eststo t12_lr_3_a: xi: xtreg transD77 L_neggrowth_3 L_ln_gdppc L_polityD77 L_indust L_urb_harm  i.year if L15_fenetre_15_15==0, fe cluster(ccode)

eststo t12_lr_1_b: xi: xtreg transD77 L_neggrowth_3 i.year if L15_fenetre_15_15==1, fe cluster(ccode)
eststo t12_lr_2_b: xi: xtreg transD77 L_neggrowth_3 L_ln_gdppc L_polityD77 i.year if L15_fenetre_15_15==1, fe cluster(ccode)
eststo t12_lr_3_b: xi: xtreg transD77 L_neggrowth_3 L_ln_gdppc L_polityD77 L_indust L_urb_harm  i.year if L15_fenetre_15_15==1, fe cluster(ccode)

estout t12_lr_1_a t12_lr_2_a t12_lr_3_a using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t12_lr_sub_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

estout t12_lr_1_b t12_lr_2_b t12_lr_3_b using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t12_lr_sub_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 13: Effect of youth bulges on riots — Lagged fertility as instrument ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

eststo t13_ols_1_a: xi: xtreg log1_domestic6 L16_netfertility5 i.year, fe cluster(ccode)
eststo t13_ols_2_a: xi: xtreg log1_domestic6 L16_netfertility5 $c_cov i.year, fe cluster(ccode)
eststo t13_ss_1_a: xi: xtivreg2 log1_domestic6 (L_ratio_15_19_t = L16_netfertility5) i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
	estadd scalar kp_fstat = e(rkf)
eststo t13_ss_2_a: xi: xtivreg2 log1_domestic6 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
	estadd scalar kp_fstat = e(rkf)


eststo t13_ols_3_a: xi: xtreg ln2_domestic6 L16_netfertility5 i.year, fe cluster(ccode)
eststo t13_ols_4_a: xi: xtreg ln2_domestic6 L16_netfertility5 $c_cov i.year, fe cluster(ccode)
eststo t13_ss_3_a: xi: xtivreg2 ln2_domestic6 (L_ratio_15_19_t = L16_netfertility5) i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
	estadd scalar kp_fstat = e(rkf)
eststo t13_ss_4_a: xi: xtivreg2 ln2_domestic6 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
	estadd scalar kp_fstat = e(rkf)


eststo t13_fs_1_b: xi: xtreg L_ratio_15_19_t L16_netfertility5 i.year, fe cluster(ccode)
eststo t13_fs_2_b: xi: xtreg L_ratio_15_19_t L16_netfertility5 $c_cov i.year, fe cluster(ccode)

eststo t13_fs_3_b: xi: xtreg L_ratio_15_19_t L16_netfertility5 i.year, fe cluster(ccode)
eststo t13_fs_4_b: xi: xtreg L_ratio_15_19_t L16_netfertility5 $c_cov i.year, fe cluster(ccode)

estout t13_ols_1_a t13_ols_2_a t13_ss_1_a t13_ss_2_a t13_ols_3_a t13_ols_4_a t13_ss_3_a t13_ss_4_a using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t13_iv_riots_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*")

estout t13_fs_1_b t13_fs_2_b t13_fs_3_b t13_fs_4_b using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t13_iv_riots_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 14: Effect of output contractions on riots — Interactions with the youth ratio ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

eststo t14_1: xi: xtreg ln2_domestic6 L_ratio_15_19_t   L_vargdppc L_youth_rece_4    i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t14_2: xi: xtreg ln2_domestic6 L_ratio_15_19_t L_ln_gdppc  L_vargdppc L_youth_rece_4  L_polityD77     i.year if inrange(year, 1950, 2018), fe cluster(ccode)

eststo t14_3: xi: xtreg ln2_domestic6 L_ratio_15_19_t  L_neggrowth_3   L_youth_rece_5    i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t14_4: xi: xtreg ln2_domestic6 L_ratio_15_19_t L_ln_gdppc L_neggrowth_3   L_youth_rece_5 L_polityD77    i.year if inrange(year, 1950, 2018), fe cluster(ccode)

eststo t14_5: xi: xtreg ln2_domestic6 L_ratio_15_19_t  L_neggrowth_4   L_youth_rece_6    i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t14_6: xi: xtreg ln2_domestic6 L_ratio_15_19_t L_ln_gdppc L_neggrowth_4   L_youth_rece_6 L_polityD77    i.year if inrange(year, 1950, 2018), fe cluster(ccode)	

estout t14_1 t14_2 t14_3 t14_4 t14_5 t14_6 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t14_rece_riots.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 15: Alternative coding rules for the Polity2 variable ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

eststo t15_1: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t15_2: xi: xtreg trans L_ratio_15_19_t L_ln_gdppc L_vargdppc L_e_polity2  i.year, fe cluster(ccode)	
eststo t15_3: xi: xtreg transF77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityF77  i.year, fe cluster(ccode)	
eststo t15_4: xi: xtreg transL77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityL77  i.year, fe cluster(ccode)	
eststo t15_5: xi: xtreg transD7788 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD7788  i.year, fe cluster(ccode)	
eststo t15_6: xi: xtreg transD77F88 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77F88  i.year, fe cluster(ccode)	
eststo t15_7: xi: xtreg transD77L88 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77L88  i.year, fe cluster(ccode)	

estout t15_1 t15_2 t15_3 t15_4 t15_5 t15_6 t15_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t15_recode.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 16: Effect of the share of population aged 15 to 24 on democratic improvements ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t16_1: xi: xtreg transD77 L_ratio_15_24_t i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t16_2: xi: xtreg transD77 L_ratio_15_24_t L_ln_gdppc  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t16_3: xi: xtreg transD77 L_ratio_15_24_t L_vargdppc   i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t16_4: xi: xtreg transD77 L_ratio_15_24_t L_polityD77  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t16_5: xi: xtreg transD77 L_ratio_15_24_t L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t16_6: xi: xtreg transD77 L_ratio_15_24_t L_ln_gdppc L_vargdppc L_polityD77 L_ln_poptotal L_ls_2 L_gini_disp L_urb_harm L_indust i.year if inrange(year, 1950, 2018), fe cluster(ccode)

estout t16_1 t16_2 t16_3 t16_4 t16_5 t16_6 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t16_1524.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 17: Effect of the share of population aged 15 to 24 on democratic improvements — Lagged fertility variables as instruments ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

***** Panel A: Reduced Form & Second Stage Results Regressions *****

**** Country Net Fertility Rate Instrument ****

*** Reduced Form Regressions ***

* Col 1, OLS (no covariates)
eststo t17_iv1_ols_1: xi: xtreg transD77 L16_netfertility5 i.year if inrange(year, 1950, 2018), fe cluster(ccode)

* Col 2, OLS (covariates)
eststo t17_iv1_ols_2: xi: xtreg transD77 L16_netfertility5 $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

* Col 3, IV (no covariates)
eststo t17_iv1_ss_1: xi: xtivreg2 transD77 (L_ratio_15_24_t = L16_netfertility5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 4, IV (covariates)
eststo t17_iv1_ss_2: xi: xtivreg2 transD77 (L_ratio_15_24_t = L16_netfertility5) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

**** Neighbor Net Fertility Rate Instrument ****

*** Reduced Form Regressions ***

* Col 5, OLS (no covariates)
eststo t17_iv2_ols_1: xi: xtreg transD77 L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018), fe cluster(ccode)

* Col 6, OLS (covariates)
eststo t17_iv2_ols_2: xi: xtreg transD77 L21_netfertility_neighbor5 $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

** Youth Ratio Instrumentation **

* Col 7, IV (no covariates)
eststo t17_iv2_ss_1: xi: xtivreg2 transD77 (L_ratio_15_24_t = L21_netfertility_neighbor5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 8, IV (covariates)
eststo t17_iv2_ss_2: xi: xtivreg2 transD77 (L_ratio_15_24_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

** Country Net Fertility Instrumentation **

* Col 9, IV (no covariates)
eststo t17_iv2_ss_3: xi: xtivreg2 transD77 (L16_netfertility5 = L21_netfertility_neighbor5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 10, IV (covariates)
eststo t17_iv2_ss_4: xi: xtivreg2 transD77 (L16_netfertility5 = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

***** Panel B: First Stage Results Regressions *****

**** Country Net Fertility Rate Instrument ****

*** First Stage Regressions ***

* Col 3, First Stage (no covariates)
eststo t17_iv1_fs_1: xi: xtreg L_ratio_15_24_t L16_netfertility5 i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

* Col 4, First Stage (covariates)
eststo t17_iv1_fs_2: xi: xtreg L_ratio_15_24_t L16_netfertility5 $c_cov i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

**** Neighbor Net Fertility Rate Instrument ****

*** First Stage Regressions ***

** Youth Ratio Instrumentation **

* Col 7, First Stage (no covariates)
eststo t17_iv2_fs_1: xi: xtreg L_ratio_15_24_t L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

* Col 8, First Stage (covariates)
eststo t17_iv2_fs_2: xi: xtreg L_ratio_15_24_t L21_netfertility_neighbor5 $n_cov i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

** Country Net Fertility Instrumentation **

* Col 9, First Stage (no covariates)
eststo t17_iv2_fs_3: xi: xtreg L16_netfertility5 L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

* Col 10, First Stage (covariates)
eststo t17_iv2_fs_4: xi: xtreg L16_netfertility5 L21_netfertility_neighbor5 $n_cov i.year if inrange(year, 1950, 2018) & transD77 != ., fe cluster(ccode)

***** Export Tables *****

** Panel A: Reduced Form & Second Stage Results Table **

estout t17_iv1_ols_1 t17_iv1_ols_2 t17_iv1_ss_1 t17_iv1_ss_2 t17_iv2_ols_1 t17_iv2_ols_2 t17_iv2_ss_1 t17_iv2_ss_2 t17_iv2_ss_3 t17_iv2_ss_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t17_iv1_iv2_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

** Panel B: First Stage Results Table **

estout t17_iv1_fs_1 t17_iv1_fs_2 t17_iv2_fs_1 t17_iv2_fs_2 t17_iv2_fs_3 t17_iv2_fs_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t17_iv1_iv2_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 18: Effect of the share of the population aged 15 to 24 on democratic improvements—Climatic variables interacted with the share of agriculture in GDP as instruments ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

***** Panel A: Reduced Form & Second Stage Results Regressions*****

**** Reduced Form Regressions ****

* Col 1, OLS (no covariates)
	eststo t18_iv3_ols_1: xi: xtreg transD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & L_ratio_15_24_t !=., fe cluster(ccode)

* Col 2, OLS (covariates)
	eststo t18_iv3_ols_2: xi: xtreg transD77  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) & L_ratio_15_24_t !=., fe cluster(ccode)

*** Youth Ratio Instrumentation ***

** Second Stage Regressions **

* Col 3, IV (no covariates)
	eststo t18_iv3_ss_1: xi: xtivreg2 transD77 (L_ratio_15_24_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
* Col 4, IV (covariates)
	eststo t18_iv3_ss_2: xi: xtivreg2 transD77 (L_ratio_15_24_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
*** Country Net Fertility Rate Instrumentation ****

** Second Stage Regressions **

* Col 5, IV (no covariates)
	eststo t18_iv3_ss_3: xi: xtivreg2 transD77 (L16_netfertility5 =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
* Col 6, IV (covariates)
	eststo t18_iv3_ss_4: xi: xtivreg2 transD77 (L16_netfertility5 =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

***** Panel B: First Stage Results Regressions *****

*** Youth Ratio Instrumentation ***

** First Stage Regressions **

* Col 3, First Stage (no covariates)
eststo t18_iv3_fs_1: xi: xtreg L_ratio_15_24_t  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

* Col 4, First Stage (covariates)
eststo t18_iv3_fs_2: xi: xtreg L_ratio_15_24_t  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 L_ln_gdppc L_vargdppc L_polityD77 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

*** Country Net Fertility Rate Instrumentation ****

** First Stage Regressions **

* Col 5, First Stage (no covariates)
eststo t18_iv3_fs_3: xi: xtreg L16_netfertility5 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

* Col 6, First Stage (covariates)
eststo t18_iv3_fs_4: xi: xtreg L16_netfertility5 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 L_ln_gdppc L_vargdppc L_polityD77 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

***** Export Tables *****

** Panel A: Reduced Form & Second Stage Results Table **

estout t18_iv3_ols_1 t18_iv3_ols_2 t18_iv3_ss_1 t18_iv3_ss_2 t18_iv3_ss_3 t18_iv3_ss_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t18_iv3_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

** Panel B: First Stage Results Table **

estout t18_iv3_fs_1 t18_iv3_fs_2 t18_iv3_fs_3 t18_iv3_fs_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t18_iv3_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 19: Effect of youth bulges on improvements in the Polyarchy index ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t19_1: xi: xtreg vdem_trans_2 L_ratio_15_19_t i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t19_2: xi: xtreg vdem_trans_2 L_ratio_15_19_t L_ln_gdppc  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t19_3: xi: xtreg vdem_trans_2 L_ratio_15_19_t L_vargdppc   i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t19_4: xi: xtreg vdem_trans_2 L_ratio_15_19_t L_v2x_polyarchy  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t19_5: xi: xtreg vdem_trans_2 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_v2x_polyarchy  i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t19_6: xi: xtreg vdem_trans_2 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_v2x_polyarchy L_ln_poptotal L_ls_2 L_gini_disp L_urb_harm L_indust i.year if inrange(year, 1950, 2018), fe cluster(ccode)

estout t19_1 t19_2 t19_3 t19_4 t19_5 t19_6 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t19_vdem_ols.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 20: Effect of youth bulges on improvements in the Polyarchy index — Lagged fertility variables as intruments ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

***** Panel A: Reduced Form & Second Stage Results Regressions *****

**** Country Net Fertility Rate Instrument ****

*** Reduced Form Regressions ***

* Col 1, OLS (no covariates)
eststo t20_iv1_ols_1: xi: xtreg vdem_trans_2 L16_netfertility5 i.year if inrange(year, 1950, 2018), fe cluster(ccode)

* Col 2, OLS (covariates)
eststo t20_iv1_ols_2: xi: xtreg vdem_trans_2 L16_netfertility5 L_ln_gdppc L_vargdppc L_v2x_polyarchy i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

* Col 3, IV (no covariates)
eststo t20_iv1_ss_1: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L16_netfertility5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 4, IV (covariates)
eststo t20_iv1_ss_2: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L16_netfertility5) L_ln_gdppc L_vargdppc L_v2x_polyarchy i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

**** Neighbor Net Fertility Rate Instrument ****

*** Reduced Form Regressions ***

* Col 5, OLS (no covariates)
eststo t20_iv2_ols_1: xi: xtreg vdem_trans_2 L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018), fe cluster(ccode)

* Col 6, OLS (covariates)
eststo t20_iv2_ols_2: xi: xtreg vdem_trans_2 L21_netfertility_neighbor5 L_ln_gdppc L_vargdppc L_v2x_polyarchy L_vdem_polyarchy_neighbor i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

** Youth Ratio Instrumentation **

* Col 7, IV (no covariates)
eststo t20_iv2_ss_1: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L21_netfertility_neighbor5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 8, IV (covariates)
eststo t20_iv2_ss_2: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L21_netfertility_neighbor5) L_ln_gdppc L_vargdppc L_v2x_polyarchy L_vdem_polyarchy_neighbor i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

** Country Net Fertility Instrumentation **

* Col 9, IV (no covariates)
eststo t20_iv2_ss_3: xi: xtivreg2 vdem_trans_2 (L16_netfertility5 = L21_netfertility_neighbor5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 10, IV (covariates)
eststo t20_iv2_ss_4: xi: xtivreg2 vdem_trans_2 (L16_netfertility5 = L21_netfertility_neighbor5) L_ln_gdppc L_vargdppc L_v2x_polyarchy L_vdem_polyarchy_neighbor i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

***** Panel B: First Stage Results Regressions *****

**** Country Net Fertility Rate Instrument ****

*** First Stage Regressions ***

* Col 3, First Stage (no covariates)
eststo t20_iv1_fs_1: xi: xtreg L_ratio_15_19_t L16_netfertility5 i.year if inrange(year, 1950, 2018) & vdem_trans_2 != ., fe cluster(ccode)

* Col 4, First Stage (covariates)
eststo t20_iv1_fs_2: xi: xtreg L_ratio_15_19_t L16_netfertility5 L_ln_gdppc L_vargdppc L_v2x_polyarchy i.year if inrange(year, 1950, 2018) & vdem_trans_2 != ., fe cluster(ccode)

**** Neighbor Net Fertility Rate Instrument ****

*** First Stage Regressions ***

** Youth Ratio Instrumentation **

* Col 7, First Stage (no covariates)
eststo t20_iv2_fs_1: xi: xtreg L_ratio_15_19_t L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & vdem_trans_2 != ., fe cluster(ccode)

* Col 8, First Stage (covariates)
eststo t20_iv2_fs_2: xi: xtreg L_ratio_15_19_t L21_netfertility_neighbor5 L_ln_gdppc L_vargdppc L_v2x_polyarchy L_vdem_polyarchy_neighbor i.year if inrange(year, 1950, 2018) & vdem_trans_2 != ., fe cluster(ccode)

** Country Net Fertility Instrumentation **

* Col 9, First Stage (no covariates)
eststo t20_iv2_fs_3: xi: xtreg L16_netfertility5 L21_netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & vdem_trans_2 != ., fe cluster(ccode)

* Col 10, First Stage (covariates)
eststo t20_iv2_fs_4: xi: xtreg L16_netfertility5 L21_netfertility_neighbor5 L_ln_gdppc L_vargdppc L_v2x_polyarchy L_vdem_polyarchy_neighbor i.year if inrange(year, 1950, 2018) & vdem_trans_2 != ., fe cluster(ccode)

***** Export Tables *****

** Panel A: Reduced Form & Second Stage Results Table **

estout t20_iv1_ols_1 t20_iv1_ols_2 t20_iv1_ss_1 t20_iv1_ss_2 t20_iv2_ols_1 t20_iv2_ols_2 t20_iv2_ss_1 t20_iv2_ss_2 t20_iv2_ss_3 t20_iv2_ss_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t20_iv1_iv2_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

** Panel B: First Stage Results Table **

estout t20_iv1_fs_1 t20_iv1_fs_2 t20_iv2_fs_1 t20_iv2_fs_2 t20_iv2_fs_3 t20_iv2_fs_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t20_iv1_iv2_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

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

estout t21_iv3_ols_1 t21_iv3_ols_2 t21_iv3_ss_1 t21_iv3_ss_2 t21_iv3_ss_3 t21_iv3_ss_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t21_iv3_vdem_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

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

*** Table 23: Effect of youth bulges on democratic improvements — Cut by continent ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t23_eu: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  africa==1|asia==1|nortamerica==1|southamerica==1, fe cluster(ccode)

eststo t23_af: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  EU==1|asia==1|nortamerica==1|southamerica==1, fe cluster(ccode)

eststo t23_as: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  EU==1|africa==1|nortamerica==1|southamerica==1, fe cluster(ccode)

eststo t23_an: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  EU==1|africa==1|asia==1|southamerica==1, fe cluster(ccode)

eststo t23_sa: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  EU==1|africa==1|asia==1|nortamerica==1, fe cluster(ccode)

eststo t23_jack: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode) vce(jackknife)

estout t23_eu t23_af t23_as t23_an t23_sa t23_jack using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t23_cut_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 24: Effect of youth bulges on democratic improvements — Cut by region (Africa) ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t24_north: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  e_regiongeo!=. & e_regiongeo!=5, fe cluster(ccode)

eststo t24_west: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  e_regiongeo!=. & e_regiongeo!=6, fe cluster(ccode)

eststo t24_central: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  e_regiongeo!=. & e_regiongeo!=7, fe cluster(ccode)

eststo t24_east: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  e_regiongeo!=. & e_regiongeo!=8, fe cluster(ccode)

eststo t24_south: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  e_regiongeo!=. & e_regiongeo!=9, fe cluster(ccode)

estout t24_north t24_west t24_central t24_east t24_south using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t24_cut_af.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 25: Effect of youth bulges on democratic improvements — Cut by region (America) ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t25_north: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  e_regiongeo!=. & e_regiongeo!=16, fe cluster(ccode)

eststo t25_central: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  e_regiongeo!=. & e_regiongeo!=17, fe cluster(ccode)

eststo t25_south: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  e_regiongeo!=. & e_regiongeo!=18, fe cluster(ccode)

eststo t25_caribb: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018) &  e_regiongeo!=. & e_regiongeo!=19, fe cluster(ccode)

estout t25_north t25_central t25_south t25_caribb using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t25_cut_am.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 26: Effect of net fertility rates on democratic improvements ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t26_1: xi: xtreg transD77 L_netfertility5 L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t26_2: xi: xtreg transD77 L5_netfertility5 L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t26_3: xi: xtreg transD77 L10_netfertility5 L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t26_4: xi: xtreg transD77 L16_netfertility5 L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t26_5: xi: xtreg transD77 L20_netfertility5 L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t26_6: xi: xtreg transD77 L_netfertility5 L5_netfertility5 L10_netfertility5 L16_netfertility5 L20_netfertility5 L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)

estout t26_1 t26_2 t26_3 t26_4 t26_5 t26_6 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t26_fertility_var.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 27: Effect of youth male bulges on democratic improvements ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t27_1: xi: xtreg transD77 L_ratio_m_t i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t27_2: xi: xtreg transD77 L_ratio_m_t L_urb_harm  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t27_3: xi: xtreg transD77 L_ratio_m_t L_ln_poptotal  i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t27_4: xi: xtreg transD77 L_ratio_m_t L_ls_2   i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t27_5: xi: xtreg transD77 L_ratio_m_t L_gini_disp i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t27_6: xi: xtreg transD77 L_ratio_m_t L_indust i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo t27_7: xi: xtreg transD77 L_ratio_m_t L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t27_8: xi: xtreg transD77 L_ratio_m_t L_ln_gdppc L_vargdppc L_polityD77 L_ln_poptotal L_ls_2 L_gini_disp L_urb_harm L_indust i.year if inrange(year, 1950, 2018), fe cluster(ccode)

estout t27_1 t27_2 t27_3 t27_4 t27_5 t27_6 t27_7 t27_8 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t27_male.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)


*** Table 28: Different measures of political transitions ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t28_1: xi: xtreg transD773 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t28_2: xi: xtreg transD773 L16_netfertility5  L_ln_gdppc L_vargdppc L_polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)		
eststo t28_3: xi: xtivreg2 transD773 (L_ratio_15_19_t = L16_netfertility5) L_ln_gdppc L_vargdppc L_polityD77     i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

eststo t28_4: xi: xtreg transitionD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t28_5: xi: xtreg transitionD77 L16_netfertility5 L_ln_gdppc L_vargdppc L_polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t28_6: xi: xtivreg2 transitionD77 (L_ratio_15_19_t = L16_netfertility5) L_ln_gdppc L_vargdppc L_polityD77    i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

eststo t28_7: xi: xtreg transML L_ratio_15_19_t L_ln_gdppc L_vargdppc L_C_MLDI     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t28_8: xi: xtreg transML L16_netfertility5 L_ln_gdppc L_vargdppc L_C_MLDI     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t28_9: xi: xtivreg2 transML (L_ratio_15_19_t = L16_netfertility5) L_ln_gdppc L_vargdppc L_C_MLDI    i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

estout t28_1 t28_2 t28_3 t28_4 t28_5 t28_6 t28_7 t28_8 t28_9 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t28_pol_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 29: Effect of youth bulges on revolution and democratic reversal ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t29_1: xi: xtreg log1_domestic7 ratio_15_19_t ln_gdppc vargdppc polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t29_2: xi: xtreg log1_domestic7 L15_netfertility5 ln_gdppc vargdppc polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t29_3: xi: xtivreg2 log1_domestic7 (L_ratio_15_19_t = L16_netfertility5) L_ln_gdppc L_vargdppc L_log1_domestic7    i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

eststo t29_4: xi: xtreg ln2_domestic7 ratio_15_19_t ln_gdppc vargdppc polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t29_5: xi: xtreg ln2_domestic7 L15_netfertility5 ln_gdppc vargdppc polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t29_6: xi: xtivreg2 ln2_domestic7 (ratio_15_19_t = L15_netfertility5) ln_gdppc vargdppc polityD77    i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

eststo t29_7: xi: xtreg negtransD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t29_8: xi: xtreg negtransD77 L16_netfertility5  L_ln_gdppc L_vargdppc L_polityD77     i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)		
eststo t29_9: xi: xtivreg2 negtransD77 (L_ratio_15_19_t = L16_netfertility5) L_ln_gdppc L_vargdppc L_polityD77     i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

estout t29_1 t29_2 t29_3 t29_4 t29_5 t29_6 t29_7 t29_8 t29_9 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t29_reversal.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 30: Effect of riots driven by a high youth ratio on democratic reversals — Lagged fertility as instrument ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

***** Panel A: Reduced Form & Second Stage Results Regressions *****

**** ln(riots(t-1)) Instrument ****

* Col 1, OLS (covariates)
eststo t30_iv1_ols: xi: xtreg negtransD77 L_log1_domestic6 $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

* Col 2, IV (no covariates)
eststo t30_iv1_ss_1: xi: xtivreg2 negtransD77 (L_log1_domestic6 = L16_netfertility5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 3, IV (covariates)
eststo t30_iv1_ss_2: xi: xtivreg2 negtransD77 (L_log1_domestic6 = L16_netfertility5) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

**** asinh(riots(t-1)) Instrument ****

* Col 4, OLS (covariates)
eststo t30_iv2_ols: xi: xtreg negtransD77 L_ln2_domestic6 $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

*** Second Stage Regressions ***

* Col 5, IV (no covariates)
eststo t30_iv2_ss_1: xi: xtivreg2 negtransD77 (L_ln2_domestic6 = L16_netfertility5) i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

* Col 6, IV (covariates)
eststo t30_iv2_ss_2: xi: xtivreg2 negtransD77 (L_ln2_domestic6 = L16_netfertility5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

***** Panel B: First Stage Results Regressions *****

**** ln(riots(t-1)) Instrument ****

* Col 2, First Stage (no covariates)
eststo t30_iv1_fs_1: xi: xtreg L_log1_domestic6 L16_netfertility5 i.year if inrange(year, 1950, 2018) & negtransD77 != ., fe cluster(ccode)

* Col 3, First Stage (covariates)
eststo t30_iv1_fs_2: xi: xtreg L_log1_domestic6 L16_netfertility5 $c_cov i.year if inrange(year, 1950, 2018) & negtransD77 != ., fe cluster(ccode)

**** asinh(riots(t-1)) Instrument ****

* Col 4, First Stage (no covariates)
eststo t30_iv2_fs_1: xi: xtreg L_ln2_domestic6 L16_netfertility5 i.year if inrange(year, 1950, 2018) & negtransD77 != ., fe cluster(ccode)

* Col 5, First Stage (covariates)
eststo t30_iv2_fs_2: xi: xtreg L_ln2_domestic6 L16_netfertility5 $c_cov i.year if inrange(year, 1950, 2018) & negtransD77 != ., fe cluster(ccode)

***** Export Tables *****

** Panel A: Reduced Form & Second Stage Results Table **

estout t30_iv1_ols t30_iv1_ss_1 t30_iv1_ss_2 t30_iv2_ols t30_iv2_ss_1 t30_iv2_ss_2 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t30_iv1_iv2_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

** Panel B: First Stage Results Table **

estout t30_iv1_fs_1 t30_iv1_fs_2 t30_iv2_fs_1 t30_iv2_fs_2 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t30_iv1_iv2_b.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 31: Placebo tests: Alternative age tranche ratios with the very young and the old ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo t31_1: xi: xtreg transD77 L_ratio_00_04_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t31_2: xi: xtreg transD77 L_ratio_05_09_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t31_3: xi: xtreg transD77 L_ratio_60_64_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t31_4: xi: xtreg transD77 L_ratio_65_69_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t31_5: xi: xtreg transD77 L_ratio_70_74_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)	
eststo t31_6: xi: xtreg transD77 L_ratio_75_79_t L_ln_gdppc L_vargdppc L_polityD77   i.year if inrange(year, 1950, 2018), fe cluster(ccode)	

estout t31_1 t31_2 t31_3 t31_4 t31_5 t31_6 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t31_ratio_var.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 32: Placebo test: Alternative lags in the longer run panel ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1800
tsset ccode year

eststo t32_1: xi: xtreg transD77 L_fenetre_15_15 L_ln_gdppc L_vargdppc L_polityD77   i.year, fe cluster(ccode)	
eststo t32_2: xi: xtreg transD77 L30_fenetre_15_15 L_ln_gdppc L_vargdppc L_polityD77   i.year, fe cluster(ccode)	
eststo t32_3: xi: xtreg transD77 L45_fenetre_15_15 L_ln_gdppc L_vargdppc L_polityD77   i.year, fe cluster(ccode)	
eststo t32_4: xi: xtreg transD77 L60_fenetre_15_15 L_ln_gdppc L_vargdppc L_polityD77   i.year, fe cluster(ccode)	

estout t32_1 t32_2 t32_3 t32_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t32_window_lag_var.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)

*** Table 33: Time varying fixed effects ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
drop if ccode_ts16==.

tsset ccode_ts16 year

eststo t33_1: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018), fe cluster(ccode_ts16)	

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
drop if ccode_ts22==.

tsset ccode_ts22 year

eststo t33_2: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018), fe cluster(ccode_ts22)	

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
drop if ccode_ts33==.

tsset ccode_ts33 year

eststo t33_3: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77  i.year if inrange(year, 1950, 2018), fe cluster(ccode_ts33)	

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

eststo t33_4: xi: xtreg transD77 L_ratio_15_19_t L_ln_gdppc L_vargdppc L_polityD77  i.year c.year#i.ccode if inrange(year, 1950, 2018), fe cluster(ccode)

estout t33_1 t33_2 t33_3 t33_4 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t33_fe_var.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)