select e.ID_EMPRESA, e.DS_EMPRESA empresa,
       i.DS_ITEM nome_produto,
       cast(mi.DT_MOVIME as date) as data,              
       (sum((select proc_custoitem_venda(mi.ID_DOCFISCAL_ITEM))) / count(1)) cmv, -- CUSTO MEDIO VENDAS
       (sum((select proc_customedio_item_venda(mi.ID_DOCFISCAL_ITEM))) / count(1)) cmp, -- CUSTO MEDIO PONDERADO
       (
          select smi.QT_ESTOQUE
          from MOVEST_ITEM smi
          where smi.CH_EXCLUIDO is null and
                smi.CH_TIPO = 'S' and
                smi.ID_ITEM = mi.ID_ITEM and
                smi.ID_FILIAL = mi.ID_FILIAL and
                cast(smi.DT_MOVIME as date) = (
                  select cast(ss.DT_MOVIME as date) from MOVEST_ITEM ss
                  where ss.ID_MOVEST_ITEM = mi.ID_MOVEST_ITEM 
                )
          order by smi.DT_MOVIME desc
          limit 1
       ) estoque
from MOVEST_ITEM mi 
join DOCFISCAL_ITEM di on (mi.ID_DOCFISCAL_ITEM = di.ID_DOCFISCAL_ITEM)
join ITEM i on (mi.ID_ITEM = i.ID_ITEM)
join EMPRESA e on (mi.ID_FILIAL = e.ID_EMPRESA)
where mi.CH_EXCLUIDO is null and
      i.CH_COMBUSTIVEL = 'T' and
      mi.CH_TIPO = 'S' and
      mi.id_item =:ITEM and
      mi.DT_MOVIME between :initialdatetime and :finaldatetime
      
      {if param_empresa} and mi.ID_FILIAL in (:empresa) {endif}
      
group by 1,2,3,4,7
order by 4