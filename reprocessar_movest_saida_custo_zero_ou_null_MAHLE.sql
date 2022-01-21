/*
*
*  Reprocessar custo dos itens que movimentaram saída com CUSTO/CUSTO MEDIO 0,00 ou NULL
*  Essa alteração irá impactar diretamente nos relatorios de lucro
*
*/


--------------------------------------------------------------------------------------------------------
-- Executar essa consulta antes de qualquer coisa. Irá verificar se existe itens marcados como COMPOSTO porém sem composição

SELECT COUNT(1) FROM ITEM i WHERE i.CH_COMPOSTO = 'T' AND NOT EXISTS (
    SELECT 1 FROM ITEM_COMP ic WHERE ic.ID_ITEM = i.ID_ITEM
)

--------------------------------------------------------------------------------------------------------
-- Retorna itens que movimentaram com custo/custo medio 0,00 ou NULL
-- Também retorna o custo que irá ficar pós alteração

SELECT mi.ID_DOCFISCAL_ITEM, mi.CH_MODCUS, mi.CH_TIPO, mi.DT_MOVIME, mi.DT_PROCESSADA, 
       mi.VL_PRECUS,  mi.VL_PRECUSMED, mi.QT_MOVIME, mi.ID_ITEM,
       (SELECT VL_CUSTO FROM PROC_CUSTOITEM_STATUS(mi.ID_ITEM, mi.DT_MOVIME, mi.ID_FILIAL)) CUSTO,
       (SELECT VL_CUSTOMED FROM PROC_CUSTOMEDIO_ITEM_STATUS(mi.ID_ITEM, mi.DT_MOVIME, mi.ID_FILIAL)) CUSTO_MEDIO
FROM MOVEST_ITEM mi
WHERE mi.CH_EXCLUIDO IS NULL AND      
      mi.CH_TIPO = 'S' AND 
      mi.ID_FILIAL =  (SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1) AND 
      (mi.VL_PRECUS = '0' OR mi.VL_PRECUSMED = '0' OR mi.VL_PRECUS IS NULL OR mi.VL_PRECUSMED IS NULL)      
ORDER BY mi.DT_MOVIME, mi.ID_ITEM

--------------------------------------------------------------------------------------------------------
-- Reprocessa custos das movimentações acima retornadas

DO $$
DECLARE
    l_id_empresalo INTEGER;
    l_vl_precus VALOR_UNIT;
    l_vl_precusmed VALOR_UNIT;
    l_id_movest_item FK;    
BEGIN
    
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresalo;

    FOR l_vl_precus, l_vl_precusmed, l_id_movest_item IN 
        SELECT (SELECT VL_CUSTO FROM PROC_CUSTOITEM_STATUS(mi.ID_ITEM, mi.DT_MOVIME, mi.ID_FILIAL)) VL_PRECUS, 
               (SELECT VL_CUSTOMED FROM PROC_CUSTOMEDIO_ITEM_STATUS(mi.ID_ITEM, mi.DT_MOVIME, mi.ID_FILIAL)) VL_PRECUSMED,
               mi.ID_MOVEST_ITEM
        FROM MOVEST_ITEM mi        
        WHERE mi.CH_EXCLUIDO IS NULL AND                           
              mi.CH_TIPO = 'S' AND 
              mi.ID_FILIAL = l_id_empresalo AND 
              (mi.VL_PRECUS = '0' OR mi.VL_PRECUSMED = '0' OR mi.VL_PRECUS IS NULL OR mi.VL_PRECUSMED IS NULL) 
    LOOP

        UPDATE MOVEST_ITEM mi_ SET                         
            VL_PRECUS = l_vl_precus,  
            VL_PRECUSMED = l_vl_precusmed
        WHERE mi_.ID_MOVEST_ITEM = l_id_movest_item;
       
    END LOOP;
END
$$; 
