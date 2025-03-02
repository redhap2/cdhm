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


*** Figure 6: 2SLS leave-one-out regression results ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

**** Second stage ****

** Country Net Fertility Rate Instrument **

xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
    gen trueBeta = _b[L_ratio_15_19_t]

keep if e(sample)

drop group
egen group = group(ccode)

qui su group
    local theN = r(max)
cap drop b_alt
gen b_alt = .
gen b_min = .
gen b_max = .

		
qui forv i = 1/`theN' {
    qui xi:xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year if group != `i' & inrange(year, 1950, 2018), fe cluster(ccode)
	noi noi di "`i'/`theN' done!"
	local beta = _b[L_ratio_15_19_t]
    lincom L_ratio_15_19_t, level(90)
    local lower = r(lb)
    local upper = r(ub)

    replace b_alt = `beta' if group == `i'
    replace b_min = `lower' if group == `i'
    replace b_max = `upper' if group == `i'
}

summ b_min b_max b_alt

egen vtag = tag(ccode)
  cap drop rand

egen rand = group(b_max)	
summarize trueBeta
local trueBeta = r(mean)

      
     tw (rspike b_min b_max rand , lw(thin) lc(gray)) ///
    (scatter b_alt rand , msize(tiny) mc(black) )  ///
   (scatter b_alt rand if b_min < 0 & b_max > 0 , msize(tiny) mc(red)) ///
  if vtag == 1, ///
  yline(0) xscale(off) yscale(noline) xsize(7) ///
    ylab(0.1 1 .62500876 "Main {&beta}" 0 "Zero", angle(0)) ///
	legend(off)
	
graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\final_plots\appendix\f6_a_ss_iv1.jpg", width(4000) replace

** Neighbor Net Fertility Rate Instrument **

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
    gen trueBeta = _b[L_ratio_15_19_t]

keep if e(sample)

drop group
egen group = group(ccode)

qui su group
    local theN = r(max)
cap drop b_alt
gen b_alt = .
gen b_min = .
gen b_max = .

		
qui forv i = 1/`theN' {
    qui xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if group != `i' & inrange(year, 1950, 2018), fe cluster(ccode)

	noi noi di "`i'/`theN' done!"
	local beta = _b[L_ratio_15_19_t]
    lincom L_ratio_15_19_t, level(90)
    local lower = r(lb)
    local upper = r(ub)

    replace b_alt = `beta' if group == `i'
    replace b_min = `lower' if group == `i'
    replace b_max = `upper' if group == `i'
}

summ b_min b_max b_alt

egen vtag = tag(ccode)
  cap drop rand

egen rand = group(b_max)	
summarize trueBeta
local trueBeta = r(mean)

      
     tw (rspike b_min b_max rand , lw(thin) lc(gray)) ///
    (scatter b_alt rand , msize(tiny) mc(black) )  ///
   (scatter b_alt rand if b_min < 0 & b_max > 0 , msize(tiny) mc(red)) ///
  if vtag == 1, ///
  yline(0) xscale(off) yscale(noline) xsize(7) ///
    ylab(0.1 2.5  1.359652 "Main {&beta}" 0 "Zero", angle(0)) ///
	legend(off)
	
graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\final_plots\appendix\f6_c_ss_iv2.jpg", width(4000) replace
	
** Climatic variables interacted with the share of agriculture in GDP Instruments **

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

xi: xtivreg2 transD77 (L_ratio_15_19_t = L17_mean5_spei12_agr2 L17_mean5_spei12 L17_agrgdp) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
    gen trueBeta = _b[L_ratio_15_19_t]

keep if e(sample)

drop group
egen group = group(ccode)

qui su group
    local theN = r(max)
cap drop b_alt
gen b_alt = .
gen b_min = .
gen b_max = .

		
qui forv i = 1/`theN' {
    qui xi: xtivreg2 transD77 (L_ratio_15_19_t = L17_mean5_spei12_agr2 L17_mean5_spei12 L17_agrgdp) $c_cov i.year if group != `i' & inrange(year, 1950, 2018), fe cluster(ccode)

	noi noi di "`i'/`theN' done!"
	local beta = _b[L_ratio_15_19_t]
    lincom L_ratio_15_19_t, level(90)
    local lower = r(lb)
    local upper = r(ub)

    replace b_alt = `beta' if group == `i'
    replace b_min = `lower' if group == `i'
    replace b_max = `upper' if group == `i'
}

