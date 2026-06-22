%let folder_include = /sasdata;
%include "&folder_include./Macro.sas";

%horario_atual_macros;
options nomprint;

%imprimir_log(Job_PBI_RECEPTIVO_&horario_inicial..txt, &folder_logs./Receptivo);

%mensagem (inicios);

%mensagem(Regra_de_Safra);
proc sql noprint;
	SELECT INT(YEAR(INTNX('day', TODAY(), -7))*100+MONTH(INTNX('day', TODAY(), 
		-7))) into :safra_final from sashelp.class;
quit;

proc sql noprint;
	SELECT INT(YEAR(INTNX('month', TODAY(), -13))*100+MONTH(INTNX('month', TODAY(), 
		-13))) into :partida_inicial from sashelp.class;
quit;

data _null_;
	data_final=mdy(mod(&safra_final., 100), 1, int(&safra_final./100));
	data_inicial1=intnx("month", data_final,  0, "begin");
	data_inicial2=intnx("month", data_final, -1, "begin");
	data_inicial3=intnx("month", data_final, -2, "begin");
	data_inicial4=intnx("month", data_final, -3, "begin");
	data_inicial5=intnx("month", data_final, -4, "begin");
	data_inicial6=intnx("month", data_final, -5, "begin");
	%ref_safrA_mes(data_inicial1, safra_inicial1);
	%ref_safrA_mes(data_inicial2, safra_inicial2);
	%ref_safrA_mes(data_inicial3, safra_inicial3);
	%ref_safrA_mes(data_inicial4, safra_inicial4);
	%ref_safrA_mes(data_inicial5, safra_inicial5);
	%ref_safrA_mes(data_inicial6, safra_inicial6);
	call symputx("safra_final1", safra_inicial1, "G");
	call symputx("safra_final2", safra_inicial2, "G");
	call symputx("safra_final3", safra_inicial3, "G");
	call symputx("safra_final4", safra_inicial4, "G");
	call symputx("safra_final5", safra_inicial5, "G");
	call symputx("safra_final6", safra_inicial6, "G");
run;

%PUT &partida_inicial.;

%PUT &safra_final1.;
%PUT &safra_final2.;
%PUT &safra_final3.;
%PUT &safra_final4.;
%PUT &safra_final5.;
%PUT &safra_final6.;


%mensagem(Selecao_de_colunas_B2C);
%LET COLUMN3_B2C = KEEP = 
USERNAME 							GRUPO_ATENDIMENTO 				FORNECEDOR 						PRODUTO_FINAL 
SEGMENTACAO_FUTURA 					TMA DOCUMENTO 					DOCUMENTO_NUM 					data_base 
flag_divida 						TMA 							CHAMADA 						flag_categoria_b_passivel 
flag_categoria_b_previa 					aging_max_total 				divida_total 					divida_apos_total 
fl_acordo_sistema_a 					fl_acordo_sistema_a_categoria_a 	fl_acordo_sistema_a_categoria_b 			fl_acordo_sistema_a_categoria_c 
fl_acordo_sistema_c 					fl_acordo_sistema_b 				divida_apos_CATEGORIA_A_SISTEMA_A 	divida_apos_CATEGORIA_B_SISTEMA_A 
divida_apos_CATEGORIA_B_SISTEMA_B 				divida_apos_CATEGORIA_C_SISTEMA_A 		divida_apos_CATEGORIA_C_SISTEMA_C 		divida_CATEGORIA_A_SISTEMA_A 
divida_CATEGORIA_B_SISTEMA_A 					divida_CATEGORIA_B_SISTEMA_B 				divida_CATEGORIA_C_SISTEMA_A 			divida_CATEGORIA_C_SISTEMA_C 
aging_max_apos_CATEGORIA_A_AMDOC 	aging_max_apos_CATEGORIA_B_SISTEMA_A 		aging_max_apos_CATEGORIA_B_SISTEMA_B 		aging_max_apos_CATEGORIA_C_SISTEMA_A 
aging_max_apos_CATEGORIA_C_SISTEMA_C 			aging_max_CATEGORIA_A_SISTEMA_A 	aging_max_CATEGORIA_B_SISTEMA_A 			aging_max_CATEGORIA_B_SISTEMA_B 
aging_max_CATEGORIA_C_SISTEMA_A 				aging_max_CATEGORIA_C_SISTEMA_C			fl_acordo_sistema_a_conv_s_log 	fl_acordo_sistema_a_categoria_b_s_log	
fl_acordo_sistema_a_categoria_c_s_log 		fl_acordo_sistema_a_s_log			fl_quebra_acordo_sisA_catA_s_log 	fl_quebra_acordo_sisA_catB_s_log 	
fl_quebra_acordo_sisA_catC_s_log 		fl_quebra_acordo_sisA_catA  		fl_quebra_acordo_sisA_catB  		fl_quebra_acordo_sisA_catC  
fl_quebra_acordo_sistema_c  			fl_quebra_acordo_sistema_b
RENAME=(flag_divida = QTD_DIVIDA) 
WHERE=(
GRUPO_ATENDIMENTO IN (
'C_PF_COM_COB_INATIVO'
, 'C_PF_HIB_CAC_SILVER'
, 'C_PF_HIB_CAC_PURPURA'
, 'C_PF_HIB_LAB_NEGOCIOS'
, 'C_PF_COM_SILVER_NEXT'
, 'F_PF_COM_GOLD'
, 'F_PF_HIB_SILVER_AV'
, 'M_PF_PURPURA_RECOVERY_PRE'
, 'F_PF_RET_PURPURA'
, 'F_PF_COM_CAC'
, 'F_PF_COB_GOLD_RECOVER'
, 'M_PF_COB_GOLD_RECOVER'
, 'M_PF_PURPURA_RECOVERY_PLN'
, 'M_PF_COM_GOLD'
, 'M_PF_COB_CAC'
, 'M_PF_HIB_SILVER_AV'
, 'M_PF_RET_PURPURA_NEXT'
, 'M_PF_RET_OC_SILVER_PURPURA_NEXT'
, 'M_PF_PURPURA_MIGRA_PRE_CTR_N2'
, 'M_PF_HIB_SILVER_NEXT'
, "F_PF_HIB_SILVER"
, "F_PF_HIB_SILVER_RECOVER"
, "C_PF_COM_GOLD_NEXT"
	)
);

