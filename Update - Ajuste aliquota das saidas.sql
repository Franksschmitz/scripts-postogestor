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
    l_id_item FK;
    l_id_natoper FK;
    l_data_ini DATE;
    l_data_fim DATE;    
    l_al_imposto NUMERIC(14,4);        
BEGIN
	    
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa_lo;
	perform set_config('myvars.ID_EMPRESA', l_id_empresa_lo::text, true);    

    l_id_filial = 2; -- Informar a ID_EMPRESA que deseja reprocessar
    l_id_cfgfiscal = ''; -- Informar a ID_CFGFISCAL base
    l_id_imposto = ''; -- Informar a ID_IMPOSTO que deseja reprocessar
    l_data_ini = ''; -- 'yyyy-mm-dd'
    l_data_fim = ''; -- 'yyyy-mm-dd'
    
	-- PARA UTILIZAR ESSE COMANDO EM AJUSTES DE PIS E COFINS, NÃO PODE ESQUECER DE REMOVER O ULTIMO UPDATE REFERENTE AO CFOP
	
    FOR l_al_imposto, l_id_cst, l_id_natoper IN 
        SELECT cfi.AL_IMPOSTO, cfi.ID_CST, cfi.ID_NATOPER
        FROM CFGFISCAL_IMPOSTO cfi 
        WHERE cfi.CH_EXCLUIDO IS NULL AND 
              cfi.ID_CFGFISCAL = l_id_cfgfiscal AND
              cfi.ID_IMPOSTO = l_id_imposto
              --AND cfi.ID_ESTADO_DESTINO = cfi.ID_ESTADO_ORIGEM
        LIMIT 1
    LOOP 

        FOR l_id_item IN 
            SELECT ID_ITEM FROM ITEM_CFGFISCAL
            WHERE ID_CFGFISCAL = l_id_cfgfiscal
        LOOP

            UPDATE DOCFISCAL_ITEM_IMPOSTO dii SET                
                VL_BASE = 0,
                ID_CST = l_id_cst,
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
                        ) * l_al_imposto / 100 AS NUMERIC(14,4)
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
                VL_BASE = 0
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

	-- PARA UTILIZAR ESSE COMANDO EM AJUSTES DE PIS E COFINS, NÃO PODE ESQUECER DE REMOVER O ULTIMO UPDATE REFERENTE AO CFOP

            UPDATE DOCFISCAL_ITEM di SET
                ID_NATOPER = l_id_natoper
            WHERE di.CH_EXCLUIDO IS NULL AND
                  di.ID_ITEM = l_id_item AND
                  di.ID_EMPRESA = l_id_filial AND 
                  di.ID_DOCFISCAL IN (
                    SELECT ID_DOCFISCAL FROM DOCFISCAL
                    WHERE DT_EMISSA BETWEEN l_data_ini AND l_data_fim
                  );

        END LOOP;
    END LOOP;
END$$;