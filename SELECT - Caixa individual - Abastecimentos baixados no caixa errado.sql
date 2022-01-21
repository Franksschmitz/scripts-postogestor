SELECT 
    e.ds_entidade AS FRENTISTA_CERTO,
    e2.ds_entidade AS FRENTISTA_ERRADO,
    COUNT(c.id_abastecimento) AS QUANT_ABAST
FROM abastecimento c 
LEFT JOIN rfid d ON c.id_rfid_operador = d.id_rfid 
LEFT JOIN usuario g ON c.id_usuario_m = g.id_usuario
LEFT JOIN entidade e ON d.id_entidade = e.id_entidade
LEFT JOIN entidade e2 ON g.id_entidade = e2.id_entidade
    WHERE c.ch_excluido IS NULL
    AND e.id_entidade <> e2.id_entidade
    AND c.ch_situac = 'B'
    AND c.dt_emissao BETWEEN '2021-08-05' AND '2021-09-05'
GROUP BY 1,2