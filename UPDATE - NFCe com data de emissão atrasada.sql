--Ajustar Data para Atual para sefaz aceitar o XML:

--Testar um documento:

UPDATE docfiscal SET
    dh_emissa = CURRENT_TIMESTAMP, 
    dt_emissa = CURRENT_DATE, 
    hr_emissa = CURRENT_TIME,
    dt_saida = CURRENT_DATE,
    hr_saida = CURRENT_TIME
    WHERE id_docfiscal IN ('','','','','','','')



UPDATE docfiscal_eletro SET
    ch_sitnfe = 'P',
    nr_tentativa = 0,
    ch_modoemi = 'O',
    ds_motivo = NULL,
    ds_motivo_rej = NULL,
    cd_status = NULL
    WHERE id_docfiscal IN ('','','','','','','')
