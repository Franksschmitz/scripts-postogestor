/* CHAMAR FUNCAO */ 

select public.ajusta_aliquota_icms_por_cst(:aliquota_icms, :cst, :grupoitem);

/* DEPOIS QUE EXECUTAR SOLICITARÁ PREENCHIMENTO DOS CAMPOS */
-- COMO PREENCHER:
-- DIGITAR ALIQUOTAS NESTE FORMATO: 0.00
-- DIGITAR CST DESTA FORMA: {"010","060"}
-- DIGITAR CST DESTA FORMA: {"84-1","85-1"}

