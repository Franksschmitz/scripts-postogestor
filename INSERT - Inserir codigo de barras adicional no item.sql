
DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    iditem FK;
    codbar FK;
BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    iditem = 'CODIGO_ITEM';
    codbar = 'CODIGO_BARRAS';



    idseq = NEXTVAL('gen_item_codbar');

    INSERT INTO ITEM_CODBAR (ID_ITEM_CODBAR, ID_EMPRESA, ID_SEQ, CH_EXCLUIDO, DS_USUARIO, ID_ITEM, NR_CODBAR)
    VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', iditem, codbar);


END$$;