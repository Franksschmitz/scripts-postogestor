UPDATE lanc SET ch_situac = 'N', vl_saldo = 0
    WHERE id_especie = '3-1'
    AND id_tipolanc =:TIPO_LANCAMENTO
    AND id_entidade =:ENTIDADE
    AND ch_situac = 'A'
    AND vl_saldo > 0