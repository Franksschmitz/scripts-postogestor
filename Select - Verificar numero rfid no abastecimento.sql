select
  b.id_abastecimento,
  b.nr_bico,
  a.nr_tag,
  a.id_entidade,
  c.ds_entidade
from abastecimento as b
left join rfid as a on (b.id_rfid_operador = a.id_rfid)
left join entidade c on (a.id_entidade = c.id_entidade
where b.id_empresa = 6
and b.ch_situac = 'P'
and b.nr_bico = 'NumeroBico'