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

***** Democ index
**** Polity
***Baseline
use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year

gen transD771=1 if D.polityD77>=1 & D.polityD77!=.
replace transD771=0 if D.polityD77<1 & D.polityD77!=.

gen transcontplus =.
replace transcontplus = D.polityD77 if D.polityD77>0 & D.polityD77!=.
replace transcontplus = 0 if D.polityD77<=0 & D.polityD77!=.

eststo b_trans_1: xi: xtreg transD77 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans_2: xi: xtreg transD77 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans_3: xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans_4: xi: xtreg transD77 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans_5: xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans_6: xi: xtreg transD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans_7: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_trans_1 b_trans_2 b_trans_3 b_trans_4 b_trans_5 b_trans_6 b_trans_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\base_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo b_trans1_1: xi: xtreg transD771 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans1_2: xi: xtreg transD771 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans1_3: xi: xtivreg2 transD771 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans1_4: xi: xtreg transD771 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans1_5: xi: xtivreg2 transD771 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans1_6: xi: xtreg transD771 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans1_7: xi: xtivreg2 transD771 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_trans1_1 b_trans1_2 b_trans1_3 b_trans1_4 b_trans1_5 b_trans1_6 b_trans1_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\base_trans1.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo b_trans3_1: xi: xtreg transD773 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans3_2: xi: xtreg transD773 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans3_3: xi: xtivreg2 transD773 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans3_4: xi: xtreg transD773 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans3_5: xi: xtivreg2 transD773 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans3_6: xi: xtreg transD773 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans3_7: xi: xtivreg2 transD773 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_trans3_1 b_trans3_2 b_trans3_3 b_trans3_4 b_trans3_5 b_trans3_6 b_trans3_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\base_trans3.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo b_transplus_1: xi: xtreg transplus L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_transplus_2: xi: xtreg transplus L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_transplus_3: xi: xtivreg2 transplus (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_transplus_4: xi: xtreg transplus L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_transplus_5: xi: xtivreg2 transplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_transplus_6: xi: xtreg transplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_transplus_7: xi: xtivreg2 transplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_transplus_1 b_transplus_2 b_transplus_3 b_transplus_4 b_transplus_5 b_transplus_6 b_transplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\base_transplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo b_cont_1: xi: xtreg transitionD77 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_cont_2: xi: xtreg transitionD77 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_cont_3: xi: xtivreg2 transitionD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_cont_4: xi: xtreg transitionD77 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_cont_5: xi: xtivreg2 transitionD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_cont_6: xi: xtreg transitionD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_cont_7: xi: xtivreg2 transitionD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_cont_1 b_cont_2 b_cont_3 b_cont_4 b_cont_5 b_cont_6 b_cont_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\base_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo b_contplus_1: xi: xtreg transcontplus L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_contplus_2: xi: xtreg transcontplus L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_contplus_3: xi: xtivreg2 transcontplus (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_contplus_4: xi: xtreg transcontplus L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_contplus_5: xi: xtivreg2 transcontplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_contplus_6: xi: xtreg transcontplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_contplus_7: xi: xtivreg2 transcontplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_contplus_1 b_contplus_2 b_contplus_3 b_contplus_4 b_contplus_5 b_contplus_6 b_contplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\base_contplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}



***remove if polityD77>=8

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940

gen transcontplus =.
replace transcontplus = D.polityD77 if D.polityD77>0 & D.polityD77!=.
replace transcontplus = 0 if D.polityD77<=0 & D.polityD77!=.

gen transD771=1 if D.polityD77>=1 & D.polityD77!=.
replace transD771=0 if D.polityD77<1 & D.polityD77!=.

drop if L_polityD77>=8
tsset ccode year

eststo rm_8_trans_1: xi: xtreg transD77 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_trans_2: xi: xtreg transD77 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_trans_3: xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_trans_4: xi: xtreg transD77 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_trans_5: xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_trans_6: xi: xtreg transD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_trans_7: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_8_trans_1 rm_8_trans_2 rm_8_trans_3 rm_8_trans_4 rm_8_trans_5 rm_8_trans_6 rm_8_trans_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_8_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_8_trans1_1: xi: xtreg transD771 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_trans1_2: xi: xtreg transD771 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_trans1_3: xi: xtivreg2 transD771 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_trans1_4: xi: xtreg transD771 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_trans1_5: xi: xtivreg2 transD771 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_trans1_6: xi: xtreg transD771 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_trans1_7: xi: xtivreg2 transD771 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_8_trans1_1 rm_8_trans1_2 rm_8_trans1_3 rm_8_trans1_4 rm_8_trans1_5 rm_8_trans1_6 rm_8_trans1_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_8_trans1.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo rm_8_trans3_1: xi: xtreg transD773 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_trans3_2: xi: xtreg transD773 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_trans3_3: xi: xtivreg2 transD773 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_trans3_4: xi: xtreg transD773 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_trans3_5: xi: xtivreg2 transD773 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_trans3_6: xi: xtreg transD773 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_trans3_7: xi: xtivreg2 transD773 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_8_trans3_1 rm_8_trans3_2 rm_8_trans3_3 rm_8_trans3_4 rm_8_trans3_5 rm_8_trans3_6 rm_8_trans3_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_8_trans3.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}
 

