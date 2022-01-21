DO $$
DECLARE
  l_id_empresa INTEGER;
  l_id_docfiscal FK;
BEGIN
  SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);

  ALTER TABLE docfiscal DISABLE TRIGGER docfiscal_bu_val;

    FOR l_id_docfiscal IN
      SELECT d.id_docfiscal FROM docfiscal d
      LEFT JOIN docfiscal_eletro de ON d.id_docfiscal = de.id_docfiscal
        WHERE d.id_filial = 6
        AND d.ch_tipo = 'NFCE'
        AND d.ch_situac = 'F'
        AND d.ch_sitpdv = 'F'
        AND de.ch_sitnfe = 'R'
        AND d.dt_emissa > '2021-12-13'

    LOOP

      UPDATE docfiscal SET nr_docfiscal = NULL
        WHERE id_docfiscal = l_id_docfiscal;

      UPDATE docfiscal_eletro SET 
          ds_chave = NULL,
          ch_sitnfe = 'P',
          nr_tentativa = 0,
          ch_modoemi = 'O',
          ch_cont_off = 'T',
          ds_motivo = NULL,
          ds_motivo_rej = NULL,
          cd_status = NULL
        WHERE id_docfiscal = l_id_docfiscal;
  
    END LOOP;

  ALTER TABLE docfiscal ENABLE TRIGGER docfiscal_bu_val;

END$$;