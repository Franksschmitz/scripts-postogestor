
DO $$DECLARE
    l_id_empresa_lo INTEGER;
	l_id_filial INTEGER;
    l_id_cfgfiscal FK; 
	l_id_cfop FK; 
	l_id_imposto FK;	
    l_id_item FK;
    l_data_ini DATE;
    l_data_fim DATE;    
       
BEGIN
	    
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa_lo;
	perform set_config('myvars.ID_EMPRESA', l_id_empresa_lo::text, true);    
    
    l_id_filial = 2; 
    l_id_cfgfiscal = '26-1'; 
    l_id_imposto = '1-1';   
    l_data_ini = '2020-09-01'; 
    l_data_fim = '2020-10-20';
	
	
	for l_id_item in
	    select id_item from item_cfgfiscal
		where id_cfgfiscal = l_id_cfgfiscal
	loop
	
		
		for l_id_cfop in
			select id_natoper from cfgfiscal_imposto
			where id_imposto = l_id_imposto
			and id_estado_destino is null
			and id_cfgfiscal in ( select id_cfgfiscal from item_cfgfiscal 
			                      where id_item = l_id_item and ch_tipocfg = 'P' )
		    limit 1
		loop
		
				update docfiscal_item di set id_natoper = l_id_cfop
				where di.ch_excluido is null
				and di.id_item = l_id_item
				and di.id_natoper is null
				and di.id_empresa = l_id_filial
				and id_docfiscal in (
										select id_docfiscal from docfiscal
										where dt_emissa between l_data_ini and l_data_fim 
										 										 
																				 );
				
		END LOOP;		  
    END LOOP;
END$$;