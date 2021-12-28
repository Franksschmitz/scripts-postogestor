

DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    identidade FK;
    idpolitica FK;
BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idpolitica = 'CODIGO_POLITICA';
    identidade = 'CODIGO_ENTIDADE';



    idseq = NEXTVAL('gen_regrapreco_entidade');

    INSERT INTO REGRAPRECO_ENTIDADE (ID_REGRAPRECO_ENTIDADE, ID_EMPRESA, ID_SEQ, DS_USUARIO, CH_EXCLUIDO, ID_REGRAPRECO, ID_ENTIDADE)
    VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, 'POSTGRES', NULL, idpolitica, identidade);


END$$;