DO $$
DECLARE
    empresa_lo INTEGER;
    idmovitem FK;
    iditem FK;
    idmov FK;
    idinvent FK;
    idinventitem FK;
BEGIN
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    FOR idmov, idmovitem, idinventitem, idinvent, iditem IN
        SELECT a.id_movest, a.id_movest_item, a.id_invent_item, b.id_invent, a.id_item FROM movest_item a
        LEFT JOIN invent_item b ON a.id_invent_item = b.id_invent_item 
            WHERE a.dt_movime < '2021-11-01 00:05:00'
            AND a.id_filial = 2
            AND a.ch_tipo = 'E'
            AND a.ch_excluido IS NULL
            AND b.ch_excluido IS NULL
            AND a.id_item IN ( SELECT id_item FROM item WHERE ch_combustivel = 'T' AND ch_ativo = 'T' )
    
    LOOP

        UPDATE movest SET ch_excluido = 'T'
            WHERE id_movest = idmov
            AND ch_excluido IS NULL;

        UPDATE movest_item SET ch_excluido = 'T'
            WHERE id_movest = idmov
            AND id_movest_item = idmovitem
            AND id_item = iditem
            AND ch_excluido IS NULL;

        UPDATE invent SET ch_excluido = 'T'
            WHERE id_invent = idinvent
            AND ch_excluido IS NULL;
        
        UPDATE invent_item SET ch_excluido = 'T'
            WHERE id_invent = idinvent
            AND id_invent_item = idinventitem
            AND id_item = iditem
            AND ch_excluido IS NULL;
    END LOOP;
END$$;
