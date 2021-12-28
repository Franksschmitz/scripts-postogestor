SELECT
    x.datahora_origem,
    x.empresa_origem AS ID_EMPRESA_ORIGEM,
    e.ds_empresa AS EMPRESA_ORIGEM,
    x.data_baixa,
    l.id_filial AS ID_EMPRESA_BAIXA,
    e2.ds_empresa AS EMPRESA_BAIXA,
    x.tipolanc,
    x.planoconta,
    x.nr_documento,
    x.entidade
FROM (
        SELECT 
            a.id_lanc AS COD_LANC,
            a.dh_lanc AS DATAHORA_ORIGEM,
            a.id_filial AS EMPRESA_ORIGEM,
            a.dt_baixa AS DATA_BAIXA,
            a.id_planoconta AS COD_PLANOCONTA,
            b.ds_planoconta AS PLANOCONTA,
            a.nr_docume AS NR_DOCUMENTO,
            a.id_tipolanc AS COD_TIPOLANC,
            c.ds_tipolanc AS TIPOLANC,
            a.id_entidade AS COD_ENTIDADE,
            d.ds_entidade AS ENTIDADE
        FROM lanc a 
        LEFT JOIN planoconta b ON a.id_planoconta = b.id_planoconta
        LEFT JOIN tipolanc c ON a.id_tipolanc = c.id_tipolanc
        LEFT JOIN entidade d ON a.id_entidade = d.id_entidade
            WHERE a.ch_excluido IS NULL
            AND b.ch_cont_fin = 'R'
            AND b.ch_cont_baixa = 'T'
            AND a.ch_debcre = 'D'
            AND a.ch_situac = 'L'
            AND a.id_filial =:EMPRESA_ORIGEM
            AND a.dt_baixa BETWEEN :DATA_INI AND :DATA_FIM

) x
LEFT JOIN lanc_det ld ON x.cod_lanc = id_lanc_bai
LEFT JOIN lanc l ON ld.id_lanc = l.id_lanc
LEFT JOIN empresa e ON x.empresa_origem = e.id_empresa
LEFT JOIN empresa e2 ON l.id_filial = e2.id_empresa
    WHERE l.id_filial <> x.empresa_origem 
    AND ld.ch_excluido IS NULL
    AND l.ch_excluido IS NULL

GROUP BY 1,2,3,4,5,6,7,8,9,10
ORDER BY 2,1,5,4