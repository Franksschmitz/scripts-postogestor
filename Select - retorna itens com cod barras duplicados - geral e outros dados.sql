(
    -- RETORNA ITENS COM CODIGO DE BARRAS ADICIONAL DUPLICADO COM O CODIGO DE BARRAS PRINCIPAL
    SELECT 
        i.NR_CODBAR,
        i.ID_ITEM ID_ITEM_CODBAR_PRINCIPAL,
        (
            SELECT STRING_AGG(ic.ID_ITEM, ',') FROM ITEM_CODBAR ic WHERE ic.NR_CODBAR = i.NR_CODBAR
        ) ID_ITEM_CODBAR_ADICIONAL
    FROM ITEM i 
    WHERE i.CH_EXCLUIDO IS NULL
    AND i.NR_CODBAR <> ''
    AND i.NR_CODBAR IN (
        SELECT NR_CODBAR FROM ITEM_CODBAR
        WHERE CH_EXCLUIDO IS NULL    
    )
)

UNION ALL

(
    SELECT '--------------', '------------------------------', '---------------------------------'
)

UNION ALL

(
    SELECT 'NR_CODBAR', 'ID_ITEM', 'ID_ITEM_CODBAR_DUPLICADO'
)

UNION ALL

(
    -- RETORNA ITENS COM CODIGO DE BARRAS PRINCIPAL DUPLICADO
    SELECT
        i.NR_CODBAR,
        i.ID_ITEM ID_ITEM_CODBAR_PRINCIPAL,
        (
            SELECT STRING_AGG(si.ID_ITEM, ',') FROM ITEM si 
            WHERE si.NR_CODBAR = i.NR_CODBAR 
            AND si.ID_ITEM <> i.ID_ITEM
        ) ID_ITEM_CODBAR_ADICIONAL
    FROM ITEM i
    WHERE i.CH_EXCLUIDO IS NULL
    AND i.NR_CODBAR <> ''
    AND i.NR_CODBAR IN (
        SELECT NR_CODBAR FROM (SELECT COUNT(1), NR_CODBAR FROM ITEM GROUP BY NR_CODBAR HAVING COUNT(NR_CODBAR) > 1) s
    )
    
)