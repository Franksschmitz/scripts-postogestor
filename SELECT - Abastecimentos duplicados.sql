/*
    Consulta abastecimentos com encerrante duplicado
*/
select
    count(1), array_agg(a.ID_ABASTECIMENTO::text) as ABASTECIMENTOS, array_agg(a.CH_SITUAC::text) as SITUACOES,
    a.ID_EMPRESA, a.NR_BICO, a.VL_ABASTECIMENTO, a.QT_ABASTECIMENTO, a.QT_ENCERRANTE_INI, a.QT_ENCERRANTE_FIM
from ABASTECIMENTO a 
where a.CH_EXCLUIDO is null and     
    a.ID_EMPRESA = 66
group by 4,5,6,7,8,9
having count(a.QT_ENCERRANTE_INI) > 1
order by a.QT_ENCERRANTE_INI;