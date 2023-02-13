*Calculating indirect subsidies for policy year

*****FUEL SUBSIDIES*****

import excel using "$xls_tool", sheet(subsidy)  first clear
	foreach var in electr_cost gas_subs {
	    global `var' = `var'[1]
	}
	
	drop if missing(electr_cutoff) | electr_cutoff == 0
		global electr_brackets = _N
		forvalues i = 1 / $electr_brackets {
			global electr_cutoff_`i' = electr_cutoff[`i']
			global electr_tariff_`i' = electr_tariff[`i']
		}


*Fuel indirect effects
import excel using "$xls_tool", sheet(IO) first clear 
drop sector_name VAT*

isid sector
mvencode sect_*, mv(0) override // make sure that none of the coefficient is missing
gen dp = $gas_subs * 0.3 if sector==4 //Price shock: Subsidy removal on Energy sector. We assume that share of gas in the energy sector is 30%.
	replace dp = 0 if mi(dp)
gen fixed = (dp != 0) // Government controls prices on energy sector 
	assert dp == 0 if fixed == 0

costpush sect_*, fixed(fixed) price(dp) genptot(sub_gas_tot_PY) genpind(sub_gas_ind_PY) fix
keep sector sub_gas_ind_PY

isid sector
tempfile ind_effect_gas_PY
save `ind_effect_gas_PY', replace

*Fuel Direct effects
use "${data}\02.intermediate\Example_FiscalSim_indirect_taxes_data_long.dta", clear
merge m:1 sector using `ind_effect_gas_PY', nogen assert(match using) keep(match)

gen gas_sub_dir = exp_gross_PY * ${gas_subs} if exp_type == 90
	replace gas_sub_dir = 0 if mi(gas_sub_dir)
gen gas_sub_ind = exp_gross_PY * sub_gas_ind_PY

collapse (sum) gas_sub_dir gas_sub_ind, by(hh_id) //HH-level dataset with Fuel subsidies estimations
isid hh_id

label var gas_sub_dir "Gas subsidy (direct effects)"
label var gas_sub_ind "Gas subsidy (indirect effects)"

tempfile gas_subsidies_data
save `gas_subsidies_data'

*****ELECTRICITY SUBSIDIES*****



use "${data}\01.pre-simulation\Example_FiscalSim_electr_data.dta", clear

* we assume that the industrial consumers pay full electricity tariff, that is why there is no indirect effect. We estimate the direct effect households only

gen electr_exp_PY = 0
global electr_cutoff_0 = 0
forvalues i = 1 / $electr_brackets {
	local j = `i' - 1

		gen electr_exp_PY_`i' = 0 if electr_cons < ${electr_cutoff_`j'}
		replace electr_exp_PY_`i' = (electr_cons - ${electr_cutoff_`j'}) * ${electr_tariff_`i'} if electr_cons >= ${electr_cutoff_`j'} & electr_cons < ${electr_cutoff_`i'}
		replace electr_exp_PY_`i' = (${electr_cutoff_`i'} - ${electr_cutoff_`j'}) * ${electr_tariff_`i'} if electr_cons >= ${electr_cutoff_`i'}

		replace electr_exp_PY = electr_exp_PY + electr_exp_PY_`i'
		drop electr_exp_PY_`i'
	}

gen electr_sub = ${electr_cost} * electr_cons - electr_exp_PY
	
if $SY_consistency_check == 1 { 
	assert abs(electr_exp_PY - electr_exp_SY) < 10 ^ (-5)
}

label variable electr_sub "Electricity subsidy"


*Merge with Gas Subsidies dataset
merge 1:1 hh_id using `gas_subsidies_data', nogen assert(match)

keep hh_id ${indirect_subsidies} 
mvencode ${indirect_subsidies}, mv(0) override 

isid hh_id 
save "${data}\02.intermediate\Example_FiscalSim_indirect_subsidies_data.dta", replace