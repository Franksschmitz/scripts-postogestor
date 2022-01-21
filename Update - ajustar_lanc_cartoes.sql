-- CHAMADO 3336 REDE GALO
DO $$DECLARE
  l_id_empresa INTEGER;
  l_id_planoconta FK;
  l_id_cartaotef FK;
  l_id_operatef FK;  
  l_id_lanc fk;
BEGIN

  SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa;

  FOR l_id_lanc, l_id_planoconta, l_id_cartaotef, l_id_operatef IN 
    SELECT crp.ID_LANC, ct.ID_PLANOCONTA, crp.ID_CARTAOTEF, crp.ID_OPERATEF 
    FROM CONCIRECPAG crp 
    JOIN CARTAOTEF ct ON (crp.ID_CARTAOTEF = ct.ID_CARTAOTEF)
    JOIN LANC la ON (crp.ID_LANC = la.ID_LANC)    
    WHERE la.CH_EXCLUIDO IS NULL AND
          la.ID_CARTAOTEF IS NULL AND
          la.ID_OPERATEF IS NULL AND
          la.ID_PLANOCONTA = '1-1'
  LOOP
    UPDATE LANC SET
      ID_PLANOCONTA = l_id_planoconta,
      ID_CARTAOTEF = l_id_cartaotef,
      ID_OPERATEF = l_id_operatef
    WHERE ID_LANC = l_id_lanc;
  END LOOP;
END$$;