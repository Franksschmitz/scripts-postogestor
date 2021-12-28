select
       tot.CODIGO,
       tot.DESCRICAO,
       tot.ID_GRUPOITEM as ID_AGRUPADOR,
       tot.DS_GRUPOITEM as DS_AGRUPADOR,
       tot.QT_ESTOQUE_INI,
       tot.VL_PRECUS,
       tot.VL_CUSTOMED,
       cast(tot.QT_ESTOQUE_INI * tot.VL_PRECUS as decimal(18,4)) as VL_ESTOQUE_INI, 
       tot.QT_VENDA,
       tot.VL_VENDA,
       case when tot.QT_VENDA > 0 then cast(tot.VL_VENDA / tot.QT_VENDA as decimal(18,4)) else 0.0 end as VL_UNITAR_VENDA,
       tot.QT_COMPRA,
       tot.VL_COMPRA,
       case when tot.QT_COMPRA > 0 then cast(tot.VL_COMPRA / tot.QT_COMPRA as decimal(18,4)) else 0.0 end as VL_UNITAR_COMPRA,
       tot.QT_USOCONSUMO,
       tot.VL_USOCONSUMO,
       case when tot.QT_USOCONSUMO > 0 then cast(tot.VL_USOCONSUMO / tot.QT_USOCONSUMO as decimal(18,4)) else 0.0 end as VL_UNITAR_USOCONSUMO,       
       tot.QT_INVENT,
       tot.VL_INVENT,
       case when tot.QT_INVENT > 0 then cast(tot.VL_INVENT / tot.QT_INVENT as decimal(18,4)) else 0.0 end as VL_UNITAR_INVENT,
       tot.QT_OUTRAS,
       tot.VL_OUTRAS,
       case when tot.QT_OUTRAS > 0 then cast(tot.VL_OUTRAS / tot.QT_OUTRAS as decimal(18,4)) else 0.0 end as VL_UNITAR_OUTRAS,
       tot.QT_BONIFICACAO,
       tot.VL_BONIFICACAO,
       case when tot.QT_BONIFICACAO > 0 then cast(tot.VL_BONIFICACAO / tot.QT_BONIFICACAO as decimal(18,4)) else 0.0 end as VL_UNITAR_BONIFICACAO,
       cast(tot.QT_ESTOQUE_INI + tot.QT_COMPRA - tot.QT_VENDA - tot.QT_USOCONSUMO - tot.QT_BONIFICACAO + tot.QT_INVENT + tot.QT_OUTRAS as decimal(18,4)) as QT_ESTOQUE_FIN,
       cast(cast(tot.QT_ESTOQUE_INI + tot.QT_COMPRA - tot.QT_VENDA - tot.QT_USOCONSUMO - tot.QT_BONIFICACAO + tot.QT_INVENT + tot.QT_OUTRAS as decimal(18,4)) * tot.VL_PRECUS as decimal(18,4)) as VL_ESTOQUE_FIN        
