SELECT 
    d.dh_emissa AS EMISSAO,
    d.nr_docfiscal AS NFCE,
    di.id_item AS CODIGO_ITEM,
    di.ds_item AS DESCRICAO_ITEM
FROM docfiscal_item di 
LEFT JOIN docfiscal d ON di.id_docfiscal = d.id_docfiscal
    WHERE d.ch_situac = 'F'
    AND d.ch_sitpdv = 'F'
    AND d.ch_tipo = 'NFCE'
    AND di.ch_excluido IS NULL
    AND di.id_vendedor IS NULL
    AND d.id_filial = 9
    AND d.dh_emissa BETWEEN '2021-10-01' AND '2021-10-26 23:59:59'
ORDER BY 1