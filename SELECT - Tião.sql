SELECT dt_emissao, ch_situac, * FROM abastecimento
    WHERE ch_situac = 'P'
    AND id_empresa =:Empresa
    AND ch_excluido IS NULL
    AND ch_ativo = 'T'


-------------------------------------------------


SELECT a.ch_situac, a.ch_sitpdv, a.* FROM docfiscal a 
LEFT JOIN docfiscal_eletro c ON a.id_docfiscal = c.id_docfiscal
    WHERE b.id_abastecimento = '5168-1'

----

SELECT b.id_abastecimento, a.ch_situac, a.ch_sitpdv, c.ch_sitnfe FROM docfiscal a 
LEFT JOIN docfiscal_item b ON a.id_docfiscal = b.id_docfiscal
LEFT JOIN docfiscal_eletro c ON a.id_docfiscal = c.id_docfiscal
    WHERE b.id_abastecimento IN (
                                    SELECT id_abastecimento FROM abastecimento
                                        WHERE ch_situac = 'P'
                                        AND id_empresa =:Empresa
                                        AND ch_excluido IS NULL
                                        AND ch_ativo = 'T'
                                        AND dt_emissao BETWEEN '2021-10-02' AND '2021-10-03'
)