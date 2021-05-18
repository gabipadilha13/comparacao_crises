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


/*Posicao na ocupacao

/*variavel pos_ocup (vd4009)
com cart=1 
sem cart=2
militar/estat=3
empregador=4
conta propria=5
nao remunerado=6 */


gen pos_ocup=.
replace pos_ocup=1 if (vd4009==1| vd4009==3 | vd4009==5)
replace pos_ocup=2 if (vd4009==2| vd4009==4 | vd4009==6)
replace pos_ocup=3 if vd4009==7
replace pos_ocup=4 if vd4009==8
replace pos_ocup=5 if vd4009==9
replace pos_ocup=6 if vd4009==10

tab  pos_ocup, gen (s)
rename s1 com_cart
rename s2 sem_cart
rename s3 militar_estat
rename s4 empregador
rename s5 conta_propria
rename s6 nao_rem

****CONTRIBUICAO NA PREVIDENCIA;
gen prev=.
replace prev=1 if vd4012==1
replace prev=0 if vd4012==2

*** CNPJ
gen cnpj=cond(v4019==1,1,0) if v4019!=.
	
***** Conta propria que contribui para previdencia;
gen cp_prev=1 if conta_propria==1 & prev==1
replace cp_prev=0 if conta_propria==1 & prev==0

***** Empregador que contribui para previdencia;
gen empregador_prev=1 if empregador==1 & prev==1
replace empregador_prev=0 if empregador==1 & prev==0

**VARIAVEL INFORMAL3 (trabalhadores sem carteira + conta-propria s/prev + empregador s/prev + nao remunerados)/ocupados;
gen informal3=0 if ocup==1
replace informal3=1 if (sem_cart==1 | cp_prev==0 | empregador_prev==0 | nao_rem==1)*/


collapse (sum) ocup (mean) salmt_habt [iw=peso], by (ano trimestre uf escolaridade informal3 publico)
export excel using "${out}\pedido_kiko_dez2020.xlsx", sheet("`years'_interacao") sheetmodify cell(B2) firstrow(variables) nolabel
restore

}
