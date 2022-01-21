select DS_TIPO,
       sum(VL_SALDO) as VL_SALDO
from (
select agg.DS_TIPO,
       coalesce(lh.VL_SALDO, agg.VL_SALDO) as VL_SALDO
from (
select case when esp.CH_TIPO = 'C' and r.CH_DEVOLVIDO = 'T' then
         esp.DS_ESPECIE || ' DEVOLVIDO'
       else esp.DS_ESPECIE end as DS_TIPO,
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
left join ESPECIE esp on esp.ID_ESPECIE = r.ID_ESPECIE
left join PLANOCONTA p on p.ID_PLANOCONTA = r.ID_PLANOCONTA 
where r.CH_SITUAC is distinct from 'N' and       
      r.CH_DEBCRE = p.CH_NATUREZA and
      p.CH_CONT_FIN = 'R' and 
      r.CH_EXCLUIDO is null and 
      ((r.CH_SITUAC = 'A') or (r.DT_BAIXA > :DT_STATUS))and r.DH_LANC<= '2021.10.27' and r.ID_FILIAL in ('2') 
) agg    
left join LANC_HIST lh on lh.ID_LANC_HIST = agg.ID_LANC_HIST      


union all 

select DS_TIPO,
       (VL_SALDO + coalesce(VL_SALDO_ANT, 0)) as VL_SALDO
from (       
select esp.DS_ESPECIE as DS_TIPO,
       r.VL_SALDO,
       (select sum(coalesce(rb.VL_PAGO,0) + coalesce(rb.VL_TAXA,0)) 
        from CONCIRECPAG_BAI rb 
        where rb.ID_CONCIRECPAG = r.ID_CONCIRECPAG and 
              rb.CH_EXCLUIDO is null and rb.DT_PAGAME > :DT_STATUS) as VL_SALDO_ANT 
from CONCIRECPAG r
left join ESPECIE esp on esp.ID_ESPECIE = r.ID_ESPECIE
where r.CH_EXCLUIDO is null and
      ((r.CH_SITUAC = 'A') or 
        exists(select 1 from CONCIRECPAG_BAI rb 
               where rb.ID_CONCIRECPAG = r.ID_CONCIRECPAG and 
                     rb.CH_EXCLUIDO is null and rb.DT_PAGAME > :DT_STATUS))
      and r.DT_EMISSA<= '2021.10.27' and r.ID_FILIAL in ('2')     
) agg
) rel_
group by 1      
order by 1