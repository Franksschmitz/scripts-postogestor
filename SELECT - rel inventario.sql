select 
      ID_INVENT,
      DH_FINALIZA,
      ID_ITEM,
      DS_ITEM,
      DS_SIGLA_UN,
      QT_ESTOQUE_ANT,
      QT_INVENT,
      VL_PRECOCUSTO,
      coalesce(VL_PRECOVENDA_FILIAL, VL_PRECOVENDA_GERAL) as VL_PRECOVENDA,      
      case 
        when QT_INVENT > QT_ESTOQUE_ANT then QT_INVENT - QT_ESTOQUE_ANT
        else null 
      end as QT_SOBRA,
      case 
        when QT_ESTOQUE_ANT > QT_INVENT then QT_ESTOQUE_ANT - QT_INVENT 
        else null 
      end as QT_FALTA,
      case 
        when (QT_ESTOQUE_ANT > 0) then (QT_INVENT / QT_ESTOQUE_ANT * 100) - 100 
        else 0 
      end as PER_DIFERENCA,
      DS_LOCALARM       
from (
        select 
              iv.ID_INVENT,
              iv.DH_FINALIZA,
              i.ID_ITEM,
              i.DS_ITEM,
              u.DS_SIGLA as DS_SIGLA_UN,
              case 
                when iv.CH_TIPO = 'M'
                  then iv.QT_ITEM - coalesce((
                                                select 
                                                  case 
                                                    when mi.CH_TIPO = 'E' then mi.QT_MOVIME 
                                                    else -mi.QT_MOVIME 
                                                  end 
                                                from MOVEST m
                                                left join MOVEST_ITEM mi on mi.ID_MOVEST = m.ID_MOVEST
                                                  where m.ID_INVENT = iv.ID_INVENT
                                                  and m.CH_EXCLUIDO is null
                                                  and mi.CH_EXCLUIDO is null
                                                limit 1        
                ), 0)           
              else ivi.QT_ESTOQUE
              end as QT_ESTOQUE_ANT,
              case 
                when iv.CH_TIPO = 'M' then iv.QT_ITEM 
                else ivi.QT_ITEM
              end as QT_INVENT,
              (select VL_CUSTO from PROC_CUSTOITEM(i.ID_ITEM, :ID_FILIAL)) as VL_PRECOCUSTO, 
              (select 
                  ip_.VL_PRECO
              from ITEM_PRECO ip_
                where ip_.ID_ITEM = i.ID_ITEM
                and ip_.CH_PREDIF = 'T'
                and ip_.CH_TIPO = 'F'
                and ip_.ID_FILIAL = l.ID_FILIAL
                and ip_.CH_EXCLUIDO is null 
              limit 1
              ) as VL_PRECOVENDA_FILIAL,
              (select 
                  ip_.VL_PRECO
              from ITEM_PRECO ip_
                where ip_.ID_ITEM = i.ID_ITEM      
                and ip_.CH_TIPO = 'G'
                and ip_.CH_EXCLUIDO is null
              limit 1
              ) as VL_PRECOVENDA_GERAL,
              l.DS_LOCALARM       
        from INVENT iv
        left join INVENT_ITEM ivi on ivi.ID_INVENT = iv.ID_INVENT
        left join ITEM i on i.ID_ITEM = coalesce(ivi.ID_ITEM, iv.ID_ITEM)
        left join UNIDADE u on u.ID_UNIDADE = i.ID_UNIDADE_S
        left join GRUPOITEM gi on gi.ID_GRUPOITEM = i.ID_GRUPOITEM
        left join LOCALARM l on l.ID_LOCALARM = iv.ID_LOCALARM
          where iv.CH_SITUAC = 'F'
          and iv.CH_EXCLUIDO is null
          and ivi.CH_EXCLUIDO is null
          and iv.DT_EMISSA between '2021.11.23' and '2021.11.24' 
          and iv.ID_FILIAL in ('2') 
          and iv.ID_LOCALARM in ('6-1')
) rel_

order by DH_FINALIZA asc