insert into IMPID(id_impid, id_empresa, id_seq, DS_APLICATIVO,DS_TABELA,OLD_ID,NEW_ID) 
	select (id_seq + 999999) || '-' || id_empresa, id_empresa, id_seq + 999999,  'EXCEL','ENTIDADE', NR_FANTASIA,ID_ENTIDADE 
	FROM ENTIDADE 
		WHERE CH_EXCLUIDO is null 
		and DS_CPFCNPJ is not null
