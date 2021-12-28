

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



    idseq = NEXTVAL('gen_regracomiss_apl');

    INSERT INTO REGRACOMISS_APL (ID_REGRACOMISS_APL, ID_EMPRESA, ID_SEQ, DS_USUARIO, CH_EXCLUIDO,  ID_REGRACOMISS, CH_TIPO, ID_ITEM, ID_GRUPOITEM, ID_ENTIDADE, CH_ATIVO, CH_APLICAR, VL_FAT, VL_LIQ, CH_BASE)
    VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, 'POSTGRES', NULL, idpolitica, 'E', NULL, NULL, identidade, 'T', 'P', '0', '0', 'T');


END$$;