eststo rm_8_cont_1: xi: xtreg transitionD77 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_cont_2: xi: xtreg transitionD77 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_cont_3: xi: xtivreg2 transitionD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_cont_4: xi: xtreg transitionD77 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_cont_5: xi: xtivreg2 transitionD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_cont_6: xi: xtreg transitionD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_cont_7: xi: xtivreg2 transitionD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_8_cont_1 rm_8_cont_2 rm_8_cont_3 rm_8_cont_4 rm_8_cont_5 rm_8_cont_6 rm_8_cont_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_8_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_8_contplus_1: xi: xtreg transcontplus L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_contplus_2: xi: xtreg transcontplus L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_8_contplus_3: xi: xtivreg2 transcontplus (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_contplus_4: xi: xtreg transcontplus L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_contplus_5: xi: xtivreg2 transcontplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_8_contplus_6: xi: xtreg transcontplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_8_contplus_7: xi: xtivreg2 transcontplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_8_contplus_1 rm_8_contplus_2 rm_8_contplus_3 rm_8_contplus_4 rm_8_contplus_5 rm_8_contplus_6 rm_8_contplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_8_contplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}



***remove if polityD77>=9

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940

gen transcontplus =.
replace transcontplus = D.polityD77 if D.polityD77>0 & D.polityD77!=.
replace transcontplus = 0 if D.polityD77<=0 & D.polityD77!=.

gen transD771=1 if D.polityD77>=1 & D.polityD77!=.
replace transD771=0 if D.polityD77<1 & D.polityD77!=.

drop if L_polityD77>=9
tsset ccode year

