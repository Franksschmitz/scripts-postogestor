SELECT 
    di.id_item AS CODIGO_ITEM,
    di.ds_item AS DESCRICAO_ITEM,
    COUNT(di.id_item) AS QUANTIDADE
FROM docfiscal_item di 
LEFT JOIN docfiscal d ON di.id_docfiscal = d.id_docfiscal
    WHERE d.ch_situac = 'F'
    AND d.ch_sitpdv = 'F'
    AND d.ch_tipo = 'NFCE'
    AND di.ch_excluido IS NULL
    AND di.id_vendedor IS NULL
    AND d.id_filial = 9
    AND d.dh_emissa BETWEEN '2021-01-01' AND '2021-10-27 23:59:59'
GROUP BY 1,2