select 
    l.id_lanc as ID_LANC_ORIGEM,
    l.id_filial as EMPRESA_ORIGEM,
    l.dh_lanc as DATA_HORA_ORIGEM,
    l2.id_lanc as ID_LANC_BAIXA,
    l2.id_filial as EMPRESA_BAIXA,
    l.dh_lanc as DATA_HORA_BAIXA
from lanc l
left join lanc l2 on (l.id_lanc = l2.id_lanc_ref)
    where l.id_filial <> l2.id_filial
    and l.id_planoconta =:PLANOCONTA
    and l2.id_planoconta =:PLANOCONTA
    and l.ch_debcre = 'C'
    and l2.ch_debcre = 'D'
    and l.ch_excluido is null
    and l2.ch_excluido is null
    and l.dt_baixa between :DATA_BAIXA_INI and :DATA_BAIXA_FIM