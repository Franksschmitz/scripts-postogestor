DO $$
DECLARE
  l_id_empresa INTEGER;
  l_DOCECF FK;
  l_NR_CRZ NUMERIC;
BEGIN

  SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa;

  FOR l_DOCECF, l_NR_CRZ IN 
    SELECT ID_DOCECF, NR_CRZ FROM DOCECF
        WHERE DS_TIPO = 'RZ' 
        AND NR_CRZ > '1000000'
        AND ID_FILIAL = '1'                                   -- PREENCHER APENAS COM O NÚMERO, EXEMPLO: 1                                   
        AND DT_MOVIME BETWEEN '2000-01-01' AND '2021-01-01'   -- PREENCHER NO FORMATO: ANO-MES-DIA

  LOOP
    UPDATE DOCECF SET
      NR_CRZ = (l_NR_CRZ - '1000000')
        WHERE ID_DOCECF = l_DOCECF;
  END LOOP;
END$$;