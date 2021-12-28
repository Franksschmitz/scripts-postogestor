DO $$
DECLARE
    empresa_lo INTEGER;
    idcartao FK;
    dsent VARCHAR(100);
    ident FK;
BEGIN
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    FOR idcartao, ident, dsent IN
        SELECT 
            a.id_cartao, 
            a.id_entidade, 
            b.ds_razao 
        FROM cartao a
        LEFT JOIN entidade b ON a.id_entidade = b.id_entidade
            WHERE a.ds_cartao IS NULL
            AND a.ch_excluido IS NULL
            AND a.id_entidade IS NOT NULL
            AND a.ch_excluido IS NULL
            AND a.ch_ativo = 'T'

    LOOP

        UPDATE cartao SET ds_cartao = dsent
            WHERE id_cartao = idcartao
            AND ds_cartao IS NULL
            AND id_entidade IS NOT NULL;
    END LOOP;
END$$;