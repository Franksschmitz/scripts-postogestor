update docfiscal_eletro SET
    ch_sitnfe = 'A',
    ch_cancelar = 'F',
    ch_excluido = NULL,
    cd_status = '100',
    ds_motivo = 'Autorizado o uso da NF-e',
    ds_motivo_rej = NULL
where id_docfiscal in ( select id_docfiscal from docfiscal
                          where nr_docfiscal in ('23848','23849','23850','23851')
                          and ch_tipo = 'NFE')