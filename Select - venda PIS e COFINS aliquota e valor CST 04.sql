select
  a.id_filial EMPRESA,
  a.id_docfiscal CODIGO_NFCE,
  a.nr_docfiscal NR_NFCE,
  c.nr_cst CST,
  b.vl_base VALOR_BASE,
  b.al_imposto ALIQUOTA,
  b.vl_imposto VALOR_IMPOSTO
from docfiscal a
left join docfiscal_item_imposto b on a.id_docfiscal = b.id_docfiscal
left join cst c on b.id_cst = c.id_cst
left join docfiscal_eletro d on a.id_docfiscal = d.id_docfiscal
where a.ch_excluido is null
and b.ch_excluido is null
and a.ch_situac = 'F'
and d.ch_sitnfe = 'A'
and b.id_cst in ('118-1','151-1')
and b.vl_imposto > '0'
and a.dt_emissa between '2020-12-01' and '2020-12-31 23:59:59'