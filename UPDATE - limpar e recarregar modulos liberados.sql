DO $$
DECLARE
  l_id_empresa INTEGER;
  l_id_seq BIGINT;
BEGIN
  SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true); 

  UPDATE EMPRESA SET BL_CONF_REMOTO = NULL
    WHERE id_empresa = 1;
END
$$