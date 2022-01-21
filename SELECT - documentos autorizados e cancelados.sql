SELECT
    d.nr_docfiscal AS DOCUMENTO,
    de.ch_sitnfe AS SITUACAO
FROM docfiscal d
LEFT JOIN docfiscal_eletro de ON d.id_docfiscal = de.id_docfiscal
    WHERE de.ch_sitnfe = 'A'
    AND d.ch_situac = 'F'
    AND d.ch_sitpdv = 'F'
    AND d.ch_tipo = 'NFCE'
    AND d.id_filial =:Empresa
    AND d.dt_emissa BETWEEN :Data_Inicial AND :Data_Final
ORDER BY 1 ASC

------

SELECT
    d.nr_docfiscal AS DOCUMENTO,
    de.ch_sitnfe AS SITUACAO
FROM docfiscal d
LEFT JOIN docfiscal_eletro de ON d.id_docfiscal = de.id_docfiscal
    WHERE de.ch_sitnfe IN ('I','C')
    AND d.ch_situac IN ('F','C')
    AND d.ch_sitpdv IN ('F','C')
    AND d.ch_tipo = 'NFCE'
    AND d.id_filial =:Empresa
    AND d.dt_emissa BETWEEN :Data_Inicial AND :Data_Final
ORDER BY 1 ASC