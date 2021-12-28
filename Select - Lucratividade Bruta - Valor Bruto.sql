select CODIGO,
DESCRICAO,
DS_AGRUPADOR,
QT_ITEM,
TOTAL_CUSTO,
TOTAL_VENDA,
VL_DESCON,
VL_ACRES,
cast(TOTAL_CUSTO / QT_ITEM as decimal(18,3)) as CUSTO_MEDIO,
cast(TOTAL_VENDA / QT_ITEM as decimal(18,3)) as PRECO_MEDIO,
TOTAL_VENDA - TOTAL_CUSTO as LUCRO_BRUTO,
cast(case when TOTAL_CUSTO > 0 then (TOTAL_VENDA - TOTAL_CUSTO) / TOTAL_CUSTO * 100.0 else 0 end as decimal(18,2)) as PERCENTUAL
from (
select i.ID_ITEM as CODIGO,
i.DS_ITEM as DESCRICAO,
cast(null as varchar(100)) as DS_AGRUPADOR,
sum(di.QT_ITEM) as QT_ITEM,
sum(cast(di.QT_ITEM * coalesce((select VL_CUSTO from PROC_CUSTOITEM_VENDA(di.ID_DOCFISCAL_ITEM)),0.00) as decimal(18,4))) as TOTAL_CUSTO,
sum(case when d.ID_ENTIDADE in ('1-1')then coalesce(cast(di.VL_UNITAR_BASE * di.QT_ITEM as decimal(18,4)), di.VL_BRUTO) else di.VL_CONTABIL end) as TOTAL_VENDA,
sum(di.VL_DESCON) as VL_DESCON,
sum(di.VL_ACRES) as VL_ACRES
from DOCFISCAL d
join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL
left join ENTIDADE e on e.ID_ENTIDADE = d.ID_ENTIDADE
left join ENTIDADE_HIST eh on eh.ID_ENTIDADE_HIST = d.ID_ENTIDADE_HIST
left join ITEM i on i.ID_ITEM = di.ID_ITEM
left join ESTADO est on est.ID_ESTADO = eh.ID_ESTADO
left join CIDADE cid on cid.ID_CIDADE = eh.ID_CIDADE
left join MARCA mar on mar.ID_MARCA = i.ID_MARCA
left join GRUPOITEM gi on gi.ID_GRUPOITEM = i.ID_GRUPOITEM
left join CAIXAPDV c on c.ID_CAIXAPDV = d.ID_CAIXAPDV
left join ENTIDADE vend on vend.ID_ENTIDADE = di.ID_VENDEDOR
where d.CH_EXCLUIDO is null and
di.CH_EXCLUIDO is null and
di.CH_GERARECPAG = 'T' and
d.CH_OPERAC = 'S' and
d.CH_SITUAC = 'F'
and d.DT_EMISSA between '2021.01.01' and '2021.01.01' and
d.CH_TIPO <> 'VEN'

group by 1,2,3
) rel_

order by DESCRICAO asc