DO $$
DECLARE
  l_id_empresa INTEGER;
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

  l_filial = 1;
  l_ecf = '1-1';
  l_dt_ini = '2002-01-31';
  l_dt_fim = '2002-02-08';

    FOR l_docecf, l_dia, l_mes IN
        SELECT id_docecf, EXTRACT(DAY FROM dt_movime), EXTRACT(MONTH FROM dt_movime) FROM docecf
            WHERE ds_tipo = 'RZ'
            AND id_eqpecf = l_ecf
            AND id_filial = l_filial
            AND dt_movime BETWEEN l_dt_ini AND l_dt_fim

    LOOP

        UPDATE docecf SET dt_movime = CAST((l_dia || '/' || l_mes || '/2022')AS DATE)
            WHERE id_docecf = l_docecf;

    END LOOP;
END$$;