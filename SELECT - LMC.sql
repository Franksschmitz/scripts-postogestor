select
  a.DT_REF,
  a.ID_ITEM,
  a.NR_TANQUE,
  a.ID_BICO,
  a.NR_BICO,  
  sum(a.QT_AFERICAO) as QT_AFERICAO,
  sum(a.QT_VENDA) as QT_VENDA,
  sum(a.VL_VENDA) as VL_VENDA
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
            d.CH_TIPO <> 'NFCE' and
            di.ID_ITEM in ('3566-1')    

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
            di.ID_ITEM in ('3566-1')
        
        union all

        select
            cast(a.DT_EMISSAO as date) as DT_REF,
            a.ID_ITEM,
            l.NR_TANQUE,
            a.ID_BICO,
            b.NR_BICO,
            case when a.DS_STATUS = 'AFER' then a.QT_ABASTECIMENTO else 0.0 end as QT_AFERICAO,
            case when a.CH_MOVEST = 'T' then a.QT_ABASTECIMENTO else 0.0 end as QT_VENDA,
            case when a.CH_MOVEST = 'T' then a.VL_ABASTECIMENTO else 0.0 end as VL_VENDA
        from ABASTECIMENTO a
        left join LOCALARM l on l.ID_LOCALARM = a.ID_LOCALARM
        left join BICO b on b.ID_BICO = a.ID_BICO
        where a.DT_EMISSAO between :DH_INI and :DH_FIM and
            a.CH_EXCLUIDO is null and 
            a.CH_ATIVO = 'T' and 
            l.ID_FILIAL = :ID_FILIAL and
            (a.DS_STATUS = 'AFER' or a.CH_MOVEST = 'T') and
            a.ID_ITEM in ('3566-1')
) a 
group by 1,2,3,4,5