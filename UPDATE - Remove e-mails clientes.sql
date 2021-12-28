update entidade_contato set ds_email = NULL
where ch_excluido is NULL
and id_entidade in ( select id_entidade from entidade where ch_excluido is null and ch_ativo = 'T' )
