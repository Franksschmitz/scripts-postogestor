
DO $$
DECLARE 
    empresa_lo INTEGER;
    idseq BIGINT;
    idintegracao FK;
    idplano FK;
    dscod INTEGER;

BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idintegracao = '3-1';
    dscod = '504';

    FOR idplano IN
        SELECT id_planoconta FROM planoconta
            WHERE id_pai IN ('737-1','882-2','744-1','773-1','778-1','787-1')
            AND ch_ativo = 'T'
            AND ch_excluido IS NULL 

    LOOP

        idseq = NEXTVAL('gen_planoconta_integracao');

        INSERT INTO planoconta_integracao (id_planoconta_integracao, id_empresa, id_seq, ch_excluido, ds_usuario, id_planoconta, id_integracao, ds_codigo, ch_tipo, id_filial, id_natconta, ch_tipoconta, nr_nivelconta, id_contaanalit, ds_contaanalit, nr_conta_ref)
        VALUES (idseq || '-' || empresa_lo, empresa_lo, idseq, NULL, 'POSTGRES', idplano, idintegracao, dscod, 'G', NULL, '01', 'S', NULL, NULL, NULL, NULL);

    END LOOP;
END$$;