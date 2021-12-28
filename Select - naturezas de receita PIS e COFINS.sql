select
 inr.id_item,
 i.ds_item,
 g.nr_ncm,
 t.ds_cfgfiscal 
from item_natrec inr 
join item i on inr.id_item = i.id_item 
join item_cfgfiscal k on k.id_item = inr.id_item
join classfiscal g on g.id_classfiscal = i.id_classfiscal
join cfgfiscal t on t.id_cfgfiscal = k.id_cfgfiscal
  where inr.id_natrec in (select id_natrec from natrec where nr_natrec =:NAT_REC) 
  and i.ch_ativo = 'T'
  and k.ch_tipocfg = 'P'
  and t.ds_cfgfiscal like '%PIS%'
order by 4,3,2;