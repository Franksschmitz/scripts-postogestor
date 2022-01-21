SELECT
    ch_sitnfe,
    nr_tentativa, 
    ch_modoemi,
    ds_motivo,
    ds_motivo_rej,
    cd_status, *
FROM docfiscal_eletro
    WHERE id_docfiscal IN ( SELECT id_docfiscal FROM docfiscal 
                                WHERE id_filial =:EMPRESA 
                                AND nr_docfiscal =:NR_DOCUMENTO )