%LET COLMNFIN_B2C = KEEP = GRUPO_ATENDIMENTO FORNECEDOR data_base PRODUTO_FINAL SEGMENTACAO_FUTURA CHAMADA
SAFRA DIA MES CLASS CARTEIRA_ENTRADA DCONCATENADO MCONCATENADO documento QTD_DIVIDA TMA DOCUMENTO
DIVIDA_ANTES DIVIDA_DEPOIS ACORDOS QUEBRAS aging_max_apos_total USERNAME POSSUI_DIVIDA AGING_REDUZIDO
DIVIDA_REDUZIDA DIVIDA_PAGA DIVIDA_NAO_PAGA DIVIDA_ANTES_S_RED DIVIDA_DEPOIS_S_RED;

%mensagem(Selecao_de_colunas_B2B);
%LET COLUMN3_B2B = KEEP = 
	GRUPO_ATENDIMENTO					FORNECEDOR						USERNAME					data_base	
	CHAMADA								DOCUMENTO						TMA							PRODUTO_FINAL		
	SEGMENTACAO_FUTURA					documento_num					PESSOA						divida_CATEGORIA_B_SISTEMA_B			
	divida_CATEGORIA_C_SISTEMA_C					divida_CATEGORIA_B_LEGADO				divida_NI_SAP				divida_NI_ATIS				
	divida_NI_MULTA_CONTRATUAL			divida_NI_ATELECOM				divida_NI_PLAT_DIG			divida_apos_CATEGORIA_B_SISTEMA_B		
	divida_apos_CATEGORIA_C_SISTEMA_C				divida_apos_CATEGORIA_B_LEGADO			divida_apos_NI_SAP			divida_apos_NI_ATIS			
	divida_apos_NI_MULTA_CONTRATUAL 	divida_apos_NI_ATELECOM			divida_apos_NI_PLAT_DIG		aging_max_CATEGORIA_B_SISTEMA_B		
	aging_max_CATEGORIA_C_SISTEMA_C				aging_max_CATEGORIA_B_LEGADO			aging_max_NI_SAP			aging_max_NI_ATIS			
	aging_max_NI_MULTA_CONTRATUAL		aging_max_NI_ATELECOM			aging_max_NI_PLAT_DIG		aging_max_apos_CATEGORIA_B_SISTEMA_B	
	aging_max_apos_CATEGORIA_C_SISTEMA_C			aging_max_apos_CATEGORIA_B_LEGADO		aging_max_apos_NI_SAP		aging_max_apos_NI_ATIS		
	aging_max_apos_NI_MULTA_CONTRATU	aging_max_apos_NI_ATELECOM		aging_max_apos_NI_PLAT_DIG	PESSOA
