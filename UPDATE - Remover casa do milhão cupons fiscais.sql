DO $$
DECLARE
  l_id_empresa INTEGER;
  l_NR_COOINI NUMERIC;
  l_NR_COOFIM NUMERIC;
  l_NR_COO NUMERIC;
  l_filial INTEGER;
  l_dt_ini DATE;
  l_dt_fim DATE;
  l_DOCECF FK;
  l_ecf FK;
BEGIN

  SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa;

  l_filial = 1;             -- PREENCHER APENAS COM O NÚMERO, EXEMPLO: 1  
  l_ecf = '1-2';            -- PREENCHER COM O CODIGO DA IMPRESSORA NO SISTEMA, EXEMPLO: '1-1'
  l_dt_ini = '2021-09-01';  -- PREENCHER NO FORMATO: 'ANO-MES-DIA'
  l_dt_fim = '2021-10-05';  -- PREENCHER NO FORMATO: 'ANO-MES-DIA'
  
  
  FOR l_DOCECF, l_NR_COOINI, l_NR_COOFIM, l_NR_COO IN 
    SELECT ID_DOCECF, NR_COOINI, NR_COOFIM, NR_COO FROM DOCECF
        WHERE DS_TIPO = 'RZ' 
        AND ID_EQPECF = l_ecf
        AND ID_FILIAL = l_filial                                                                     
        AND DT_MOVIME BETWEEN l_dt_ini AND l_dt_fim                 

  LOOP

    UPDATE DOCECF SET
      NR_COOFIM = (l_NR_COOFIM - '1000000')
        WHERE ID_DOCECF = l_DOCECF
        AND NR_COOFIM > '1000000'
        AND ID_EQPECF = l_ecf;

    UPDATE DOCECF SET
      NR_COOINI = (l_NR_COOINI - '1000000')
        WHERE ID_DOCECF = l_DOCECF
        AND NR_COOINI > '1000000'
        AND ID_EQPECF = l_ecf;

    UPDATE DOCECF SET
      NR_COO = (l_NR_COO - '1000000')
        WHERE ID_DOCECF = l_DOCECF
        AND NR_COO > '1000000'
        AND ID_EQPECF = l_ecf;
  END LOOP;
END$$;