eststo rm_9_trans_1: xi: xtreg transD77 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_trans_2: xi: xtreg transD77 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_trans_3: xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_trans_4: xi: xtreg transD77 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_trans_5: xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_trans_6: xi: xtreg transD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_trans_7: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_9_trans_1 rm_9_trans_2 rm_9_trans_3 rm_9_trans_4 rm_9_trans_5 rm_9_trans_6 rm_9_trans_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_9_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_9_trans1_1: xi: xtreg transD771 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_trans1_2: xi: xtreg transD771 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_trans1_3: xi: xtivreg2 transD771 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_trans1_4: xi: xtreg transD771 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_trans1_5: xi: xtivreg2 transD771 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_trans1_6: xi: xtreg transD771 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_trans1_7: xi: xtivreg2 transD771 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_9_trans1_1 rm_9_trans1_2 rm_9_trans1_3 rm_9_trans1_4 rm_9_trans1_5 rm_9_trans1_6 rm_9_trans1_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_9_trans1.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo rm_9_trans3_1: xi: xtreg transD773 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_trans3_2: xi: xtreg transD773 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_trans3_3: xi: xtivreg2 transD773 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_trans3_4: xi: xtreg transD773 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_trans3_5: xi: xtivreg2 transD773 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_trans3_6: xi: xtreg transD773 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_trans3_7: xi: xtivreg2 transD773 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_9_trans3_1 rm_9_trans3_2 rm_9_trans3_3 rm_9_trans3_4 rm_9_trans3_5 rm_9_trans3_6 rm_9_trans3_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_9_trans3.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_9_cont_1: xi: xtreg transitionD77 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_cont_2: xi: xtreg transitionD77 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_cont_3: xi: xtivreg2 transitionD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_cont_4: xi: xtreg transitionD77 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_cont_5: xi: xtivreg2 transitionD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_cont_6: xi: xtreg transitionD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_cont_7: xi: xtivreg2 transitionD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_9_cont_1 rm_9_cont_2 rm_9_cont_3 rm_9_cont_4 rm_9_cont_5 rm_9_cont_6 rm_9_cont_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_9_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_9_contplus_1: xi: xtreg transcontplus L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_contplus_2: xi: xtreg transcontplus L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_9_contplus_3: xi: xtivreg2 transcontplus (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_contplus_4: xi: xtreg transcontplus L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_contplus_5: xi: xtivreg2 transcontplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_9_contplus_6: xi: xtreg transcontplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_9_contplus_7: xi: xtivreg2 transcontplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_9_contplus_1 rm_9_contplus_2 rm_9_contplus_3 rm_9_contplus_4 rm_9_contplus_5 rm_9_contplus_6 rm_9_contplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_9_contplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


***remove if polityD77==10

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940

gen transcontplus =.
replace transcontplus = D.polityD77 if D.polityD77>0 & D.polityD77!=.
replace transcontplus = 0 if D.polityD77<=0 & D.polityD77!=.

gen transD771=1 if D.polityD77>=1 & D.polityD77!=.
replace transD771=0 if D.polityD77<1 & D.polityD77!=.

drop if L_polityD77==10
tsset ccode year

eststo rm_10_trans_1: xi: xtreg transD77 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_trans_2: xi: xtreg transD77 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_trans_3: xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_trans_4: xi: xtreg transD77 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_trans_5: xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_trans_6: xi: xtreg transD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_trans_7: xi: xtivreg2 transD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_10_trans_1 rm_10_trans_2 rm_10_trans_3 rm_10_trans_4 rm_10_trans_5 rm_10_trans_6 rm_10_trans_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_10_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_10_trans1_1: xi: xtreg transD771 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_trans1_2: xi: xtreg transD771 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_trans1_3: xi: xtivreg2 transD771 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_trans1_4: xi: xtreg transD771 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_trans1_5: xi: xtivreg2 transD771 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_trans1_6: xi: xtreg transD771 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_trans1_7: xi: xtivreg2 transD771 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_10_trans1_1 rm_10_trans1_2 rm_10_trans1_3 rm_10_trans1_4 rm_10_trans1_5 rm_10_trans1_6 rm_10_trans1_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_10_trans1.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo rm_10_trans3_1: xi: xtreg transD773 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_trans3_2: xi: xtreg transD773 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_trans3_3: xi: xtivreg2 transD773 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_trans3_4: xi: xtreg transD773 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_trans3_5: xi: xtivreg2 transD773 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_trans3_6: xi: xtreg transD773 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_trans3_7: xi: xtivreg2 transD773 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_10_trans3_1 rm_10_trans3_2 rm_10_trans3_3 rm_10_trans3_4 rm_10_trans3_5 rm_10_trans3_6 rm_10_trans3_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_10_trans3.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo rm_10_cont_1: xi: xtreg transitionD77 L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_cont_2: xi: xtreg transitionD77 L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_cont_3: xi: xtivreg2 transitionD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_cont_4: xi: xtreg transitionD77 L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_cont_5: xi: xtivreg2 transitionD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_cont_6: xi: xtreg transitionD77 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_cont_7: xi: xtivreg2 transitionD77 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_10_cont_1 rm_10_cont_2 rm_10_cont_3 rm_10_cont_4 rm_10_cont_5 rm_10_cont_6 rm_10_cont_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_10_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_10_contplus_1: xi: xtreg transcontplus L_ratio_15_19_t $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_contplus_2: xi: xtreg transcontplus L16_netfertility5 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_10_contplus_3: xi: xtivreg2 transcontplus (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_contplus_4: xi: xtreg transcontplus L21_netfertility_neighbor5 $n_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_contplus_5: xi: xtivreg2 transcontplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_10_contplus_6: xi: xtreg transcontplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_10_contplus_7: xi: xtivreg2 transcontplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_10_contplus_1 rm_10_contplus_2 rm_10_contplus_3 rm_10_contplus_4 rm_10_contplus_5 rm_10_contplus_6 rm_10_contplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\polity\rm_10_contplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}








****V-DEM

***Baseline

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

global c_cov_vdem L_ln_gdppc L_vargdppc L_v2x_polyarchy
global n_cov_vdem L_ln_gdppc L_vargdppc L_v2x_polyarchy L_vdem_polyarchy_neighbor

tsset ccode year
drop if year<1940

gen vdem_trans_3=1 if D.v2x_polyarchy>=0.03 & D.v2x_polyarchy!=.
replace vdem_trans_3=0 if D.v2x_polyarchy<0.03 & D.v2x_polyarchy!=.

gen vdem_transcont = D.v2x_polyarchy

gen vdem_transcontplus=1 if D.v2x_polyarchy>0 & D.v2x_polyarchy!=.
replace vdem_transcontplus=0 if D.v2x_polyarchy<=0 & D.v2x_polyarchy!=.

tsset ccode year

eststo b_trans_1: xi: xtreg vdem_trans_2 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans_2: xi: xtreg vdem_trans_2 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans_3: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans_4: xi: xtreg vdem_trans_2 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans_5: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans_6: xi: xtreg vdem_trans_2 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans_7: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_trans_1 b_trans_2 b_trans_3 b_trans_4 b_trans_5 b_trans_6 b_trans_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\b_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo b_trans003_1: xi: xtreg vdem_trans_3 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans003_2: xi: xtreg vdem_trans_3 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans003_3: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans003_4: xi: xtreg vdem_trans_3 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans003_5: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans003_6: xi: xtreg vdem_trans_3 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans003_7: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_trans003_1 b_trans003_2 b_trans003_3 b_trans003_4 b_trans003_5 b_trans003_6 b_trans003_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\b_trans003.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo b_trans01_1: xi: xtreg vdem_trans L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans01_2: xi: xtreg vdem_trans L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_trans01_3: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans01_4: xi: xtreg vdem_trans L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans01_5: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_trans01_6: xi: xtreg vdem_trans L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_trans01_7: xi: xtivreg2 vdem_trans (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_trans01_1 b_trans01_2 b_trans01_3 b_trans01_4 b_trans01_5 b_trans01_6 b_trans01_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\b_trans01.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}
 
eststo b_cont_1: xi: xtreg vdem_transcont L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_cont_2: xi: xtreg vdem_transcont L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_cont_3: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_cont_4: xi: xtreg vdem_transcont L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_cont_5: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_cont_6: xi: xtreg vdem_transcont L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_cont_7: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_cont_1 b_cont_2 b_cont_3 b_cont_4 b_cont_5 b_cont_6 b_cont_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\b_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo b_contplus_1: xi: xtreg vdem_transcontplus L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_contplus_2: xi: xtreg vdem_transcontplus L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo b_contplus_3: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_contplus_4: xi: xtreg vdem_transcontplus L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_contplus_5: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo b_contplus_6: xi: xtreg vdem_transcontplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo b_contplus_7: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout b_contplus_1 b_contplus_2 b_contplus_3 b_contplus_4 b_contplus_5 b_contplus_6 b_contplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\b_contplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}



