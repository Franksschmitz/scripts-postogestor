/*
* Reprocessa os custos das movimentações de estoque que 
* modificaram custo com estoque ou valor de custo 0,00
*
* Executar este script apenas na EMPRESA LOCAL que gerou o MOVEST
*/

DO $$
DECLARE
    l_id_empresalo INTEGER;
BEGIN
    
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresalo;

    UPDATE MOVEST_ITEM SET 
        CH_EXCLUIDO = 'T'
    WHERE ID_FILIAL = l_id_empresalo AND 
          CH_MODCUS = 'T' AND
          CH_TIPO = 'E' AND
          CH_EXCLUIDO IS NULL AND                     
          (QT_MOVIME = '0' OR VL_PRECUS = '0');

    UPDATE MOVEST_ITEM SET 
        DT_PROCESSADA = NULL 
    WHERE ID_FILIAL = l_id_empresalo AND 
          CH_MODCUS = 'T' AND 
          CH_EXCLUIDO IS NULL;          

END
$$;

------------------------------------------------------
-- CONSULTA

SELECT CH_MODCUS, DT_MOVIME, DT_PROCESSADA, VL_PRECUS, 
       VL_PRECUSMED, QT_MOVIME, * 
FROM MOVEST_ITEM
WHERE CH_MODCUS = 'T' AND
      CH_EXCLUIDO IS NULL AND
      (QT_MOVIME = '0' OR VL_PRECUS = '0') AND
      ID_FILIAL = (SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1);      