select * from invent 
where id_invent in ('1906-4','1908-4')
and ch_excluido is null 

update invent set ch_excluido = 'T'
where id_invent in ('1906-4','1908-4')
and ch_excluido is null 

--------------------------------------------------

select * from invent_item 
where id_invent in ('1906-4','1908-4')
and ch_excluido is null 

update invent_item set ch_excluido = 'T'
where id_invent in ('1906-4','1908-4')
and ch_excluido is null 

--------------------------------------------------

select * from movest 
where id_invent in ('1906-4','1908-4')
and ch_excluido is null 

update movest set ch_excluido = 'T'
where id_invent in ('1906-4','1908-4')
and ch_excluido is null 

--------------------------------------------------

select count(*) from movest_item 
where id_movest in ('302723-4','303053-4')
and ch_excluido is null 

update movest_item set ch_excluido = 'T'
where id_movest in ('302723-4','303053-4')
and ch_excluido is null 