SELECT dt_movime,nr_crz,nr_cooini,nr_coofim,nr_coo,* FROM docecf 
  WHERE id_eqpecf = '1-2'
  AND ds_tipo = 'RZ'
  AND dt_movime BETWEEN '2021-12-01' AND '2021-12-31'