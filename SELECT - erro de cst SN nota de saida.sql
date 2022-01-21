select 
 c.id_item CODIGO,
 c.ds_item ITEM,
 d.nr_cst CST,
 d.ds_cst DESCRICAO
from docfiscal_item_imposto a
left join docfiscal_item b on a.id_docfiscal_item = b.id_docfiscal_item
left join item c on b.id_item = c.id_item
left join cst d on a.id_cst = d.id_cst
where a.id_imposto = '1-1'
and a.id_docfiscal =:Nota
and d.nr_cst <> 'NUMERO DA CST'

order by 2