select
 b.nr_ncm NCM,
 count(id_item) QUANTIDADE
from item a
left join classfiscal b on (a.id_classfiscal = b.id_classfiscal)
  where a.ch_ativo = 'T'
  and a.ch_excluido is null
group by 1
order by 2 desc