DO $$
DECLARE
    l_id_empresa INTEGER;
    l_doc FK;
BEGIN

  SELECT id_empresa$lo FROM empresa$lo WHERE ch_local = 'T' LIMIT 1 INTO l_id_empresa;

    FOR l_doc IN
        SELECT id_docfiscal FROM docfiscal
            WHERE ch_tipo = 'NFCE'
            AND id_filial = 1
            AND nr_docfiscal IN ('14282','14284','14326','14336')

    LOOP

        UPDATE docfiscal SET ch_situac = 'F', ch_sitpdv = 'F'
            WHERE id_docfiscal = l_doc;

        UPDATE docfiscal_eletro SET ch_sitnfe = 'A'
            WHERE id_docfiscal = l_doc;
 
    END LOOP;
END$$;