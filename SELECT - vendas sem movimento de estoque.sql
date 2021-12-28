select
  b.dh_emissa as EMISSAO,
  b.nr_docfiscal as NR_DOC,
  case 
    when b.ch_tipo = 'CF' then 'PAF-ECF'
    when b.ch_tipo = 'CFE' then 'SAT-CFE'
    when b.ch_tipo = 'NFCE' then 'NFC-e'
  end as TIPO_DOC,
  case
    when d.ch_sitnfe = 'A' then 'AUTORIZADA'
    when d.ch_sitnfe = 'R' then 'REJEITADA'
    when d.ch_sitnfe = 'C' then 'CANCELADA'
  end as SITUACAO,  
  b.id_entidade as ENTIDADE,
  e.ds_entidade as NOME, 
  a.id_item as ITEM,
  a.ds_item as DESCRICAO,
  a.qt_item as QUANTIDADE,
  a.vl_unitar as VL_PRECO,
  a.vl_total as VL_TOTAL,
  a.id_localarm as ID,
  c.ds_localarm as DEPOSITO
from docfiscal_item a
left join docfiscal b on a.id_docfiscal = b.id_docfiscal
left join localarm c on a.id_localarm = c.id_localarm
left join docfiscal_eletro d on a.id_docfiscal = d.id_docfiscal
left join entidade e on b.id_entidade = e.id_entidade
  where a.id_item =:CODIGO_ITEM
  and b.id_filial =:CODIGO_FILIAL 
  and b.ch_situac = 'F'
  and b.ch_sitpdv = 'F'
  and b.ch_tipo <> 'NFE'
  and b.dh_emissa between :DATA_INICIO and :DATA_FIM
  and a.id_docfiscal_item not in (

                                    select id_docfiscal_item from movest_item 
                                      where id_item =:CODIGO_ITEM
                                      and id_filial =:CODIGO_FILIAL 
                                      and dt_movime between :DATA_INICIO and :DATA_FIM

									)