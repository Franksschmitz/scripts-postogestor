
DO $$DECLARE

  l_filial INTEGER;
  l_ope_certa FK;
  l_ope_errada FK;
  l_doc FK;
  l_doc_baixa FK;
  data_ini DATE;
  data_fim DATE;

BEGIN

  l_filial = '2';          -- COLOCAR O NÚMERO DA EMPRESA
  l_ope_certa = '4-1';     -- COLOCAR O CÓDIGO DA OPERADORA CERTA
  l_ope_errada = '1-1';    -- COLOCAR O CÓDIGO DA OPERADORA ERRADA
  data_ini = '2021-08-19'; -- PREENCHER NO FORMATO DIA-MES-ANO DD-MM-YYYY
  data_fim = '2021-08-20'; -- PREENCHER NO FORMATO DIA-MES-ANO DD-MM-YYYY

  FOR l_doc, l_doc_baixa IN 
    SELECT id_docfiscal, id_docfiscal_baixa FROM docfiscal_baixa
        WHERE ch_excluido IS NULL 
        AND id_operatef = l_ope_errada
        AND id_docfiscal IN ( SELECT id_docfiscal FROM docfiscal 
                                WHERE ch_situac = 'F'
                                AND ch_sitpdv = 'F'
                                AND ch_tipo <> 'NFE' 
                                AND id_filial = l_filial
                                AND dt_emissa BETWEEN data_ini AND data_fim )

  LOOP
    UPDATE docfiscal_baixa SET
       id_operatef = l_ope_certa
    WHERE id_docfiscal_baixa = l_doc_baixa
    AND id_operatef = l_ope_errada
    AND ch_excluido IS NULL;
    
    
    UPDATE lanc SET
       id_operatef = l_ope_certa
    WHERE id_docfiscal_baixa = l_doc_baixa
    AND id_operatef = l_ope_errada
    AND id_filial = l_filial
    AND ch_excluido IS NULL;

  END LOOP;
END$$;