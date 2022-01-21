SELECT
    CASE
        WHEN e.ch_vinculada = 'T' THEN e.id_filial
        ELSE e.id_empresa
    END AS EMPRESA,
    EXTRACT(HOUR FROM a.dt_emissao) AS HORA,
    COUNT(a.id_abastecimento) AS SOMA,
    SUM(a.qt_abastecimento) AS LITROS
FROM abastecimento a
LEFT JOIN bico b ON (a.id_bico=b.id_bico)
LEFT JOIN item i On (a.id_item=i.id_item)
LEFT JOIN empresa e ON (a.id_empresa = e.id_empresa)
    WHERE a.ch_excluido IS NULL
    AND a.ch_ativo = 'T'
    AND b.ch_ativo = 'T'

{IF param_id_empresa} AND a.id_empresa IN (:id_empresa) {ENDIF}
{IF param_id_bico} AND b.id_bico IN (:id_bico) {ENDIF}
{IF param_id_item} AND i.id_item IN (:id_item) {ENDIF}
{IF param_emissao_ini} AND a.dt_emissao BETWEEN :emissao_ini AND :emissao_fim {ENDIF}

GROUP BY 1,2
ORDER BY 2 DESC