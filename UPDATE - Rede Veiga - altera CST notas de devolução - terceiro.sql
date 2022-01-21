/**
* EXECUTAR: CODIGO SQL
* FUNÇÃO DO SCRIPT: SETA ALIQUOTA E CST DA CONFIGURAÇÃO FISCAL DE TERCEIROS EM DOCUMENTOS FISCAIS
*   EMITIDOS COM OS CFOPS FILTRADOS
*/

DO $$DECLARE
    l_id_empresa_lo INTEGER;
	l_id_filial INTEGER;
    l_id_cfg FK;
    l_id_cfgfiscal TEXT[];    
    l_id_imposto FK;     
    l_id_cst FK;
    l_id_item FK;    
    l_cfop TEXT[];
    l_data_ini DATE;
    l_data_fim DATE;    
    l_al_imposto NUMERIC(14,4);            
    l_id_docfiscal FK;
    l_id_docfiscal_item FK;
BEGIN
	    
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa_lo;
	perform set_config('myvars.ID_EMPRESA', l_id_empresa_lo::text, true);    
    
    l_id_cfgfiscal      = ARRAY['35-2','38-2','39-2','40-2','41-2']; -- Informar as ID_CFGFISCAL de TERCEIRO. Ex: ARRAY['1-1','2-1'];
    l_cfop              = ARRAY['1411','2411','1662','2662','1202']; -- Informar os CFOP's que deseja reprocessar
    l_id_filial         = 1; -- Informar a ID_EMPRESA que deseja reprocessar    
    l_id_imposto        = '5-1'; -- Informar a ID_IMPOSTO que deseja reprocessar: 5-1 é COFINS e 4-1 é PIS
    l_data_ini          = '01/05/2021'; -- 'dd/mm/aaaa'
    l_data_fim          = '31/05/2021'; -- 'dd/mm/aaaa'
    
    FOR l_al_imposto, l_id_cst, l_id_cfg IN 
        SELECT COALESCE(cfi.AL_IMPOSTO, 0) AL_IMPOSTO, cfi.ID_CST, cfi.ID_CFGFISCAL
        FROM CFGFISCAL_IMPTER cfi 
        WHERE cfi.CH_EXCLUIDO IS NULL AND 
            cfi.ID_CFGFISCAL = ANY(l_id_cfgfiscal) AND
            cfi.ID_IMPOSTO = l_id_imposto         
    LOOP 

        FOR l_id_item IN 
            SELECT ID_ITEM FROM ITEM_CFGFISCAL
            WHERE ID_CFGFISCAL = l_id_cfg
        LOOP

            FOR l_id_docfiscal, l_id_docfiscal_item IN 
                SELECT di.ID_DOCFISCAL, di.ID_DOCFISCAL_ITEM 
                FROM DOCFISCAL_ITEM di
                INNER JOIN DOCFISCAL d ON (di.ID_DOCFISCAL = d.ID_DOCFISCAL)
                WHERE di.CH_EXCLUIDO IS NULL AND
                    d.ID_FILIAL = l_id_filial AND
                    di.ID_ITEM = l_id_item AND
                    d.DT_EMISSA BETWEEN l_data_ini AND l_data_fim AND 
                    di.ID_NATOPER IN (SELECT ID_NATOPER FROM NATOPER WHERE NR_NATOPER = ANY(l_cfop)) 
            LOOP             

                UPDATE DOCFISCAL_ITEM_IMPOSTO dii SET                
                    VL_BASE = (
                        CASE
                            WHEN (VL_BASE <= 0) THEN (
                                SELECT SUM(sdi.VL_TOTAL)
                                FROM DOCFISCAL_ITEM sdi 
                                WHERE sdi.ID_DOCFISCAL_ITEM = dii.ID_DOCFISCAL_ITEM
                            )
                            ELSE VL_BASE
                        END
                    ),
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
                    dii.ID_DOCFISCAL_ITEM = l_id_docfiscal_item;                    

                UPDATE DOCFISCAL_IMPOSTO dim SET
                    VL_IMPOSTO = (
                        SELECT SUM(sdii.VL_IMPOSTO) 
                        FROM DOCFISCAL_ITEM_IMPOSTO sdii 
                        WHERE sdii.ID_DOCFISCAL = dim.ID_DOCFISCAL
                        AND sdii.ID_IMPOSTO = l_id_imposto                    
                    ),
                    VL_BASE = (
                        SELECT SUM(sdii.VL_BASE) 
                        FROM DOCFISCAL_ITEM_IMPOSTO sdii 
                        WHERE sdii.ID_DOCFISCAL = dim.ID_DOCFISCAL 
                        AND sdii.ID_IMPOSTO = l_id_imposto
                    )
                WHERE dim.ID_IMPOSTO = l_id_imposto AND
                    dim.ID_DOCFISCAL = l_id_docfiscal;
                    
            END LOOP;             
        END LOOP;
    END LOOP;
END$$;