***remove if v2x_polyarchy>=0.9

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940

gen vdem_trans_3=1 if D.v2x_polyarchy>=0.03 & D.v2x_polyarchy!=.
replace vdem_trans_3=0 if D.v2x_polyarchy<0.03 & D.v2x_polyarchy!=.

gen vdem_transcont = D.v2x_polyarchy

gen vdem_transcontplus=1 if D.v2x_polyarchy>0 & D.v2x_polyarchy!=.
replace vdem_transcontplus=0 if D.v2x_polyarchy<=0 & D.v2x_polyarchy!=.

drop if v2x_polyarchy>=0.9
tsset ccode year

eststo rm_09_trans_1: xi: xtreg vdem_trans_2 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_trans_2: xi: xtreg vdem_trans_2 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_trans_3: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_trans_4: xi: xtreg vdem_trans_2 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_trans_5: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_trans_6: xi: xtreg vdem_trans_2 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_trans_7: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_09_trans_1 rm_09_trans_2 rm_09_trans_3 rm_09_trans_4 rm_09_trans_5 rm_09_trans_6 rm_09_trans_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_09_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_09_trans003_1: xi: xtreg vdem_trans_3 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_trans003_2: xi: xtreg vdem_trans_3 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_trans003_3: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_trans003_4: xi: xtreg vdem_trans_3 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_trans003_5: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_trans003_6: xi: xtreg vdem_trans_3 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_trans003_7: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_09_trans003_1 rm_09_trans003_2 rm_09_trans003_3 rm_09_trans003_4 rm_09_trans003_5 rm_09_trans003_6 rm_09_trans003_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_09_trans003.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo rm_09_trans01_1: xi: xtreg vdem_trans L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_trans01_2: xi: xtreg vdem_trans L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_trans01_3: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_trans01_4: xi: xtreg vdem_trans L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_trans01_5: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_trans01_6: xi: xtreg vdem_trans L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_trans01_7: xi: xtivreg2 vdem_trans (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_09_trans01_1 rm_09_trans01_2 rm_09_trans01_3 rm_09_trans01_4 rm_09_trans01_5 rm_09_trans01_6 rm_09_trans01_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_09_trans01.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}
 
