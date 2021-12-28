select 
       mov.ID_ITEM,
       mov.DS_ITEM,
       mov.NR_FANTASIA,
       mov.DS_SIGLA_S,
       mov.DS_MARCA,
       (
         select VL_CUSTO
         from PROC_CUSTOITEM(mov.ID_ITEM, :ID_FILIAL)
       ) as VL_PRECUS,
       (select VL_PRECO 
        from (
          select ip.VL_PRECO,
                 case when CH_TIPO = 'F' then 2 else 1 end as PRIORIDADE
          from ITEM_PRECO ip
          left join TIPOPRECO tp on tp.ID_TIPOPRECO = ip.ID_TIPOPRECO
          where ip.ID_ITEM = mov.ID_ITEM and
                ip.CH_EXCLUIDO is null and
                tp.CH_PADRAO = 'T' and
                (
                  (ip.CH_TIPO = 'F' and ip.CH_PREDIF = 'T' and ip.ID_FILIAL = :ID_FILIAL) or
                  (ip.CH_TIPO = 'G')
                ) 
          order by PRIORIDADE desc
         limit 1
       ) sub_ limit 1) as VL_PREVEN,
       mov.QT_ENTRADA,
       mov.QT_SAIDA,
       mov.QT_MOVIME,
       mov.VL_TOTAL,
       i.QT_ENTRA,
       (
         select sum(li.QT_ESTOQUE) 
         from LOCALARM_ITEM li
         left join LOCALARM l on l.ID_LOCALARM = li.ID_LOCALARM
         where li.ID_ITEM = mov.ID_ITEM and
               li.CH_EXCLUIDO is null
                and l.ID_FILIAL in ('3')
                
       ) as QT_ESTOQUE
from (
  select mi.ID_ITEM,
         i.DS_ITEM,
         i.NR_FANTASIA, 
         us.DS_SIGLA as DS_SIGLA_S, 
         ma.DS_MARCA,
         sum(case when m.CH_TIPO = 'E' then mi.QT_MOVIME else 0.0 end) as QT_ENTRADA,
         sum(case when m.CH_TIPO = 'S' then mi.QT_MOVIME else 0.0 end) as QT_SAIDA,
         sum(mi.QT_MOVIME) as QT_MOVIME,
         sum(mi.QT_MOVIME * mi.VL_PRECUS) as VL_TOTAL     
  from MOVEST_ITEM mi
  left join MOVEST m on m.ID_MOVEST = mi.ID_MOVEST
  left join ITEM i on i.ID_ITEM = mi.ID_ITEM
  left join GRUPOITEM gi on gi.ID_GRUPOITEM = i.ID_GRUPOITEM
  left join MARCA ma on ma.ID_MARCA = i.ID_MARCA
  left join UNIDADE us on us.ID_UNIDADE = i.ID_UNIDADE_S
  where m.CH_EXCLUIDO is null and
        mi.CH_EXCLUIDO is null and         
        mi.DT_MOVIME between '2021.02.16 00:00:00.000' and '2021.02.18 23:59:59.999' and 
        i.CH_ATIVO = 'T' and 
        coalesce(i.CH_KIT, 'F') <> 'T'
  group by 1,2,3,4,5
  order by 2
) mov
left join ITEM i on i.ID_ITEM = mov.ID_ITEM