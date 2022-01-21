/*
Inativar itens que:

Não tiveram movimentação de estoque(entrada/saída) nos ultimos 6 meses;
estoque igual = 0
estiverem ativos

*/

select 

from movest_item a 
left join item b on (a.id_item = b.id_item)
left join localarm_item c on (b.id_item = c.id_item)
where 