summ b_min b_max b_alt

egen vtag = tag(ccode)
  cap drop rand

egen rand = group(b_max)	
summarize trueBeta

      
     tw (rspike b_min b_max rand , lw(thin) lc(gray)) ///
    (scatter b_alt rand , msize(tiny) mc(black) )  ///
   (scatter b_alt rand if b_min < 0 & b_max > 0 , msize(tiny) mc(red)) ///
  if vtag == 1, ///
  yline(0) xscale(off) yscale(noline) xsize(7) ///
    ylab(-1 6   2.885526  "Main {&beta}" 0 "Zero", angle(0)) ///
	legend(off)
	
graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\final_plots\appendix\f6_e_ss_iv3.jpg", width(4000) replace

**** AR ****

** Country Net Fertility Rate Instrument **

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

keep if e(sample)
drop group
egen group = group(ccode)
qui su group
local theN = r(max)
cap drop ar_pval
gen ar_pval =.

forv i = 1/`theN' {
    qui xi: xtivreg2 transD77 (L_ratio_15_19_t = L16_netfertility5) $c_cov i.year if group != `i' & inrange(year, 1950, 2018), fe cluster(ccode) 
    
    qui weakiv, post
    
    local ar_p = e(ar_p)
    
    if mi("`ar_p'") {
        noi di "AR p-value not found in e(ar_p) for group `i'"
        local ar_p = r(ar_p)
        
        if mi("`ar_p'") {
            noi di "AR p-value not found in r(ar_p) either for group `i'"
            local ar_p = e(ar_p_chi2)
            if mi("`ar_p'") local ar_p = r(ar_p_chi2)
        }
    }
    
    noi di "Group `i': AR p-value = `ar_p'"
    
    if !mi("`ar_p'") {
        replace ar_pval = `ar_p' if group == `i'
    }
    
    noi di "`i'/`theN' done!"
}

summ ar_pval

egen vtag = tag(ccode)
cap drop rand
egen rand = group(ar_pval)


tw (scatter ar_pval rand, msize(small) mc(green%50) jitter(10)) ///
   if vtag == 1, ///
   xscale(off) ///
   ytitle("Anderson-Rubin test p-value") ///
   yscale(range(0 0.015)) ///
   ylab(0 0.003 0.006 0.009 0.012 0.015, angle(0)) ///
   legend(off)   
   
graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\final_plots\appendix\f6_b_ar_iv1.jpg", width(4000) replace
	
	
	
** Neighbor Net Fertility Rate Instrument **

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)

keep if e(sample)
drop group
egen group = group(ccode)
qui su group
local theN = r(max)
cap drop ar_pval
gen ar_pval =.


forv i = 1/`theN' {
	qui xi: xtivreg2 transD77 (L_ratio_15_19_t = L21_netfertility_neighbor5) $n_cov i.year if group != `i' & inrange(year, 1950, 2018), fe cluster(ccode)
    
    qui weakiv, post
    
    local ar_p = e(ar_p)
    
    if mi("`ar_p'") {
        noi di "AR p-value not found in e(ar_p) for group `i'"
        local ar_p = r(ar_p)
        
        if mi("`ar_p'") {
            noi di "AR p-value not found in r(ar_p) either for group `i'"
            local ar_p = e(ar_p_chi2)
            if mi("`ar_p'") local ar_p = r(ar_p_chi2)
        }
    }
    
    noi di "Group `i': AR p-value = `ar_p'"
    
    if !mi("`ar_p'") {
        replace ar_pval = `ar_p' if group == `i'
    }
    
    noi di "`i'/`theN' done!"
}

summ ar_pval

egen vtag = tag(ccode)
cap drop rand
egen rand = group(ar_pval)
   
   
tw (scatter ar_pval rand, msize(small) mc(green%50) jitter(10)) ///
   if vtag == 1, ///
   xscale(off) ///
   ytitle("Anderson-Rubin test p-value") ///
   yscale(range(0 0.05)) ///
   ylab(0 0.01 0.02 0.03 0.04 0.05, angle(0)) ///
   legend(off)   
   
graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\final_plots\appendix\f6_d_ar_iv2.jpg", width(4000) replace


