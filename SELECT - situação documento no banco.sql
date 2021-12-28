select 
	ch_sitnfe,
	nr_tentativa,
	dt_ult_tentativa,
	ds_motivo,
	ds_motivo_rej,
	cd_status,
	ch_modoemi,
	ch_cont_off,
	* 
from docfiscal_eletro 
where id_filial =:FILIAL
and id_docfiscal =:CODIGO_NOTA






