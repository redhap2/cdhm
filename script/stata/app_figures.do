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