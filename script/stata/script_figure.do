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

*** Figure 2: Effect of youth bulges on democratic improvements — Decomposition by age groups ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo f2_1: xi: xtreg transD77 L_ratio_15_34_t i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo f2_2: xi: xtreg transD77 L_ratio_15_29_t i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo f2_3: xi: xtreg transD77 L_ratio_15_24_t i.year if inrange(year, 1950, 2018), fe cluster(ccode)
eststo f2_4: xi: xtreg transD77 L_ratio_15_19_t i.year if inrange(year, 1950, 2018), fe cluster(ccode)

coefplot f2_1 f2_2 f2_3 f2_4, ///
      keep(L_ratio_15_34_t L_ratio_15_29_t L_ratio_15_24_t L_ratio_15_19_t) ///
	  coeflabels(L_ratio_15_34_t = "Youth ratio (15 - 34)" ///
               L_ratio_15_29_t = "Youth ratio (15 - 29)" ///
               L_ratio_15_24_t = "Youth ratio (15 - 24)" ///
               L_ratio_15_19_t = "Youth ratio (15 - 19)") ///
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
		
		
graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\coef_plots\f2_age_a.jpg", width(4000) replace

eststo f2_5: xi: xtreg transD77 L_ratio_15_19_t L_ratio_20_24_t  L_ratio_25_29_t  L_ratio_30_34_t i.year if inrange(year, 1950, 2018), fe cluster(ccode)

coefplot f2_5, ///
      keep(L_ratio_15_19_t L_ratio_20_24_t  L_ratio_25_29_t  L_ratio_30_34_t) ///
	  coeflabels(L_ratio_15_19_t = "Youth ratio (15 - 19)" ///
               L_ratio_20_24_t = "Youth ratio (20 - 24)" ///
               L_ratio_25_29_t = "Youth ratio (25 - 29)" ///
               L_ratio_30_34_t = "Youth ratio (30 - 34)") ///
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
		
		
graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\coef_plots\f2_age_b.jpg", width(4000) replace

*** Figure 3: Interaction effects between recessions and the youth share ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo f3_a: xi:xtreg transD77 L_neggrowth_3 L_ratio_15_19_t  c.L_ratio_15_19_t#c.L_neggrowth_3 L_polityD77 L.ln_gdppc i.year if inrange(year, 1950, 2018), fe cluster(ccode)

generate baseline2=1 if e(sample)
matrix b=e(b)
matrix V=e(V)

matrix b1=e(b1)

matrix b3=e(b3)

scalar b1=b[1,1]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb3=V[3,3]

scalar covb1b3=V[1,3]

scalar list b1 b3 varb1 varb3 covb1b3

generate MVL= L_ratio_15_19_t

gen conbl=b1+b3*MVL

gen consl=sqrt(varb1+varb3*(MVL^2)+2*covb1b3*MVL) 

gen al=1.65*consl

gen upperl=conbl+al

gen lowerl=conbl-al

*********************;
* Generate Rug Plot *;
*********************;

gen where=0.5
gen pipe = "|"

egen tag_youth= tag(L_ratio_15_19_t)
gen yline=0

graph twoway hist MVL if baseline2==1, percent color(gs12%30) yaxis(2)|| line conbl   MVL, lpattern (solid) clwidth(medium)  clcolor(black) ||   line upperl MVL, clpattern(longdash) clwidth(thin) clcolor(gs8) sort ||   line lowerl MVL, clpattern(longdash) clwidth(thin) clcolor(gs8) sort|| , yscale(noline) xscale(noline) yline(0, lcolor(black))  xtitle("Youth Ratio", size(3))xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of Recession", size(3)) scheme(s2mono) graphregion(fcolor(white)) legend(off) xlabel(0.05 "5%" 0.1 "10%" 0.15 "15%" 0.2 "20%" 0.25 "25%")

graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\marginal_plots\f3_rec_a.jpg", width(4000) replace

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear

tsset ccode year
drop if year<1800
tsset ccode year

eststo f3_b_1: xi: xtreg transD77 L15_fenetre_15_15 L_neggrowth_3 L_ln_gdppc L_polityD77 i.year if L15_fenetre_15_15==0, fe cluster(ccode)

eststo f3_b_2: xi: xtreg transD77 L15_fenetre_15_15 L_neggrowth_3 L_ln_gdppc L_polityD77 i.year if L15_fenetre_15_15==1, fe cluster(ccode)



coefplot ///
    (f3_b_1, keep(L_neggrowth_3) rename(L_neggrowth_3 = "Peak Window = 0")) ///
    (f3_b_2, keep(L_neggrowth_3) rename(L_neggrowth_3 = "Peak Window = 1")), ///
    yline(0) ///
    msymbol(circle) ///
    mcolor(black) ///
    ciopts(recast(rcap) lcolor(black)) ///
    graphregion(color(white)) ///
    grid(none) ///
    ylabel(, grid) ///
    title("") ///
    vertical ///
    legend(off) ///
    xscale(range(0 10)) ///
    plotregion(margin(r=-275)) ///
    xlab(, labsize(small)) ///
	ytitle("Marginal Effect of Recession", size(3) margin(r=5)) ///
    scheme(s2color)

graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\marginal_plots\f3_rec_b.jpg", width(4000) replace


*** Figure 3: Interaction effects between recessions and the youth share ***

use "${mypath}\working_paper\cdhm\data\data_dta\data_final.dta", clear
tsset ccode year

drop if year<1940
tsset ccode year

eststo xi:xtreg ln2_domestic6 neggrowth_3 ratio_15_19_t  c.ratio_15_19_t#c.neggrowth_3  ln_gdppc i.year if inrange(year, 1950, 2018), fe cluster(ccode)

generate baseline2=1 if e(sample)
matrix b=e(b)
matrix V=e(V)

matrix b1=e(b1)

matrix b3=e(b3)

scalar b1=b[1,1]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb3=V[3,3]

scalar covb1b3=V[1,3]

scalar list b1 b3 varb1 varb3 covb1b3

generate MVL= L_ratio_15_19_t

gen conbl=b1+b3*MVL

gen consl=sqrt(varb1+varb3*(MVL^2)+2*covb1b3*MVL) 

gen al=1.65*consl

gen upperl=conbl+al

gen lowerl=conbl-al

*********************;
* Generate Rug Plot *;
*********************;

gen where=0.5
gen pipe = "|"

egen tag_youth= tag(L_ratio_15_19_t)
gen yline=0

graph twoway hist MVL if baseline2==1, percent color(gs12%30) yaxis(2)|| line conbl   MVL, lpattern (solid) clwidth(medium)  clcolor(black) ||   line upperl MVL, clpattern(longdash) clwidth(thin) clcolor(gs8) sort ||   line lowerl MVL, clpattern(longdash) clwidth(thin) clcolor(gs8) sort|| , yscale(noline) xscale(noline) yline(0, lcolor(black))  xtitle("Youth Ratio", size(3))xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of Recession", size(3)) scheme(s2mono) graphregion(fcolor(white)) legend(off) xlabel(0.05 "5%" 0.1 "10%" 0.15 "15%" 0.2 "20%" 0.25 "25%")

graph export "C:\Users\Redha CHABA\Documents\wp_git\cdhm\plots\marginal_plots\f3_rec_a.jpg", width(4000) replace


*** Figure 4: Marginal effect of recessions on riots as a function of the youth ratio ***

xi:xtreg ln2_domestic6 neggrowth_3 ratio_15_19_t  c.ratio_15_19_t#c.neggrowth_3  ln_gdppc i.year if inrange(year, 1950, 2018), fe cluster(ccode)


