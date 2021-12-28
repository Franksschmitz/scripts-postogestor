select 
  count(*) 
from item_preco 
where ch_tipo = 'F'
and ch_excluido is null 
and id_item in ( select 
                   id_item 
				 from item_preco 
				 where ch_tipo = 'G' 
				 and ch_excluido is null
				 )