** Climatic variables interacted with the share of agriculture in GDP Instruments **

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1940
tsset ccode year

    qui xi: xtivreg2 transD77 (L_ratio_15_19_t = L17_mean5_spei12_agr2 L17_mean5_spei12 L17_agrgdp) $c_cov i.year if inrange(year, 1950, 2018), fe cluster(ccode)
	
	keep if e(sample)
drop group
egen group = group(ccode)
qui su group
local theN = r(max)
cap drop ar_pval
gen ar_pval =.


forv i = 1/`theN' {
    qui xi: xtivreg2 transD77 (L_ratio_15_19_t = L17_mean5_spei12_agr2 L17_mean5_spei12 L17_agrgdp) $c_cov i.year if group != `i' & inrange(year, 1950, 2018), fe cluster(ccode)

    qui weakiv, post
    
    local ar_p = e(ar_p)
    
    if mi("`ar_p'") {
        noi di "AR p-value not found in e(ar_p) for group `i'"
        local ar_p = r(ar_p)
        
        if mi("`ar_p'") {
            noi di "AR p-value not found in r(ar_p) either for group `i'"
            local ar_p = e(ar_p_chi2)
            if mi("`ar_p'") local ar_p = r(ar_p_chi2)
        }
    }
    
    noi di "Group `i': AR p-value = `ar_p'"
    
    if !mi("`ar_p'") {
        replace ar_pval = `ar_p' if group == `i'
    }
    
    noi di "`i'/`theN' done!"
}

summ ar_pval

egen vtag = tag(ccode)
cap drop rand
egen rand = group(ar_pval)
   
   
tw (scatter ar_pval rand, msize(small) mc(green%50) jitter(10)) ///
   if vtag == 1, ///
   xscale(off) ///
   ytitle("Anderson-Rubin test p-value") ///
   yscale(range(0 0.05)) ///
   ylab(0 0.01 0.02 0.03 0.04 0.05, angle(0)) ///
   legend(off)   
   
graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\final_plots\appendix\f6_f_ar_iv3.jpg", width(4000) replace



*** Figure 8: Sensitivity of the effect of Peak window to changes in window size ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1800
tsset ccode year

eststo f8_5: xi: xtreg transD77 L15_fenetre_5_5 L_vargdppc L_ln_gdppc L_polityD77 i.year , fe cluster(ccode)
eststo f8_10: xi: xtreg transD77 L15_fenetre_10_10 L_vargdppc L_ln_gdppc L_polityD77 i.year , fe cluster(ccode)
eststo f8_15: xi: xtreg transD77 L15_fenetre_15_15 L_vargdppc L_ln_gdppc L_polityD77 i.year , fe cluster(ccode)
eststo f8_20: xi: xtreg transD77 L15_fenetre_20_20 L_vargdppc L_ln_gdppc L_polityD77 i.year , fe cluster(ccode)
eststo f8_25: xi: xtreg transD77 L15_fenetre_25_25 L_vargdppc L_ln_gdppc L_polityD77 i.year , fe cluster(ccode)
eststo f8_30: xi: xtreg transD77 L15_fenetre_30_30 L_vargdppc L_ln_gdppc L_polityD77 i.year , fe cluster(ccode)

coefplot f8_5 f8_10 f8_15 f8_20 f8_25 f8_30, ///
      keep(L15_fenetre_5_5 L15_fenetre_10_10 L15_fenetre_15_15 L15_fenetre_20_20 L15_fenetre_25_25 L15_fenetre_30_30) ///
	  coeflabels(L15_fenetre_5_5 = "Peak window (5 - 5)" ///
               L15_fenetre_10_10 = "Peak window (10 - 10)" ///
               L15_fenetre_15_15 = "Peak window (15 - 15)" ///
               L15_fenetre_20_20 = "Peak window (20 - 20)" ///
			   L15_fenetre_25_25 = "Peak window (25 - 25)" ///
			   L15_fenetre_30_30 = "Peak window (30 - 30)") ///
        xline(0) ///
        msymbol(circle) ///
        mcolor(black) ///
        ciopts(recast(rcap) lcolor(black)) ///
        graphregion(color(white)) ///
        grid(none) ///
        xlabel(, grid) ///
        plotregion(margin(l=15)) ///
        title("") ///
        horizontal ///
	    legend(off) ///
        ylab(, labsize(small)) ///
		scheme(s2color)
		
graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\final_plots\appendix\f8_window_var.jpg", width(4000) replace