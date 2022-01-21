

DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    idintegracao FK;
    cod FK;
    item FK;
    grupoitem FK;
BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idintegracao = '6-1';
    cod = '10';
    grupoitem = '1-1';
    

    FOR item IN 
        SELECT id_item FROM item 
            WHERE id_grupoitem = grupoitem
    LOOP
        idseq = NEXTVAL('gen_item_integracao');
        
        INSERT INTO ITEM_INTEGRACAO (ID_ITEM_INTEGRACAO, ID_EMPRESA, ID_SEQ, CH_EXCLUIDO, DS_USUARIO, ID_ITEM, ID_INTEGRACAO, DS_CODIGO)
        VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', item, idintegracao, cod);

    END LOOP;
END$$;