
-- Comando para consultar Entidades duplicadas em regras de preço

select 
	count(a.*), 
	b.ds_entidade
from regrapreco_entidade a
join entidade b on a.id_entidade = b.id_entidade 
where a.id_regrapreco in ('22-5','24-5')
and a.ch_excluido is null
group by a.id_entidade, b.ds_entidade
having count(a.id_entidade) > 1