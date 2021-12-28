
DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    iddoc FK;
    iddocitem FK;
    idimposto FK;
    idcst FK;
BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idimposto = '5-1';
    idcst = '153-1';


    FOR iddoc, iddocitem IN
        SELECT id_docfiscal,id_docfiscal_item FROM docfiscal_item
            WHERE id_item = '839-1'
            AND id_docfiscal_item NOT IN ( SELECT id_docfiscal_item FROM docfiscal_item_imposto 
                                            WHERE id_imposto = '5-1' 
                                            AND id_docfiscal_item IN ( SELECT id_docfiscal_item FROM docfiscal_item_imposto
                                                                        WHERE id_imposto = '4-1' ))
    LOOP 

        idseq = NEXTVAL('gen_docfiscal_item_imposto');

        INSERT INTO DOCFISCAL_ITEM_IMPOSTO (ID_DOCFISCAL_ITEM_IMPOSTO, ID_EMPRESA, ID_SEQ, CH_EXCLUIDO, DS_USUARIO, ID_DOCFISCAL, ID_DOCFISCAL_ITEM, ID_IMPOSTO, AL_IMPOSTO, ID_CST, PER_REDBASE, VL_BASE, VL_IMPOSTO, PER_MVA, PER_REDMARGEM, AL_INTER, CH_USACFGICMS, DS_TIPO_ST, CH_INCOUT, CH_INCSEG, CH_INCDESC, VL_DESON, CH_AJUSTE_MVA, DS_STECF, CH_INACRES, ID_BENEFICIOFISCAL, CH_INCFRETE)
        VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', iddoc, iddocitem, idimposto, '0', idcst, '0', '0', '0', '0', '0', '0', 'F', NULL, 'T', 'T', 'T', '0', 'F', NULL, 'T', NULL, 'T');

    END LOOP;

END$$;
