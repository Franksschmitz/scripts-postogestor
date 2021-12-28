
DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    idtipopreco FK;
    iditem FK;
    idbico FK;
    idreajuste FK;
BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idtipopreco = '1-1';
    iditem = '962-';
    idreajuste = (  select id_reajuste from reajuste 
                    where ch_excluido is null 
                    and id_seq in ( select max(id_seq) from reajuste where ch_excluido is null));

    FOR idbico IN
        select id_bico from bico 
        where id_item = '962-1' 
        and ch_excluido is null 
        and ch_ativo = 'T'
    LOOP
    
        idseq = NEXTVAL('gen_reajuste_det');

        INSERT INTO REAJUSTE_DET (ID_REAJUSTE_DET, ID_EMPRESA, ID_SEQ, CH_EXCLUIDO, DS_USUARIO, ID_ITEM, ID_BICO, VL_PRECO, VL_PRECO_NOV, PER_MARGEM, PER_MARGEM_NOV, VL_PRECOBASE, CH_REM_PREDIF, ID_REAJUSTE, VL_PRECOBASE_ANT, ID_FILIAL, ID_TIPOPRECO, DH_REAJUSTE, CH_TIPO)
        VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', '962-1', idbico, '5.298', '5.299', '12.0558', '12.077', '4.728', NULL, idreajuste, '4.728', '1', '1-1', '2021-07-15 15:38:35', 'F');

    END LOOP;
END$$;