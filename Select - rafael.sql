select
   a.id_item as "Item",
   a.ds_item as "Descrição",
   case
      when a.nr_codbar is null then c.nr_codbar
      when a.nr_codbar is not null then a.nr_codbar
   end as "Cod. Barras",
   b.id_grupoitem as "Grupo",
   b.ds_grupoitem as "Categoria",
coalesce(
						(
							select 
									vl_precobase
								from item_preco
								where ch_excluido is null
								and id_item = b.id_item
								and id_filial = a.id_empresa
								and ch_predif = 'T'
								and ch_tipo = 'F'
								and id_tipopreco = (
									select id_tipopreco 
									from tipopreco 
									where ds_tipopreco = 'A VISTA' 
									limit 1)
						),
				
						(	
							select 
									vl_precobase
								from item_preco
								where ch_excluido is null
								and id_item = b.id_item
								and ch_tipo = 'G'
								and id_tipopreco = (
									select id_tipopreco 
									from tipopreco 
									where ds_tipopreco = 'A VISTA' 
									limit 1)
						)
		    ) as "Preço Custo",
coalesce(
						(
							select 
									vl_preco
								from item_preco
								where ch_excluido is null
								and id_item = b.id_item
								and id_filial = a.id_empresa
								and ch_predif = 'T'
								and ch_tipo = 'F'
								and id_tipopreco = (
									select id_tipopreco 
									from tipopreco 
									where ds_tipopreco = 'A VISTA' 
									limit 1)
						),
				
						(	
							select 
									vl_preco
								from item_preco
								where ch_excluido is null
								and id_item = b.id_item
								and ch_tipo = 'G'
								and id_tipopreco = (
									select id_tipopreco 
									from tipopreco 
									where ds_tipopreco = 'A VISTA' 
									limit 1)
						)
		) as "Preço Venda",
    e.qt_estoque as "Estoque"
from item a
left join grupoitem b on (a.id_grupoitem = b.id_grupoitem)
left join item_codbar c on (a.id_item = c.id_item)
left join item_preco d on (a.id_item = d.id_item)
left join localarm_item e on (a.id_item = e.id_item)
where a.ch_ativo = 'T'
and a.ch_excluido is null
and c.ch_excluido is null
and d.ch_excluido is null
and a.ch_revenda = 'T'
and e.id_localarm = '15-1'
and e.qt_estoque > 0
and d.id_seq in ( select max(id_seq) from item_preco where id_item = a.id_item group by (id_item))