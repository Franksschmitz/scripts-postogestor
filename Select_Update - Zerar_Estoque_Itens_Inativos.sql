-- Para selecionar os itens inativos que possuem estoque diferente de 0: 

select 
    a.id_item,
    a.ds_item,
    b.qt_estoque,
    a.ch_ativo
from item as a
left join localarm_item as b on (a.id_item = b.id_item)
where b.qt_estoque <> '0'
and a.ch_ativo = 'F'   

-- Para zerar os estoques dos itens inativos:

update localarm_item set qt_estoque = '0'
where id_item in (   select 
                         a.id_item
                     from item as a
                     left join localarm_item as b on (a.id_item = b.id_item)
                     where b.qt_estoque <> '0'
                     and a.ch_ativo = 'F' 
                        )

