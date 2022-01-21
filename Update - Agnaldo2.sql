/**
* EXECUTAR: CODIGO SQL
* FUNÇÃO DO SCRIPT: SETAR CONFIG FISCAL ATUAL NOS DOCUMENTOS FISCAIS FILTRADOS
*/

	-- PARA UTILIZAR ESSE COMANDO EM AJUSTES DE PIS E COFINS, NÃO PODE ESQUECER DE REMOVER O ULTIMO UPDATE REFERENTE AO CFOP

DO $$DECLARE
    l_id_empresa_lo INTEGER;
	l_id_filial INTEGER;
    l_id_cfgfiscal FK;    
    l_id_imposto FK;     
    l_id_cst FK;
	l_vl_base NUMERIC(14,2);
    l_id_item FK;
    l_id_natoper FK;
    l_data_ini DATE;
    l_data_fim DATE;    
    l_al_imposto NUMERIC(14,2);        
BEGIN
	    
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa_lo;
	perform set_config('myvars.ID_EMPRESA', l_id_empresa_lo::text, true);    

    l_id_filial = 4;
    l_id_cfgfiscal = '22-1';
    l_id_imposto = '5-1';
	l_al_imposto = '3';
    l_data_ini = '2020-09-01';
    l_data_fim = '2020-09-30';
    
	
    FOR l_id_cst IN 
        SELECT cfi.ID_CST, cfi.ID_NATOPER
        FROM CFGFISCAL_IMPOSTO cfi 
        WHERE cfi.CH_EXCLUIDO IS NULL AND 
              cfi.ID_CFGFISCAL = l_id_cfgfiscal AND
              cfi.ID_IMPOSTO = l_id_imposto
        LIMIT 1
    LOOP 

        FOR l_id_item IN 
            SELECT ID_ITEM FROM ITEM_CFGFISCAL
            WHERE ID_CFGFISCAL = l_id_cfgfiscal
        LOOP
		
		/*	FOR l_vl_base IN
				SELECT VL_TOTAL FROM DOCFISCAL_ITEM
				WHERE ID_ITEM = l_id_item
				AND ID_DOCFISCAL IN ( 
				                       SELECT ID_DOCFISCAL FROM DOCFISCAL 
									   WHERE DT_EMISSA BETWEEN l_data_ini and l_data_fim
                                       AND ID_FILIAL = l_id_filial
								)
			LOOP  */

            UPDATE DOCFISCAL_ITEM_IMPOSTO dii SET                
                VL_BASE = l_vl_base,
                AL_IMPOSTO = l_al_imposto,
                VL_IMPOSTO = (
                    CAST((
                        CASE
                            WHEN (VL_BASE <= 0) THEN (
														SELECT SUM(sdi.VL_TOTAL)
														FROM DOCFISCAL_ITEM sdi 
														WHERE sdi.ID_DOCFISCAL_ITEM = dii.ID_DOCFISCAL_ITEM
                            )
                            ELSE VL_BASE
                        END
                        ) * l_al_imposto / 100 AS NUMERIC(14,2)
                    )
                )
            WHERE dii.ID_IMPOSTO = l_id_imposto AND                                    
                  dii.ID_CST <> l_id_cst AND
                  dii.ID_DOCFISCAL_ITEM IN (
                    SELECT di.ID_DOCFISCAL_ITEM 
                    FROM DOCFISCAL_ITEM di                  
                    WHERE di.CH_EXCLUIDO IS NULL AND
                          di.ID_EMPRESA = l_id_filial AND
                          di.ID_ITEM = l_id_item AND
                          di.ID_DOCFISCAL IN (
												SELECT ID_DOCFISCAL FROM DOCFISCAL
												WHERE DT_EMISSA BETWEEN l_data_ini AND l_data_fim
                          )
                );

            UPDATE DOCFISCAL_IMPOSTO dim SET
                VL_IMPOSTO = (
                    SELECT SUM(sdii.VL_IMPOSTO) 
                    FROM DOCFISCAL_ITEM_IMPOSTO sdii 
                    WHERE sdii.ID_DOCFISCAL = dim.ID_DOCFISCAL
                    AND sdii.ID_IMPOSTO = l_id_imposto                    
                ),
                VL_BASE = l_vl_base
            WHERE dim.ID_IMPOSTO = l_id_imposto AND
                  dim.ID_EMPRESA = l_id_filial AND
                  dim.ID_DOCFISCAL IN (
										SELECT di.ID_DOCFISCAL 
										FROM DOCFISCAL_ITEM di
										WHERE di.CH_EXCLUIDO IS NULL AND
											di.ID_ITEM = l_id_item AND
											di.ID_EMPRESA = l_id_filial AND
											di.ID_DOCFISCAL IN (
																	SELECT ID_DOCFISCAL FROM DOCFISCAL
																	WHERE DT_EMISSA BETWEEN l_data_ini AND l_data_fim 
                          )
                  );
 
            --END LOOP;
        END LOOP;
    END LOOP;
END$$;