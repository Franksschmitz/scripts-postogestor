DO $$
DECLARE
    empresa_lo INTEGER;
    idregra FK;
    idregraent FK;
    ident FK;
BEGIN
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    FOR idregra, idregraent, ident IN
        SELECT
            lc.cod_regra,
            re.id_regrapreco_entidade,
            re.id_entidade
        FROM (
                SELECT
                    x.cod_regra,
                    x.nome_regra,
                    y.id_regrapreco_entidade,
                    y.id_entidade,
                    z.ds_entidade
                FROM (
                        SELECT 
                            a.id_regrapreco AS COD_REGRA,
                            b.ds_regrapreco AS NOME_REGRA,
                            COUNT(a.id_regrapreco) AS QTD
                        FROM regrapreco_entidade a
                        LEFT JOIN regrapreco b ON (a.id_regrapreco = b.id_regrapreco)
                            WHERE a.ch_excluido IS NULL
                            AND b.ch_excluido IS NULL
                            AND b.ch_ativo = 'T'                      
                        GROUP BY 1,2
                        HAVING COUNT(1) > 1
                ) x
                LEFT JOIN regrapreco_entidade y ON (x.cod_regra = y.id_regrapreco)
                LEFT JOIN entidade z ON (y.id_entidade = z.id_entidade)
                    WHERE y.ch_excluido IS NULL
                    AND z.ch_excluido IS NULL
                    AND z.ch_ativo = 'T'
                    AND x.nome_regra LIKE ('%' || z.ds_entidade || '%')
                ORDER BY 2,5

        ) lc
        LEFT JOIN regrapreco_entidade re ON (lc.cod_regra = re.id_regrapreco)
        LEFT JOIN entidade gb ON (re.id_entidade = gb.id_entidade)
            WHERE re.id_regrapreco = lc.cod_regra
            AND re.id_entidade <> lc.id_entidade
            AND re.ch_excluido IS NULL
    
    LOOP 
        UPDATE regrapreco_entidade 
            SET ch_excluido = 'T'
                WHERE id_regrapreco = idregra
                AND id_regrapreco_entidade = idregraent
                AND id_entidade = ident
                AND ch_excluido IS NULL;

    END LOOP;
END$$;