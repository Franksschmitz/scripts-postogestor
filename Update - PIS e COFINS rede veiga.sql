
DO $$
DECLARE
    l_id_empresa_lo INTEGER;
	l_id_filial INTEGER;
    l_id_cfgfiscal FK;    
    l_id_imposto FK;     
    l_id_cst FK;
    l_id_item FK;
    l_id_natoper FK;
    l_doc FK;
    l_doc_item FK;
    l_data_ini DATE;
    l_data_fim DATE;    
    l_al_imposto NUMERIC(14,4);        
BEGIN
	    
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa_lo;
	perform set_config('myvars.ID_EMPRESA', l_id_empresa_lo::text, true);    

    l_id_filial = 5; -- Informar a ID_EMPRESA que deseja reprocessar
    l_id_imposto = '4-1'; -- Informar a ID_IMPOSTO que deseja reprocessar
    l_id_cst = '118-1';
    l_al_imposto = '0';
    l_data_ini = '2020-12-01'; -- 'yyyy-mm-dd'
    l_data_fim = '2021-01-29'; -- 'yyyy-mm-dd'
    
	FOR l_doc, l_doc_item in
    SELECT 
        a.id_docfiscal, a.id_docfiscal_item 
    FROM DOCFISCAL_ITEM_IMPOSTO a
    LEFT JOIN DOCFISCAL b ON (a.id_docfiscal = b.id_docfiscal)
        WHERE a.id_imposto = l_id_imposto
        AND a.id_cst = l_id_cst
        AND b.id_filial = l_id_filial
        AND b.dt_emissa between l_data_ini AND l_data_fim

    LOOP 

            UPDATE DOCFISCAL_ITEM_IMPOSTO dii SET                
                VL_BASE = 0,
                AL_IMPOSTO = l_al_imposto,
                VL_IMPOSTO = 0
            WHERE dii.ID_IMPOSTO = l_id_imposto AND                                    
                  dii.ID_CST = l_id_cst AND
                  dii.ID_DOCFISCAL_ITEM = l_doc_item
                ;

            UPDATE DOCFISCAL_IMPOSTO dim SET
                VL_IMPOSTO = 0,
                VL_BASE = 0
            WHERE dim.ID_IMPOSTO = l_id_imposto AND
                  dim.ID_EMPRESA = l_id_filial AND
                  dim.ID_DOCFISCAL = l_doc
                  ;

    END LOOP;
END$$;