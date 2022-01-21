select 
 a.id_docfiscal,
 a.nr_docfiscal,
 a.dh_emissa,
 case
    when c.ch_sitnfe = 'A' then 'AUTORIZADA'
    when c.ch_sitnfe = 'C' then 'CANCELADA'
    else 'PENDENTE'
 end as SITUACAO_NFCE,
 c.dh_recibo_can,
 d.nr_encerrante_ini,
 d.nr_encerrante_fim,
 d.qt_abastecimento,
 d.vl_abastecimento
from docfiscal a
left join docfiscal_item b on (a.id_docfiscal = b.id_docfiscal)
left join docfiscal_eletro c on (a.id_docfiscal = c.id_docfiscal)
left join abastecimento d on (b.id_abastecimento = d.id_abastecimento)
    where b.id_abastecimento = '58814-2'
    and a.ch_excluido is null
    and b.ch_excluido is null
    and c.ch_excluido is null
    and d.ch_excluido is null