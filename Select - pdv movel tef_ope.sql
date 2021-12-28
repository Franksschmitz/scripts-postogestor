select
  a.DH_EMISSAO HORA_TEF_OPE,
  d.dh_emissa HORA_VENDA,
  d.nr_docfiscal,
  d.id_docfiscal,
  a.id_docfiscal_baixa,
  a.NR_OPERATEF,
  a.ID_OPERATEF,
  b.DS_OPERATEF,
  a.DS_TIPO_OPE,
  a.DS_CARTAO,
  a.NR_BIN,
  a.DS_VIAOPE
from tef_ope as a
left join OPERATEF as b on (a.id_operatef = b.id_operatef)
left join docfiscal_baixa c on a.id_docfiscal_baixa = c.id_docfiscal_baixa
left join docfiscal d on c.id_docfiscal = d.id_docfiscal
where a.id_cartaotef = "1-1"
and d.dh_emissa between "2020-08-01" and "2020-09-04"
and d.id_filial = "3"
order by 2;