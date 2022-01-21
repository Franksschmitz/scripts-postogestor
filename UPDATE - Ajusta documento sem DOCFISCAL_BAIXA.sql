DO $$
DECLARE
    empresa_lo INTEGER;
    idfilial INTEGER;
    nrdoc INTEGER;
    iddocitem FK;
    idabast FK;
    iddoc FK;
BEGIN
    SELECT id_empresa$lo FROM empresa$lo WHERE ch_local = 'T' LIMIT 1 INTO empresa_lo;

    nrdoc = '99999'; -- PREENCHER COM O NUMERO DO CUPOM DESEJADO
    idfilial = 1;    -- PREENCHER COM O CODIGO DA EMPRESA QUE EMITIU O CUPOM
    
    iddoc = (SELECT d.id_docfiscal FROM docfiscal d
            LEFT JOIN docfiscal_item b ON d.id_docfiscal = b.id_docfiscal
                WHERE d.nr_docfiscal = nrdoc
                AND d.ch_tipo IN ('NFCE', 'CFE','CF')
                AND d.ch_excluido IS NULL
                AND b.ch_excluido IS NULL
                AND d.ch_situac = 'A'
                AND d.ch_sitpdv = 'A'
                AND d.id_filial = idfilial
                AND d.id_docfiscal NOT IN ( SELECT id_docfiscal FROM docfiscal_baixa ));

    iddocitem = (SELECT b.id_docfiscal_item FROM docfiscal d
                LEFT JOIN docfiscal_item b ON d.id_docfiscal = b.id_docfiscal
                    WHERE d.nr_docfiscal = nrdoc
                    AND d.ch_tipo IN ('NFCE', 'CFE','CF')
                    AND d.ch_excluido IS NULL
                    AND b.ch_excluido IS NULL
                    AND d.ch_situac = 'A'
                    AND d.ch_sitpdv = 'A'
                    AND d.id_filial = idfilial
                    AND d.id_docfiscal NOT IN ( SELECT id_docfiscal FROM docfiscal_baixa ));

    idabast = (SELECT di.id_abastecimento FROM docfiscal_item di
                    WHERE di.id_docfiscal = iddoc
                    AND di.ch_excluido IS NULL
                    AND di.id_docfiscal = ( SELECT MAX(a.id_docfiscal) FROM docfiscal_item a 
                                                WHERE a.id_abastecimento = di.id_abastecimento
                                                AND a.ch_excluido IS NULL ));

    UPDATE abastecimento SET ch_situac = 'P'
        WHERE ch_situac = 'B'
        AND id_abastecimento = idabast
        AND ch_excluido IS NULL;

    UPDATE docfiscal_eletro SET ch_excluido = 'T', ch_sitnfe = 'C'
        WHERE id_docfiscal = iddoc
        AND ch_excluido IS NULL;

    UPDATE docfiscal_item SET ch_excluido = 'T'
        WHERE id_docfiscal = iddoc
        AND id_docfiscal_item = iddocitem
        AND ch_excluido IS NULL;

    UPDATE docfiscal SET ch_excluido = 'T', ch_situac = 'C', ch_sitpdv = 'C'
        WHERE id_docfiscal = iddoc
        AND ch_excluido IS NULL;

END$$;