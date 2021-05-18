set more off
global in "C:\Users\grp13\OneDrive\Documentos\IPEA Pedidos\Bases atualizadas"
global out "C:\Users\grp13\OneDrive\Documentos\IPEA Pedidos\pedido_kiko"
clear 

	local anos "2013 2016 2019"
	foreach years of local anos {
	use v1023 vd4019 vd3004 vd4009 informal3 pos_ocup uf ocup ano trimestre peso pessoasid salmt_habt ///
	using "${in}\pnadc_`years'_def.dta", clear

preserve
gen escolaridade = 1 if (vd3004==1|vd3004==2|vd3004==3|vd3004==4)
replace escolaridade = 2 if vd3004==5
replace escolaridade = 3 if (vd3004==6|vd3004==7)
gen publico = 0 if (vd4009 == 1 | vd4009 == 2 | vd4009 == 3 | vd4009 == 4 | vd4009 == 8 | vd4009 == 9 | vd4009 == 10)
replace publico = 1 if (vd4009 == 5 | vd4009 == 6 | vd4009 == 7)

collapse (sum) ocup (mean) salmt_habt [iw=peso], by (ano trimestre uf escolaridade informal3 publico)
export excel using "${out}\pedido_kiko_dez2020.xlsx", sheet("`years'_interacao") sheetmodify cell(B2) firstrow(variables) nolabel
restore

}
