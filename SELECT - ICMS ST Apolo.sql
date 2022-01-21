select 
  a.id_filial,
  a.id_item,
  b.ds_item,
  a.al_stmed,
  a.vl_bcstmed,
  a.vl_valstmed 
from item_custo a
left join item b on a.id_item = b.id_item
  where a.ch_excluido is null
  and a.vl_bcstmed <> '0'
  and a.id_item not in ( select id_item from item where ch_combustivel = 'T' )

group by 1,2,3,4,5,6
order by 1,3