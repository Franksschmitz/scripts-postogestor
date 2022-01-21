select 
    b.ID_BICO, 
    b.DS_BICO, 
    b.NR_BICO, 
    b.ID_ITEM, 
    b.CH_PRECO_MULT,
    t.CH_FORCALC, 
    t.CH_PRECOCALC, 
    ic.VL_PRECUS, 
    ic.VL_PRECUSMED,
    t.ID_TIPOPRECO,
    t.DS_TIPOPRECO,
    coalesce(bp.VL_PRECO, b.VL_PRECO) as VL_PRECO, 
    coalesce(bp.VL_PRECOBASE, b.VL_PRECOBASE) as VL_PRECOBASE, 
    coalesce(bp.PER_MARGEM, b.PER_MARGEM) as PER_MARGEM              
from BICO b
inner join BOMBA bo on bo.ID_BOMBA = b.ID_BOMBA
left join ITEM_CUSTO ic on ic.ID_ITEM = b.ID_ITEM
left join BICO_PRECO bp on bp.ID_BICO = b.ID_BICO
left join TIPOPRECO t on t.ID_TIPOPRECO = coalesce(bp.ID_TIPOPRECO, b.ID_TIPOPRECO)
where b.CH_EXCLUIDO is null 
 and b.CH_ATIVO = 'T'
 and bo.CH_EXCLUIDO is null
 and bo.CH_ATIVO = 'T'
 and ic.CH_EXCLUIDO is null
 and bp.CH_EXCLUIDO is null
 and bo.ID_FILIAL = 2 and ic.ID_FILIAL = 2
order by b.NR_BICO