DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    identidade FK;
    

BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    FOR identidade IN
        SELECT id_entidade FROM entidade 
            WHERE id_grupoentidade = 'CODIGO_GRUPO' -- INFORMAR O GRUPO DE ENTIDADE DESEJADO
            AND ch_ativo = 'T' 
            AND ch_excluido IS NULL
    
    LOOP

        idseq = NEXTVAL('gen_entidade_cred');

        INSERT INTO ENTIDADE_CRED (ID_ENTIDADE_CRED, ID_EMPRESA, ID_SEQ, DS_USUARIO, CH_EXCLUIDO, ID_ENTIDADE, CH_TIPO, ID_FILIAL, CH_SITCRE, VL_LIMCRE, CH_ESPECIE, ID_ESPECIE, DS_MOTIVO) 
        VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, 'POSTGRES', NULL, identidade, 'G', NULL, 'A', '1', 'F', NULL, NULL);

    END LOOP;
END$$;