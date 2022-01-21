update item set ch_revenda = 'T', id_unidade_s = '5-1'
where id_unidade_s is null
and ch_revenda <> 'T'
and ch_usoconsumo <> 'T'
and ch_combustivel <> 'T'
and ch_servico <> 'T'
and ch_imobilizado <> 'T'
and ch_material <> 'T'