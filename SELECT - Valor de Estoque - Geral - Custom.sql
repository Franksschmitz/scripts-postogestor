select ID_ITEM,
       DS_ITEM,
       NR_NCM,
       ID_GRUPOITEM,
       DS_GRUPOITEM,
       sum(QT_ESTOQUE) as QT_ESTOQUE,
       avg(VL_PRECOBASE) as VL_PRECOBASE,
       avg(VL_PRECOVENDA) as VL_PRECOVENDA,
       sum(case when QT_ESTOQUE > 0 then QT_ESTOQUE * VL_PRECOBASE else 0.00 end) as TOTAL_PRECOBASE,
       sum(case when QT_ESTOQUE > 0 then QT_ESTOQUE * VL_PRECOVENDA else 0.00 end) as TOTAL_PRECOVENDA
from (
  select i.ID_ITEM, 
         i.NR_FANTASIA, 
         i.DS_ITEM, 
         us.DS_SIGLA as DS_SIGLA_UN,
         cl.NR_NCM,
         i.ID_MARCA,
         m.DS_MARCA,
         i.ID_GRUPOITEM as ID_GRUPOITEM,
         coalesce(cast(LEFT((SELECT string_agg(g_.DS_GRUPOITEM, '->') FROM PROC_GRUPOITEM_DEP(i.ID_GRUPOITEM) g_), 5000) as VARCHAR(5000)), 'SEM GRUPO') as DS_GRUPOITEM,
         coalesce((select mi.QT_ESTOQUE
          from MOVEST_ITEM mi
          where mi.CH_EXCLUIDO is null and
                mi.ID_LOCALARM = l.ID_LOCALARM and
                mi.ID_ITEM = i.ID_ITEM and 
                mi.DT_MOVIME <= :DT_STATUS
          order by mi.DT_MOVIME desc, mi.ID_SEQ desc
          limit 1), 0.0) as QT_ESTOQUE,
         (select VL_CUSTO from PROC_CUSTOITEM_STATUS(i.ID_ITEM, :DT_STATUS, l.ID_FILIAL)) as VL_PRECOBASE ,
         (select VL_PRECO from PROC_PRECOVENDA_STATUS(li.ID_ITEM, emp.ID_EMPRESA, '1-1', :DT_STATUS)) as VL_PRECOVENDA
  from LOCALARM_ITEM li
  left join LOCALARM l on l.ID_LOCALARM = li.ID_LOCALARM
  left join EMPRESA emp on emp.ID_EMPRESA = l.ID_FILIAL
  left join ITEM i on i.ID_ITEM = li.ID_ITEM
  left join UNIDADE us on us.ID_UNIDADE = i.ID_UNIDADE_S
  left join MARCA m on m.ID_MARCA = i.ID_MARCA
  left join GRUPOITEM gi on gi.ID_GRUPOITEM = i.ID_GRUPOITEM
  left join CLASSFISCAL cl on cl.ID_CLASSFISCAL = i.ID_CLASSFISCAL  
  where li.CH_EXCLUIDO is null
  and l.ID_FILIAL = 1 and 
      li.ID_ITEM = '1373-1' and 
	  coalesce(i.CH_KIT, 'F') <> 'T'
) rel_
where ((QT_ESTOQUE > 0))
group by 1,2,3,4,5
order by DS_ITEM asc