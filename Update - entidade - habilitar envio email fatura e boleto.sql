--comando para habilitar o envio de email de fatura e o envio de boleto de fatura

update entidade set ch_env_bolemail = 'T', ch_env_fatemail = 'T'
where id_grupoentidade in ('7-1','10-1','12-1')