eststo rm_09_cont_1: xi: xtreg vdem_transcont L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_cont_2: xi: xtreg vdem_transcont L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_cont_3: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_cont_4: xi: xtreg vdem_transcont L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_cont_5: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_cont_6: xi: xtreg vdem_transcont L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_cont_7: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_09_cont_1 rm_09_cont_2 rm_09_cont_3 rm_09_cont_4 rm_09_cont_5 rm_09_cont_6 rm_09_cont_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_09_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_09_contplus_1: xi: xtreg vdem_transcontplus L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_contplus_2: xi: xtreg vdem_transcontplus L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_09_contplus_3: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_contplus_4: xi: xtreg vdem_transcontplus L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_contplus_5: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_09_contplus_6: xi: xtreg vdem_transcontplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_09_contplus_7: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_09_contplus_1 rm_09_contplus_2 rm_09_contplus_3 rm_09_contplus_4 rm_09_contplus_5 rm_09_contplus_6 rm_09_contplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_09_contplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}





***remove if v2x_polyarchy>=0.85

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940

gen vdem_trans_3=1 if D.v2x_polyarchy>=0.03 & D.v2x_polyarchy!=.
replace vdem_trans_3=0 if D.v2x_polyarchy<0.03 & D.v2x_polyarchy!=.

gen vdem_transcont = D.v2x_polyarchy

gen vdem_transcontplus=1 if D.v2x_polyarchy>0 & D.v2x_polyarchy!=.
replace vdem_transcontplus=0 if D.v2x_polyarchy<=0 & D.v2x_polyarchy!=.

drop if v2x_polyarchy>=0.85
tsset ccode year

eststo rm_085_trans_1: xi: xtreg vdem_trans_2 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_trans_2: xi: xtreg vdem_trans_2 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_trans_3: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_trans_4: xi: xtreg vdem_trans_2 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_trans_5: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_trans_6: xi: xtreg vdem_trans_2 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_trans_7: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_085_trans_1 rm_085_trans_2 rm_085_trans_3 rm_085_trans_4 rm_085_trans_5 rm_085_trans_6 rm_085_trans_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_085_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_085_trans003_1: xi: xtreg vdem_trans_3 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_trans003_2: xi: xtreg vdem_trans_3 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_trans003_3: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_trans003_4: xi: xtreg vdem_trans_3 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_trans003_5: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_trans003_6: xi: xtreg vdem_trans_3 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_trans003_7: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_085_trans003_1 rm_085_trans003_2 rm_085_trans003_3 rm_085_trans003_4 rm_085_trans003_5 rm_085_trans003_6 rm_085_trans003_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_085_trans003.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo rm_085_trans01_1: xi: xtreg vdem_trans L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_trans01_2: xi: xtreg vdem_trans L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_trans01_3: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_trans01_4: xi: xtreg vdem_trans L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_trans01_5: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_trans01_6: xi: xtreg vdem_trans L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_trans01_7: xi: xtivreg2 vdem_trans (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_085_trans01_1 rm_085_trans01_2 rm_085_trans01_3 rm_085_trans01_4 rm_085_trans01_5 rm_085_trans01_6 rm_085_trans01_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_085_trans01.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}
 
