select 
   a.id_item,
   c.ds_item,
   a.nr_item,
   b.nr_ncm
from docfiscal_item a
left join classfiscal b on (a.id_classfiscal = b.id_classfiscal)
left join item c on (a.id_item = c.id_item)
where a.id_docfiscal =:CODIGO_NFE
and b.nr_ncm  =:NR_NCM


-------------------------------------------------------------------------------

select 
   a.id_item,
   c.ds_item,
   count(id_item)
from docfiscal_item a
left join docfiscal_item_imposto b on (a.id_docfiscal = b.id_docfiscal)
left join item c on (a.id_item = c.id_item)
left join cst d on (b.id_docfiscal_item_imposto = d.id_docfiscal_item_imposto)
where a.id_docfiscal =:CODIGO_NFE
and d.nr_cst =:NR_CST

-------------------------------------------------------------------------------

select 
   b.nr_ncm,
   Count(a.id_classfiscal)
from docfiscal_item a
left join classfiscal b on (a.id_classfiscal = b.id_classfiscal)
left join item c on (a.id_item = c.id_item)
where a.id_docfiscal =:CODIGO_NFE
group by 1


-------------------------------------------------------------------------------

select 
   c.id_item,
   c.ds_item,
   c.nr_cest
from docfiscal_item a
left join classfiscal b on (a.id_classfiscal = b.id_classfiscal)
left join item c on (a.id_item = c.id_item)
where a.id_docfiscal =:CODIGO_NFE
group by 1,2,3

-------------------------------------------------------------------------------

select 
   b.id_item,
   b.ds_item,
   b.nr_codbar as COD_BARRAS,
   c.nr_codbar as COD_BARRAS_ADICIONAL
from docfiscal_item a
left join item b on (a.id_item = b.id_item)
left join item_codbar c on (b.id_item = c.id_item)
where a.id_docfiscal =:CODIGO_NFE
group by 1,2,3,4