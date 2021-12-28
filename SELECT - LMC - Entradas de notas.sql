select 
    a.NR_NOTAFI, 
    a.DT_EMISSA, 
    a.QT_MOVIME, 
    a.NR_TANQUE, 
    a.DS_SERIE, 
    a.ID_ENTIDADE, 
    a.DS_ENTIDADE, 
    a.DS_NATUREZA, 
    a.QT_DEVOLU
from (
        select 
            n.NR_NOTAFI, 
            n.DT_EMISSA,
            mi.QT_MOVIME, 
            l.NR_TANQUE, 
            n.DS_SERIE, 
            n.ID_ENTIDADE, 
            ent.DS_ENTIDADE,
            nat.DS_NATUREZA,
            (select 
                sum(di.QT_ITEM) 
            from DOCFISCAL_ITEM di
            left join DOCFISCAL d on d.ID_DOCFISCAL = di.ID_DOCFISCAL 
                where di.CH_EXCLUIDO is null 
                and di.ID_NFT_ITEM_REF = ni.ID_NFT_ITEM 
                and d.CH_SITUAC = 'F' 
                and d.CH_MOVEST = 'T' 
                and d.CH_OPERAC = 'S') as QT_DEVOLU
from MOVEST_ITEM mi
left join MOVEST m on m.ID_MOVEST = mi.ID_MOVEST
left join LOCALARM l on l.ID_LOCALARM = mi.ID_LOCALARM
left join NFT_ITEM ni on ni.ID_NFT_ITEM = mi.ID_NFT_ITEM
left join NFT n on n.ID_NFT = ni.ID_NFT
left join ENTIDADE ent on ent.ID_ENTIDADE = n.ID_ENTIDADE
left join NATOPER nat on nat.ID_NATOPER = ni.ID_NATOPER
where mi.DT_MOVIME between :DT_INI and :DT_FIM and mi.ID_ITEM = :ID_ITEM and 
      l.ID_FILIAL = :ID_FILIAL and m.CH_TIPO = 'E' and mi.CH_EXCLUIDO is null and
      mi.CH_MEDICAO is distinct from 'T' and
      mi.DT_MOVIME >= :DT_MED_INI
 ) a
 where (a.QT_MOVIME - coalesce(a.QT_DEVOLU, 0)) > 0