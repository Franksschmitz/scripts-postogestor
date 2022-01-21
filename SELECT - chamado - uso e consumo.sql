select 
   a.id_abastecimento, 
   a.id_docfiscal,
   b.nr_docfiscal,
   b.ch_tipo,
   case 
     when c.ch_sitnfe = 'A' then 'Autorizada'
   end as SITUACAO,
   a.id_item,
   a.ds_item,
   a.id_localarm,
   e.ds_localarm,
   b.id_tipolanc,
   d.ds_tipolanc
from docfiscal_item a 
left join docfiscal b on a.id_docfiscal = b.id_docfiscal
left join docfiscal_eletro c on a.id_docfiscal = c.id_docfiscal
left join tipolanc d on b.id_tipolanc = d.id_tipolanc
left join localarm e on a.id_localarm = e.id_localarm
where a.id_docfiscal in ('3173-2', '3174-2')