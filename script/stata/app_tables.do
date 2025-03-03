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

eststo t9_iv2_ss_1: xi: xtivreg2 transD77 (L_ratio_15_19_t = L22.netfertility_neighbor5) L_transD77_neighbor i.year if inrange(year, 1950, 2018), fe  cluster(ccode)	
estadd scalar kp_fstat = e(rkf)
eststo t9_iv2_ss_2: xi: xtivreg2 transD77 (L_ratio_15_19_t = L22.netfertility_neighbor5) $n_cov L_transD77_neighbor i.year if inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)

eststo t9_iv3_ss_1: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) L_transD77_neighbor i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo t9_iv3_ss_2: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov L_transD77_neighbor i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
	
eststo t9_iv2_fs_1: xi :xtreg L_ratio_15_19_t L22.netfertility_neighbor5 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)
eststo t9_iv2_fs_2: xi: xtreg L_ratio_15_19_t L22.netfertility_neighbor5 $n_cov L_transD77_neighbor i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

eststo t9_iv3_fs_1: xi :xtreg L_ratio_15_19_t L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)
eststo t9_iv3_fs_2: xi: xtreg L_ratio_15_19_t L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov L_transD77_neighbor i.year if inrange(year, 1950, 2018) & transD77!=., fe  cluster(ccode)

estout t9_iv2_ss_1 t9_iv2_ss_2 t9_iv3_ss_1 t9_iv3_ss_2 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t9_iv2_iv3_neigh_a.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excL_ IV's")) margin legend indicate("Country & year FE's=_Iyear_*")

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

estout t10_iv1 t10_iv2 t10_iv3 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\final_tables\appendix\t10_ar_iv.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excL_ IV's")) margin legend indicate("Country & year FE's=_Iyear_*")

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
