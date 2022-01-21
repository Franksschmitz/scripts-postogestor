DO $$

BEGIN


    UPDATE item SET nr_codbar = NULL, ch_excluido = 'T'
        WHERE id_item IN (
                            SELECT 
                                id_item
                            FROM item
                                WHERE ch_ativo = 'F'
                                AND nr_codbar IN ( SELECT nr_codbar FROM item WHERE ch_ativo = 'T' )
                        );

    UPDATE item SET nr_codbar = NULL, ch_excluido = 'T', ch_ativo = 'F'
        WHERE id_item IN (
                            SELECT 
                                id_item
                            FROM item 
                                WHERE id_unidade_s IS NULL 
                                AND ch_ativo = 'T' 
                                AND nr_codbar IS NOT NULL
        );

    UPDATE item SET ds_item_red = ltrim(ds_item_red)
        WHERE ds_item_red <> ltrim(ds_item_red);

    UPDATE item SET ds_item = ltrim(ds_item)
        WHERE ds_item <> ltrim(ds_item);
    

END$$;