eststo rm_085_cont_1: xi: xtreg vdem_transcont L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_cont_2: xi: xtreg vdem_transcont L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_cont_3: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_cont_4: xi: xtreg vdem_transcont L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_cont_5: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_cont_6: xi: xtreg vdem_transcont L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_cont_7: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_085_cont_1 rm_085_cont_2 rm_085_cont_3 rm_085_cont_4 rm_085_cont_5 rm_085_cont_6 rm_085_cont_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_085_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_085_contplus_1: xi: xtreg vdem_transcontplus L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_contplus_2: xi: xtreg vdem_transcontplus L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_085_contplus_3: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_contplus_4: xi: xtreg vdem_transcontplus L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_contplus_5: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_085_contplus_6: xi: xtreg vdem_transcontplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_085_contplus_7: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_085_contplus_1 rm_085_contplus_2 rm_085_contplus_3 rm_085_contplus_4 rm_085_contplus_5 rm_085_contplus_6 rm_085_contplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_085_contplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}



***remove if v2x_polyarchy>=0.8

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940

gen vdem_trans_3=1 if D.v2x_polyarchy>=0.03 & D.v2x_polyarchy!=.
replace vdem_trans_3=0 if D.v2x_polyarchy<0.03 & D.v2x_polyarchy!=.

gen vdem_transcont = D.v2x_polyarchy

gen vdem_transcontplus=1 if D.v2x_polyarchy>0 & D.v2x_polyarchy!=.
replace vdem_transcontplus=0 if D.v2x_polyarchy<=0 & D.v2x_polyarchy!=.

drop if v2x_polyarchy>=0.8
tsset ccode year

eststo rm_08_trans_1: xi: xtreg vdem_trans_2 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_trans_2: xi: xtreg vdem_trans_2 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_trans_3: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_trans_4: xi: xtreg vdem_trans_2 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_trans_5: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_trans_6: xi: xtreg vdem_trans_2 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_trans_7: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_08_trans_1 rm_08_trans_2 rm_08_trans_3 rm_08_trans_4 rm_08_trans_5 rm_08_trans_6 rm_08_trans_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_08_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_08_trans003_1: xi: xtreg vdem_trans_3 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_trans003_2: xi: xtreg vdem_trans_3 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_trans003_3: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_trans003_4: xi: xtreg vdem_trans_3 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_trans003_5: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_trans003_6: xi: xtreg vdem_trans_3 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_trans003_7: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_08_trans003_1 rm_08_trans003_2 rm_08_trans003_3 rm_08_trans003_4 rm_08_trans003_5 rm_08_trans003_6 rm_08_trans003_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_08_trans003.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo rm_08_trans01_1: xi: xtreg vdem_trans L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_trans01_2: xi: xtreg vdem_trans L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_trans01_3: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_trans01_4: xi: xtreg vdem_trans L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_trans01_5: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_trans01_6: xi: xtreg vdem_trans L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_trans01_7: xi: xtivreg2 vdem_trans (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_08_trans01_1 rm_08_trans01_2 rm_08_trans01_3 rm_08_trans01_4 rm_08_trans01_5 rm_08_trans01_6 rm_08_trans01_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_08_trans01.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}
 
eststo rm_08_cont_1: xi: xtreg vdem_transcont L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_cont_2: xi: xtreg vdem_transcont L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_cont_3: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_cont_4: xi: xtreg vdem_transcont L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_cont_5: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_cont_6: xi: xtreg vdem_transcont L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_cont_7: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_08_cont_1 rm_08_cont_2 rm_08_cont_3 rm_08_cont_4 rm_08_cont_5 rm_08_cont_6 rm_08_cont_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_08_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_08_contplus_1: xi: xtreg vdem_transcontplus L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_contplus_2: xi: xtreg vdem_transcontplus L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_08_contplus_3: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_contplus_4: xi: xtreg vdem_transcontplus L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_contplus_5: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_08_contplus_6: xi: xtreg vdem_transcontplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_08_contplus_7: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_08_contplus_1 rm_08_contplus_2 rm_08_contplus_3 rm_08_contplus_4 rm_08_contplus_5 rm_08_contplus_6 rm_08_contplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_08_contplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}



***remove if v2x_polyarchy>=0.75

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940

