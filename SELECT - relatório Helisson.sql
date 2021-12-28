select 
    distinct(i.id_item), 
    i.ds_item as Item, 
    gi.ds_grupoitem as Grupo,
    p.vl_preco, 
    mi.qt_estoque as Estoque 
from movest_item mi
left join item i on (mi.id_item=i.id_item)
left join item_preco p on (i.id_item=p.id_item)
left join grupoitem gi on (gi.id_grupoitem=i.id_grupoitem)
left join empresa e on (e.id_empresa= p.id_filial)
    where mi.ch_excluido is null
    and i.ch_excluido is null 
    and i.ch_ativo = 'T'
    and i.ch_combustivel <> 'T'
    and mi.id_seq in ( select max(id_seq) from movest_item 
                        where id_item = mi.id_item
                        and id_localarm = mi.id_localarm
                        and id_filial = mi.id_filial
                        and ch_excluido is null
                        and CAST(dt_movime AS DATE) < (:DT_STATUS) )

  {if param_Empresa} and e.id_empresa in (:Empresa) {endif}
  {if param_id_localarm} and mi.id_localarm in (:id_localarm) {endif}
  {if param_id_grupoitem} and gi.id_grupoitem in (:id_grupoitem) {endif}

group by 1,2,3,4,5
order by 3,2