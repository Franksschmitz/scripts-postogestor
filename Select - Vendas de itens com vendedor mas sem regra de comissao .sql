   select
         a.id_vendedor,
   count(a.id_item),
         a.id_item,
         a.ds_item,
     sum(a.qt_item),
         b.id_regracomiss_apl
from docfiscal_item as a
left join docfiscal_item_comiss as b on (a.id_docfiscal_item = b.id_docfiscal_item)
left join docfiscal as c on (c.id_docfiscal = a.id_docfiscal)
where a.ch_excluido is null
     and a.id_vendedor is not null
     and b.id_regracomiss_apl is null
     and c.ch_situac = 'F'
     and a.id_item <> '1-35'
     and a.id_item <> '2-35'
     and a.id_item <> '4712-1'
     and a.id_item <> '4714-1'
     and a.id_item <> '5285-1'
     and a.id_item <> '7314-1'
     and a.id_item <> '7316-1'
     and a.id_item <> '9119-1'
     and a.id_item <> '11563-1'
group by 1,3,4,6
order by 2