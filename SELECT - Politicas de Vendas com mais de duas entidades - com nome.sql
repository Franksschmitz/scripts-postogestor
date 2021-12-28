SELECT
    x.cod_regra,
    x.nome_regra,
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
ORDER BY 2,4