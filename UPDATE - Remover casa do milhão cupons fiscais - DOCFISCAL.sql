DO $$
DECLARE
  l_id_empresa INTEGER;
  l_nr_cooini NUMERIC;
  l_nr_coofim NUMERIC;
  l_nr_coo NUMERIC;
  l_nr_doc NUMERIC;
  l_filial INTEGER;
  l_dt_ini DATE;
  l_dt_fim DATE;
  l_dia NUMERIC;
  l_mes NUMERIC;
  l_docecf FK;
  l_ecf FK;
  l_doc FK;
BEGIN

  SELECT id_empresa$lo FROM empresa$lo WHERE ch_local = 'T' LIMIT 1 INTO l_id_empresa;

  l_filial = 1;             -- PREENCHER APENAS COM O NÚMERO, EXEMPLO: 1
  l_ecf = '1-1';            -- PREENCHER COM O CODIGO DA IMPRESSORA NO SISTEMA, EXEMPLO: '1-1'
  l_dt_ini = '2002-01-31';  -- PREENCHER NO FORMATO: 'ANO-MES-DIA'
  l_dt_fim = '2002-02-08';  -- PREENCHER NO FORMATO: 'ANO-MES-DIA'
  
  
  FOR l_docecf, l_nr_cooini, l_nr_coofim, l_nr_coo IN
    SELECT id_docecf, nr_cooini, nr_coofim, nr_coo FROM docecf
        WHERE ds_tipo = 'RZ'
        AND id_eqpecf = l_ecf
        AND id_filial = l_filial
        AND dt_movime BETWEEN l_dt_ini AND l_dt_fim

  LOOP

    UPDATE docecf SET nr_coofim = (l_nr_coofim - '1000000')
        WHERE id_docecf = l_docecf
        AND nr_coofim > '1000000'
        AND id_eqpecf = l_ecf;

    UPDATE docecf SET nr_cooini = (l_nr_cooini - '1000000')
        WHERE id_docecf = l_docecf
        AND nr_cooini > '1000000'
        AND id_eqpecf = l_ecf;

    UPDATE docecf SET nr_coo = (l_nr_coo - '1000000')
        WHERE id_docecf = l_docecf
        AND nr_coo > '1000000'
        AND id_eqpecf = l_ecf;

  END LOOP;

    ALTER TABLE docfiscal DISABLE TRIGGER docfiscal_bu_val;

        FOR l_doc, l_nr_doc IN
            SELECT id_docfiscal, nr_docfiscal FROM docfiscal
                WHERE ch_tipo = 'CF'
                AND ch_situac = 'F'
                AND ch_sitpdv = 'F'
                AND id_eqpecf = l_ecf
                AND id_filial = l_filial
                AND dt_emissa BETWEEN '2022-02-01' AND '2022-02-09'

        LOOP

            UPDATE docfiscal SET nr_docfiscal = (l_nr_doc - '1000000')
                WHERE id_filial = l_filial
                AND id_docfiscal = l_doc
                AND id_eqpecf = l_ecf
                AND nr_docfiscal > '1000000';

        END LOOP;

    ALTER TABLE docfiscal ENABLE TRIGGER docfiscal_bu_val;
        
            FOR l_dia, l_mes IN
                SELECT EXTRACT(DAY FROM dt_movime), EXTRACT(MONTH FROM dt_movime) FROM docecf
                    WHERE ds_tipo = 'RZ'
                    AND id_eqpecf = l_ecf
                    AND id_filial = l_filial
                    AND dt_movime BETWEEN l_dt_ini AND l_dt_fim

            LOOP

                UPDATE docecf SET dt_movime = CAST((l_dia || '/' || l_mes || '/2022')AS DATE)
                    WHERE id_docecf = l_docecf
                    AND dt_movime < '2005-01-01';

            END LOOP;
END$$;