/*
    Ajusta custo e custo medio de movimentos.
    Seta nas movimentacoes dos itens o custo/custo medio da atualização de custo inicial
    até o primeiro reajuste de custo. Apos o primeiro reajuste reprocessa automaticamente.
*/
DO $$
DECLARE 
    empresa_lo INTEGER;     
    dtatualizacao TIMESTAMP;
    dt_base TIMESTAMP;
    idfilial INTEGER; 
    idatucusto FK;
    iditem FK;        
    vl_custo NUMERIC(26,8);    
BEGIN
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;

    idatucusto = ''; -- informar ID da atualização de custo inicial
    
    IF (idatucusto = '') THEN 
        RAISE EXCEPTION 'Variável "idatucusto" não foi iniciada';
    END IF;
    
    FOR iditem, idfilial, dtatualizacao, vl_custo IN 
        SELECT ai.ID_ITEM, ai.ID_FILIAL, ai.DT_ATUALIZACAO, ai.VL_PRECUS
        FROM ATUCUSTO_ITEM ai WHERE ai.CH_EXCLUIDO IS NULL 
        AND ai.ID_ATUCUSTO = idatucusto
        --AND ai.ID_ITEM = '' -- reprocessar de um item especifico
    LOOP 

        -- primeiro registro que modificou custo apos importacao
        dt_base = (
            SELECT DT_MOVIME FROM MOVEST_ITEM WHERE CH_EXCLUIDO IS NULL 
            AND CH_MODCUS = 'T' AND ID_ITEM = iditem AND ID_FILIAL = idfilial
            AND DT_MOVIME > dtatualizacao ORDER BY DT_MOVIME ASC LIMIT 1
        );
        dt_base = COALESCE(dt_base, CURRENT_TIMESTAMP);

        -- seta custos iguais aos custos da atualização em todas movimentacoes antes de DT_BASE
        UPDATE MOVEST_ITEM mi SET 
            VL_PRECUS = vl_custo,
            VL_PRECUSMED = vl_custo   
        WHERE mi.CH_EXCLUIDO IS NULL AND 
            mi.ID_ITEM = iditem AND
            mi.ID_FILIAL = idfilial AND             
            mi.DT_MOVIME < dt_base;
            
        -- no primeiro registro que alterou custo: seta somente custo medio igual ao custo da atualização
        UPDATE MOVEST_ITEM mi SET             
            VL_PRECUSMED = vl_custo   
        WHERE mi.CH_EXCLUIDO IS NULL AND 
            mi.ID_ITEM = iditem AND
            mi.ID_FILIAL = idfilial AND             
            mi.DT_MOVIME = dt_base;                        

        -- seta como nao processado todos registros depois de DT_BASE para reprocessar
        UPDATE MOVEST_ITEM mi SET 
            DT_PROCESSADA = NULL
        WHERE mi.CH_EXCLUIDO IS NULL AND 
            mi.ID_ITEM = iditem AND
            mi.ID_FILIAL = idfilial AND              
            mi.DT_MOVIME >= dt_base;

    END LOOP;
END$$;


-- SELECT VERIFICAÇÃO
SELECT 
    mi.DT_MOVIME, mi.DT_PROCESSADA, mi.CH_MODCUS, 
    mi.VL_PRECUS, mi.VL_PRECUSMED, mi.ID_FILIAL,
    mi.ID_ITEM, i.NR_FANTASIA, i.DS_ITEM    
    , mi.* 
FROM MOVEST_ITEM mi 
INNER JOIN ITEM i ON (mi.ID_ITEM = i.ID_ITEM) 
WHERE mi.CH_EXCLUIDO IS NULL 
AND i.ID_ITEM = :ID_ITEM
AND mi.ID_FILIAL = :ID_FILIAL
ORDER BY mi.DT_MOVIME;
