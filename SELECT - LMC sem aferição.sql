select
  x.DT_REF,
  x.ID_ITEM,
  x.NR_TANQUE,
  x.ID_BICO,
  x.NR_BICO,  
  sum(x.QT_AFERICAO) as QT_AFERICAO,
  sum(x.QT_VENDA) as QT_VENDA,
  sum(x.VL_VENDA) as VL_VENDA
from (
        select
            d.DT_EMISSA as DT_REF, 
            a.ID_ITEM,
            l.NR_TANQUE,
            a.ID_BICO,
            b.NR_BICO,
            cast(0.0 as QUANTIDADE) as QT_AFERICAO,
            a.QT_ABASTECIMENTO as QT_VENDA,
            a.VL_ABASTECIMENTO as VL_VENDA
        from DOCFISCAL d
        left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL
        left join ABASTECIMENTO a on a.ID_ABASTECIMENTO = di.ID_ABASTECIMENTO
        left join LOCALARM l on l.ID_LOCALARM = a.ID_LOCALARM
        left join BICO b on b.ID_BICO = a.ID_BICO            
        left join CAIXAPDV c on c.ID_CAIXAPDV = d.ID_CAIXAPDV 
        where d.DT_EMISSA between :DT_INI and :DT_FIM and 
            d.CH_SITUAC = 'F' and
            d.CH_EXCLUIDO is null and 
            di.CH_EXCLUIDO is null and 
            a.CH_EXCLUIDO is null and
            a.CH_ATIVO = 'T' and 
            l.ID_FILIAL = :ID_FILIAL and
            a.CH_MOVEST is distinct from 'T' and 
            d.CH_TIPO = 'NFCE' and
            di.ID_ITEM in ('1413-1')     

        union all

        select
            d.DT_EMISSA as DT_REF,
            a.ID_ITEM,
            l.NR_TANQUE,
            a.ID_BICO,
            b.NR_BICO,
            cast(0.0 as QUANTIDADE) as QT_AFERICAO,
            a.QT_ABASTECIMENTO as QT_VENDA,
            a.VL_ABASTECIMENTO as VL_VENDA
        from DOCFISCAL d
        left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL
        left join ABASTECIMENTO a on a.ID_ABASTECIMENTO = di.ID_ABASTECIMENTO
        left join LOCALARM l on l.ID_LOCALARM = a.ID_LOCALARM
        left join BICO b on b.ID_BICO = a.ID_BICO
        left join CAIXAPDV c on c.ID_CAIXAPDV = d.ID_CAIXAPDV             
        where d.DT_EMISSA between :DT_INI and :DT_FIM and 
            d.CH_SITUAC = 'F' and
            d.CH_EXCLUIDO is null and 
            di.CH_EXCLUIDO is null and 
            a.CH_EXCLUIDO is null and
            a.CH_ATIVO = 'T' and 
            l.ID_FILIAL = :ID_FILIAL and
            a.CH_MOVEST is distinct from 'T' and 
            d.CH_TIPO <> 'NFCE' and
            di.ID_ITEM in ('1413-1')

) x
  
group by 1,2,3,4,5