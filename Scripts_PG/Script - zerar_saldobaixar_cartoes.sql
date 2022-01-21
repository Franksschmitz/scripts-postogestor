/*
* Zera saldo a baixar e desmarca "controla baixa" dos lançamentos de cartões
*/

SELECT l.CH_SITUAC, SUM(l.VL_SALDO), COUNT(1) 
FROM LANC l 
WHERE l.CH_EXCLUIDO IS NULL AND 
      l.ID_PLANOCONTA IN (SELECT p.ID_PLANOCONTA FROM PLANOCONTA p WHERE p.CH_EXCLUIDO IS NULL AND p.ID_PAI = '326-1')
GROUP BY l.CH_SITUAC

------------------

DO $$
DECLARE 
    empresa_lo INTEGER;
    id_conta_pai FK;
BEGIN 
    
    SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO empresa_lo;
    id_conta_pai = '326-1';

    UPDATE PLANOCONTA p SET 
        CH_CONT_BAIXA = 'F',
        CH_TIPO_FIN = NULL
    WHERE p.CH_EXCLUIDO IS NULL AND
        p.ID_PAI = id_conta_pai;
    
    UPDATE LANC l SET 
        VL_SALDO = '0',
        CH_SITUAC = 'L'
    WHERE l.CH_EXCLUIDO IS NULL AND 
        l.CH_SITUAC = 'A' AND
        l.ID_PLANOCONTA IN (
        SELECT p.ID_PLANOCONTA FROM PLANOCONTA p WHERE p.CH_EXCLUIDO IS NULL AND p.ID_PAI = id_conta_pai
    );  

END$$;
