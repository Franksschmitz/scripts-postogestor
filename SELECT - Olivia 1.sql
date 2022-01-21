        SELECT a.id_item_preco, a.id_item, a.vl_preco, b.id_item_preco, b.vl_preco, b.id_filial FROM item_preco a
        LEFT JOIN item_preco b ON a.id_item = b.id_item
            WHERE a.ch_tipo = 'G'
            AND b.ch_tipo = 'F'
            AND b.ch_predif = 'T'
            AND a.id_tipopreco = '1-1'
            AND b.id_tipopreco = '1-1'
            AND a.ch_excluido IS NULL
            AND b.ch_excluido IS NULL
            AND a.vl_preco <> b.vl_preco
            AND a.id_item IN ( SELECT id_item FROM item WHERE ch_excluido IS NULL AND ch_ativo = 'T' )
            AND b.id_filial IN (SELECT mi.id_filial FROM movest_item mi
                                    WHERE mi.id_item = a.id_item
                                    AND mi.ch_excluido IS NULL
                                    AND mi.ch_tipo = 'S'
                                    AND mi.dt_movime > '2021-06-01 00:00:01')