from (
        select mov.ID_ITEM as CODIGO,
              i.DS_ITEM as DESCRICAO,
              gi.ID_GRUPOITEM as ID_GRUPOITEM,
              gi.DS_GRUPOITEM as DS_GRUPOITEM,
              coalesce((
                          select sum( 
                                      (select mi.QT_ESTOQUE
                                          from MOVEST_ITEM mi
                                          where mi.CH_EXCLUIDO is null and
                                                mi.ID_LOCALARM = l.ID_LOCALARM and
                                                mi.ID_ITEM = i.ID_ITEM and 
                                                mi.DT_MOVIME < :DT_STATUS
                                          order by mi.DT_MOVIME desc, mi.ID_SEQ desc
                                          limit 1
                          )) as QT_ESTOQUE_INI
                          from LOCALARM_ITEM li
                          left join LOCALARM l on l.ID_LOCALARM = li.ID_LOCALARM
                          where li.ID_ITEM = mov.ID_ITEM and
                                li.CH_EXCLUIDO is null
              ), 0.0) as QT_ESTOQUE_INI,
              (select VL_CUSTO from PROC_CUSTOITEM_STATUS(i.ID_ITEM, :DT_STATUS, :ID_FILIAL)) as VL_PRECUS,
              (select VL_CUSTOMED from PROC_CUSTOMEDIO_ITEM_STATUS(i.ID_ITEM, :DT_STATUS, :ID_FILIAL)) as VL_CUSTOMED,         
              mov.QT_VENDA,
              mov.VL_VENDA,
              mov.QT_COMPRA,
              mov.VL_COMPRA,
              mov.QT_USOCONSUMO,
              mov.VL_USOCONSUMO,
              mov.QT_INVENT,
              mov.VL_INVENT,
              mov.QT_OUTRAS,
              mov.VL_OUTRAS,
              mov.QT_BONIFICACAO,
              mov.VL_BONIFICACAO    
        from (
                select sub.ID_ITEM,       
                      sum(case when sub.DS_NATUREZA = 'VENDA' then sub.QT_MOVIME else 0.0 end) as QT_VENDA,
                      sum(cast(case when sub.DS_NATUREZA = 'VENDA' then sub.VL_CONTABIL else 0.0 end as decimal(18,4))) as VL_VENDA,       
                      sum(case when sub.DS_NATUREZA = 'COMPRA' then sub.QT_MOVIME else 0.0 end) as QT_COMPRA,
                      sum(cast(case when sub.DS_NATUREZA = 'COMPRA' then sub.QT_MOVIME * sub.VL_UNITAR else 0.0 end as decimal(18,4))) as VL_COMPRA,       
                      sum(case when sub.DS_NATUREZA = 'USOCONSUMO' then sub.QT_MOVIME else 0.0 end) as QT_USOCONSUMO,
                      sum(cast(case when sub.DS_NATUREZA = 'USOCONSUMO' then sub.QT_MOVIME * sub.VL_UNITAR else 0.0 end as decimal(18,4))) as VL_USOCONSUMO,
                      sum(case when sub.DS_NATUREZA = 'BONIFICACAO' then sub.QT_MOVIME else 0.0 end) as QT_BONIFICACAO,
                      sum(cast(case when sub.DS_NATUREZA = 'BONIFICACAO' then sub.QT_MOVIME * sub.VL_UNITAR else 0.0 end as decimal(18,4))) as VL_BONIFICACAO,
                      sum(case when sub.DS_NATUREZA = 'INVENT' then case when sub.CH_TIPO = 'S' then -sub.QT_MOVIME else sub.QT_MOVIME end else 0.0 end) as QT_INVENT,
                      sum(cast(case when sub.DS_NATUREZA = 'INVENT' then case when sub.CH_TIPO = 'S' then -sub.QT_MOVIME else sub.QT_MOVIME end  * sub.VL_UNITAR else 0.0 end as decimal(18,4))) as VL_INVENT,
                      sum(case when sub.DS_NATUREZA = 'OUTRAS' then case when sub.CH_TIPO = 'S' then -sub.QT_MOVIME else sub.QT_MOVIME end  else 0.0 end) as QT_OUTRAS,
                      sum(cast(case when sub.DS_NATUREZA = 'OUTRAS' then case when sub.CH_TIPO = 'S' then -sub.QT_MOVIME else sub.QT_MOVIME end  * sub.VL_UNITAR else 0.0 end as decimal(18,4))) as VL_OUTRAS       
                from (
                        select 
                              i.ID_ITEM,
                              i.ID_GRUPOITEM,             
                              case
                                when nat.DS_NATUREZA = 'VENDA' then 'VENDA'
                                when nat.DS_NATUREZA = 'COMPRA' then 'COMPRA'
                                when nat.DS_NATUREZA = 'USO E CONSUMO' then 'USOCONSUMO'
                                when nat.DS_NATUREZA = 'BONIFICACAO' and mi.CH_TIPO = 'S' then 'BONIFICACAO'
                                when m.ID_INVENT is not null then 'INVENT' 
                                else 'OUTRAS'         
                              end as DS_NATUREZA,
                              mi.CH_TIPO,
                              mi.QT_MOVIME,
                              coalesce(di.VL_UNITAR, 
                                                    cast(ni.VL_UNITAR / 
                                                                        (case when coalesce(ni.QT_MULTIPLICADOR, 0) <> 0 then ni.QT_MULTIPLICADOR else 1 end) as DECIMAL(18,6)), mi.VL_PRECUS) as VL_UNITAR,
                              i.CH_ARRE_TRUNC,
                              di.VL_DESCON,
                              di.VL_CONTABIL       
                        from MOVEST_ITEM mi
                        left join MOVEST m on m.ID_MOVEST = mi.ID_MOVEST
                        left join LOCALARM l on l.ID_LOCALARM = mi.ID_LOCALARM
                        left join DOCFISCAL d on d.ID_DOCFISCAL = m.ID_DOCFISCAL
                        left join NFT nt on nt.ID_NFT = m.ID_NFT
                        left join ITEM i on i.ID_ITEM = mi.ID_ITEM
                        left join GRUPOITEM gi on gi.ID_GRUPOITEM = i.ID_GRUPOITEM
                        left join INVENT inv on inv.ID_INVENT = m.ID_INVENT
                        left join EMPRESA emp on emp.ID_EMPRESA = MI.ID_FILIAL
                        left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL_ITEM = mi.ID_DOCFISCAL_ITEM
                        left join NFT_ITEM ni on ni.ID_NFT_ITEM = mi.ID_NFT_ITEM
                        left join NATOPER nat on nat.ID_NATOPER = coalesce(di.ID_NATOPER, ni.ID_NATOPER)
                        where m.CH_EXCLUIDO is null and mi.CH_EXCLUIDO is null
                        and (i.CH_COMBUSTIVEL = 'T') and mi.ID_FILIAL in ('2') and mi.DT_MOVIME between '2021.05.01 00:00:00.000' and '2021.05.31 23:59:59.999' and i.CH_ATIVO = 'T' and coalesce(i.CH_KIT, 'F') <> 'T'
                      ) sub
                      group by 1
              ) mov       
              left join ITEM i on i.ID_ITEM = mov.ID_ITEM                                                
              left join GRUPOITEM gi on gi.ID_GRUPOITEM = I.ID_GRUPOITEM
) tot
where (tot.QT_VENDA > 0 or tot.QT_COMPRA > 0 or tot.QT_USOCONSUMO > 0 or tot.QT_BONIFICACAO > 0 or tot.QT_INVENT > 0 or tot.QT_OUTRAS > 0)
order by DESCRICAO