WHERE=(
GRUPO_ATENDIMENTO IN (
'F_PJ_COM_CAC',
'F_PJ_HIB_ONE',	
'F_PJ_HIB_PME',
'F_PJ_HIB_TOP',
'M_PJ_HIB_ONE',
'M_PJ_HIB_PME',	
'M_PJ_HIB_TOP',
	)
);
%LET COLMNFIN_B2B = KEEP = GRUPO_ATENDIMENTO FORNECEDOR data_base PRODUTO_FINAL SEGMENTACAO_FUTURA CHAMADA
SAFRA DIA MES CARTEIRA_ENTRADA DCONCATENADO MCONCATENADO documento TMA DOCUMENTO PESSOA
DIVIDA_ANTES DIVIDA_DEPOIS aging_max_apos_total USERNAME POSSUI_DIVIDA AGING_REDUZIDO
DIVIDA_REDUZIDA DIVIDA_PAGA DIVIDA_NAO_PAGA DIVIDA_ANTES_S_RED DIVIDA_DEPOIS_S_RED;

%LET COLUMN_0800 = KEEP = documento_num data_base NM_AGENTE NR_ACORDO TP_CLIENTE SEGMENTACAO
divida_CATEGORIA_B_SISTEMA_B  divida_CATEGORIA_B_LEGADO  divida_CATEGORIA_C_SISTEMA_C divida_NI_ATIS divida_NI_SAP divida_NI_MULTA_CONTRATUAL 
divida_NI_ATELECOM divida_NI_PLAT_DIG divida_apos_CATEGORIA_B_SISTEMA_B divida_apos_CATEGORIA_B_LEGADO divida_apos_CATEGORIA_C_SISTEMA_C 
divida_apos_NI_ATIS divida_apos_NI_SAP divida_apos_NI_MULTA_CONTRATUAL divida_apos_NI_ATELECOM divida_apos_NI_PLAT_DIG 
aging_max_CATEGORIA_B_SISTEMA_B aging_max_CATEGORIA_B_LEGADO aging_max_CATEGORIA_C_SISTEMA_C aging_max_NI_ATIS aging_max_NI_SAP aging_max_NI_MULTA_CONTRATUAL 
aging_max_NI_ATELECOM aging_max_NI_PLAT_DIG aging_max_apos_CATEGORIA_B_SISTEMA_B aging_max_apos_CATEGORIA_B_LEGADO aging_max_apos_CATEGORIA_C_SISTEMA_C 
aging_max_apos_NI_ATIS aging_max_apos_NI_SAP aging_max_apos_NI_MULTA_CONTRATU aging_max_apos_NI_ATELECOM aging_max_apos_NI_PLAT_DIG
RENAME=(NM_AGENTE = USERNAME);
 
%LET COLMNFIN_0800 = KEEP = 
data_base SEGMENTACAO SAFRA DIA MES CARTEIRA_ENTRADA DCONCATENADO MCONCATENADO documento_num
DIVIDA_ANTES DIVIDA_DEPOIS aging_max_apos_total USERNAME POSSUI_DIVIDA AGING_REDUZIDO
DIVIDA_REDUZIDA DIVIDA_PAGA DIVIDA_NAO_PAGA DIVIDA_ANTES_S_RED DIVIDA_DEPOIS_S_RED;

%B2C_Consolidar_Tabelas;
%B2C_Aplica_regra_Unique_Diario;
%B2C_Aplica_regra_Esforco_Diario;
%B2C_Aplica_Regra_Esforco_Mensal;
%B2C_Aplica_Regra_Unique_Mensal;
%B2C_Agrupa_Sumariza_Tabelas;
%B2C_Consolida_UniqueEsforco;
%B2C_Regra_Data_consolidacao;
/*----------------------------------------------------------------------------------------------------------------------*/
%B2B_Consolidar_Tabelas;
%B2B_Aplica_regra_Unique_Diario;
%B2B_Aplica_regra_Esforco_Diario;
%B2B_Aplica_Regra_Esforco_Mensal;
%B2B_Aplica_Regra_Unique_Mensal;
%B2B_Agrupa_Sumariza_Tabelas;
%B2B_Consolida_UniqueEsforco;
%B2B_Regra_Data_consolidacao;
/*----------------------------------------------------------------------------------------------------------------------*/
%A0800_Consolidar_Tabelas;
%A0800_regra_Unique_Diario;
%A0800_regra_Esforco_Diario;
%A0800_Regra_Esforco_Mensal;
%A0800_Regra_Unique_Mensal;
%A0800_Agrupa_Sumariza_Tabelas;
%A0800_Consolida_UniqueEsforco;
%A0800_Regra_Data_consolidacao;
/*----------------------------------------------------------------------------------------------------------------------*/
%tb_final;

%imprimir_log_final;