gen vdem_trans_3=1 if D.v2x_polyarchy>=0.03 & D.v2x_polyarchy!=.
replace vdem_trans_3=0 if D.v2x_polyarchy<0.03 & D.v2x_polyarchy!=.

gen vdem_transcont = D.v2x_polyarchy

gen vdem_transcontplus=1 if D.v2x_polyarchy>0 & D.v2x_polyarchy!=.
replace vdem_transcontplus=0 if D.v2x_polyarchy<=0 & D.v2x_polyarchy!=.

drop if v2x_polyarchy>=0.75
tsset ccode year

eststo rm_075_trans_1: xi: xtreg vdem_trans_2 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_trans_2: xi: xtreg vdem_trans_2 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_trans_3: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_trans_4: xi: xtreg vdem_trans_2 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_trans_5: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_trans_6: xi: xtreg vdem_trans_2 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_trans_7: xi: xtivreg2 vdem_trans_2 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_075_trans_1 rm_075_trans_2 rm_075_trans_3 rm_075_trans_4 rm_075_trans_5 rm_075_trans_6 rm_075_trans_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_075_trans.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_075_trans003_1: xi: xtreg vdem_trans_3 L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_trans003_2: xi: xtreg vdem_trans_3 L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_trans003_3: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_trans003_4: xi: xtreg vdem_trans_3 L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_trans003_5: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_trans003_6: xi: xtreg vdem_trans_3 L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_trans003_7: xi: xtivreg2 vdem_trans_3 (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_075_trans003_1 rm_075_trans003_2 rm_075_trans003_3 rm_075_trans003_4 rm_075_trans003_5 rm_075_trans003_6 rm_075_trans003_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_075_trans003.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}

eststo rm_075_trans01_1: xi: xtreg vdem_trans L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_trans01_2: xi: xtreg vdem_trans L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_trans01_3: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_trans01_4: xi: xtreg vdem_trans L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_trans01_5: xi: xtivreg2 vdem_trans (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_trans01_6: xi: xtreg vdem_trans L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_trans01_7: xi: xtivreg2 vdem_trans (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_075_trans01_1 rm_075_trans01_2 rm_075_trans01_3 rm_075_trans01_4 rm_075_trans01_5 rm_075_trans01_6 rm_075_trans01_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_075_trans01.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}
 
eststo rm_075_cont_1: xi: xtreg vdem_transcont L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_cont_2: xi: xtreg vdem_transcont L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_cont_3: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_cont_4: xi: xtreg vdem_transcont L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_cont_5: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_cont_6: xi: xtreg vdem_transcont L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_cont_7: xi: xtivreg2 vdem_transcont (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_075_cont_1 rm_075_cont_2 rm_075_cont_3 rm_075_cont_4 rm_075_cont_5 rm_075_cont_6 rm_075_cont_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_075_cont.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}


eststo rm_075_contplus_1: xi: xtreg vdem_transcontplus L_ratio_15_19_t $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_contplus_2: xi: xtreg vdem_transcontplus L16_netfertility5 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)	
eststo rm_075_contplus_3: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L16_netfertility5) $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe  cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_contplus_4: xi: xtreg vdem_transcontplus L21_netfertility_neighbor5 $n_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_contplus_5: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)
eststo rm_075_contplus_6: xi: xtreg vdem_transcontplus L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2 $c_cov_vdem i.year  if  inrange(year, 1950, 2018), fe cluster(ccode)
eststo rm_075_contplus_7: xi: xtivreg2 vdem_transcontplus (L_ratio_15_19_t =  L17_mean5_spei12_agr2_2 L17_mean5_spei12 L17_agrgdp_2) $c_cov_vdem i.year if inrange(year, 1950, 2018), fe cluster(ccode)
estadd scalar kp_fstat = e(rkf)

noisily{
estout rm_075_contplus_1 rm_075_contplus_2 rm_075_contplus_3 rm_075_contplus_4 rm_075_contplus_5 rm_075_contplus_6 rm_075_contplus_7 using "C:\Users\Redha CHABA\Documents\wp_git\cdhm\tables\report\democ_index\vdem\rm_075_contplus.tex", replace style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N N_g r2_w kp_fstat, fmt(%9.0fc 0 3) labels("Observations" "Countries" "Within-R$^2$" "K-P F-stat on excl. IV's")) margin legend indicate("Country & year FE's=_Iyear_*") drop(_cons)
}



