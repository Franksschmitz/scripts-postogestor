SELECT 
    a.id_regrapreco,
    COUNT(a.id_regrapreco)
FROM regrapreco_entidade a
LEFT JOIN regrapreco b ON a.id_regrapreco = b.id_regrapreco
    WHERE a.ch_excluido IS NULL
    AND b.ch_excluido IS NULL
    AND b.ch_ativo = 'T'                          
GROUP BY 1
HAVING COUNT(1) > 1