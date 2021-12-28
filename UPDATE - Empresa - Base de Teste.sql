UPDATE empresa SET 
                ch_ambiente = '2',
                ch_cien_aut = 'F',
                ch_mani_aut = 'F',
                ch_env_email_nfe = 'F',
                ch_env_email_nfce = 'F',
                ch_env_danfe_nfe = 'F',
                ch_env_danfe_nfce = 'F',
                ds_email_dest_doc = NULL,
                id_email_eletro = NULL,
                id_email_fat = NULL,
                id_email_pendfin = NULL,
                id_email_notif = NULL
    WHERE ch_ativo = 'T'

------------------------------------------


UPDATE entidade_contato SET ds_email = NULL     
    WHERE ch_excluido IS NULL


--------------------------------------------

UPDATE empresa SET
  ch_modoemi_nfce = 'O',
  ch_forca_cont_nfce = 'T',
  nr_horas_cont_nfce = NULL,
  dh_max_cont_nfce = '2099-12-31 23:59:59'
WHERE id_empresa = 1


