select agg.ID_ENTIDADE,
       e.DS_ENTIDADE,
       sum(coalesce(lh.VL_SALDO, agg.VL_SALDO)) as VL_SALDO 
from(
select r.ID_ENTIDADE,
       r.VL_SALDO,
       (select rh_.ID_LANC_HIST
       from LANC_HIST rh_
       where rh_.ID_LANC = r.ID_LANC and
             rh_.CH_EXCLUIDO is null and
             rh_.DT_HIST <= :DT_STATUS
                         
       order by rh_.DT_HIST desc,
                rh_.HR_HIST desc,
                rh_.ID_SEQ desc
       limit 1) as ID_LANC_HIST
from LANC r
left join PLANOCONTA p on p.ID_PLANOCONTA = r.ID_PLANOCONTA
where r.CH_SITUAC is distinct from 'N' and       
      r.CH_DEBCRE = p.CH_NATUREZA and
      p.CH_CONT_FIN = 'P' and 
      r.CH_EXCLUIDO is null and 
      ((r.CH_SITUAC = 'A') or (r.DT_BAIXA > :DT_STATUS)) 
      and r.DH_LANC<= '2021.10.27' and r.ID_FILIAL in ('2')
) agg
left join LANC_HIST lh on lh.ID_LANC_HIST = agg.ID_LANC_HIST
left join ENTIDADE e on e.ID_ENTIDADE = agg.ID_ENTIDADE
group by 1, 2
order by 2