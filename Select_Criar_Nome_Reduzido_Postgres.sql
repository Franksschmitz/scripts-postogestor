/* SELECT IRA PEGAR A DESCRIÇÃO DO ITEM E REDUZIR */ 

select ds_item as "Descricao Original", ( 
	case
		when ch_excluido is null then 
		left(split_part(ds_item, ' ', 1), 10) || ' ' || 
		left(split_part(ds_item, ' ', 2), 10) || ' ' || 
		left(split_part(ds_item, ' ', 3), 10) || ' ' || 
		left(split_part(ds_item, ' ', 4), 5) || ' ' || 
		left(split_part(ds_item, ' ', 5), 5) || ' ' || 
		left(split_part(ds_item, ' ', 6), 5) || ' ' || 
		left(split_part(ds_item, ' ', 7), 5)
    end 
) as "Nome Reduzido"
from item 







