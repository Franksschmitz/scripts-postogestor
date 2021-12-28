

DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    idintegracao FK;
    cod FK;
    item FK;
BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idintegracao = '5-2';
    cod = '10';
    

    FOR item IN 
        select id_item from item where id_grupoitem = '5-1'
    LOOP
        idseq = NEXTVAL('gen_item_integracao');
        
        INSERT INTO ITEM_INTEGRACAO (ID_ITEM_INTEGRACAO, ID_EMPRESA, ID_SEQ, CH_EXCLUIDO, DS_USUARIO, ID_ITEM, ID_INTEGRACAO, DS_CODIGO)
        VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', item, idintegracao, cod);

    END LOOP;
END$$;