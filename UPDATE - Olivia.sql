DO $$
DECLARE
    empresa_lo INTEGER;
    preco_geral NUMERIC(26,8);
    preco_filial NUMERIC(26,8);
    item_preco_geral FK;
    item FK;
BEGIN 
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;


    FOR item_preco_geral, item, preco_geral, preco_filial IN 
        SELECT a.id_item_preco, a.id_item, a.vl_preco, b.vl_preco FROM item_preco a
        LEFT JOIN item_preco b ON a.id_item = b.id_item
            WHERE a.ch_tipo = 'G'
            AND b.ch_tipo = 'F'
            AND b.ch_predif = 'T'
            AND a.id_tipopreco = '1-1'
            AND b.id_tipopreco = '1-1'
            AND a.ch_excluido IS NULL
            AND b.ch_excluido IS NULL
            AND a.vl_preco <> b.vl_preco
            AND a.id_item IN ( SELECT li.id_item FROM localarm_item li
                               LEFT JOIN localarm l ON li.id_localarm = l.id_localarm 
                                WHERE li.qt_estoque > 0
                                AND l.id_filial = b.id_filial
                                AND l.ch_excluido IS NULL
                                AND li.ch_excluido IS NULL )
    
    LOOP 
        UPDATE item_preco SET 
            vl_preco = preco_filial
        WHERE id_item = item
        AND id_item_preco = item_preco_geral
        AND ch_tipo = 'G'
        AND vl_preco = preco_geral
        AND id_tipopreco = '1-1'
        AND ch_excluido IS NULL;

    END LOOP;
END$$;
        