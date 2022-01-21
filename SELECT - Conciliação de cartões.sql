select ID_AGRUPADOR,
       DS_AGRUPADOR,
       DT_EMISSA,
       DT_VENCIM,
       ID_ENTIDADE,
       DS_ENTIDADE,
       NR_DOCUME,
       VL_VALOR,
       ID_DOCFISCAL_BAIXA,
       NR_AUTORIZACAO,
       NR_NSU,
       ID_CARTAOTEF,
       ID_BANDEIRATEF,
       DS_CARTAOTEF,
       DS_BANDEIRATEF,
       DS_BANDEIRA,
       DS_OPERATEF,
       VL_TAXA,
       DT_PAGAME,
       CH_CONCILIADO,
       ID_FILIAL,
       DS_EMPRESA,
       VL_VALOR - coalesce(VL_TAXA,0) - coalesce(VL_TARIFA,0) as VL_LIQUIDO,
       case when VL_VALOR > 0.0 then VL_TAXA / VL_VALOR * 100 else 0.0 end as PER_TAXA,
       DS_TIPO,
       CH_ANTECIPADO,
       cast(coalesce(cast(NR_DOCFISCAL as varchar(20)), NR_DOCUME) as VARCHAR(20)) as NR_DOCFISCAL, VL_TARIFA    
from (        
  select 
     cr.ID_FILIAL as ID_AGRUPADOR,
     emp.DS_EMPRESA as DS_AGRUPADOR,    
     cr.DT_EMISSA, 
     cr.DT_VENCIM, 
     r.ID_ENTIDADE, 
     e.DS_ENTIDADE, 
     r.NR_DOCUME,      
     cr.VL_VALOR, 
     cr.ID_DOCFISCAL_BAIXA, 
     cr.NR_AUTORIZACAO, 
     cr.NR_NSU,
     cr.ID_CARTAOTEF, 
     cr.ID_BANDEIRATEF, 
     ct.DS_CARTAOTEF, 
     bt.DS_BANDEIRATEF,
     replace(bt.DS_BANDEIRATEF, ' ', '_') as DS_BANDEIRA, 
     o.DS_OPERATEF,
     case when cr.VL_SALDO > 0 then     coalesce(cr.VL_TAXA,0) +    (coalesce(  
  (select case when cr.CH_TEF = 'T' then cto.PER_TAXA else cto.PER_TAXA_POS end
   from CARTAOTEF_OPE cto
   where cto.ID_CARTAOTEF = cr.ID_CARTAOTEF and
         cto.ID_OPERATEF = cr.ID_OPERATEF and
         cto.ID_FILIAL = cr.ID_FILIAL and
         cto.CH_EXCLUIDO is null
   limit 1),
   (select case when cr.CH_TEF = 'T' then cto.PER_TAXA else cto.PER_TAXA_POS end
    from CARTAOTEF_OPE cto
    where cto.ID_CARTAOTEF = cr.ID_CARTAOTEF and
          cto.ID_OPERATEF = cr.ID_OPERATEF and
          cto.ID_FILIAL is null and
          cto.CH_EXCLUIDO is null
    limit 1),
0.0)
 * cr.VL_SALDO / 100.0)  else    cr.VL_TAXA  end  as VL_TAXA,  
     cr.DT_PAGAME,
     case when cr.CH_SITUAC = 'A' then 'T' else 'F' end as CH_CONCILIADO,
     cr.ID_FILIAL,
     emp.DS_EMPRESA,
     case when cr.CH_TEF = 'T' then 'TEF' else 'POS' end as DS_TIPO,
     case when exists(
        select 1 from CONCILIACAO_MOVI cm 
        where cm.ID_CONCIRECPAG = cr.ID_CONCIRECPAG and
              cm.CH_ANTECIPADO = 'T' and 
              cm.CH_EXCLUIDO is null) then 'T' else 'F' end as CH_ANTECIPADO,
     doc.NR_DOCFISCAL, cr.VL_TARIFA  
  from CONCIRECPAG cr  
  left join CARTAOTEF ct on ct.ID_CARTAOTEF = cr.ID_CARTAOTEF
  left join BANDEIRATEF bt on bt.ID_BANDEIRATEF = cr.ID_BANDEIRATEF
  left join OPERATEF o on o.ID_OPERATEF = cr.ID_OPERATEF
  left join EMPRESA emp on emp.ID_EMPRESA = cr.ID_FILIAL
  left join LANC r on r.ID_LANC = cr.ID_LANC
  left join ENTIDADE e on e.ID_ENTIDADE = r.ID_ENTIDADE
  left join CAIXAPDV c on c.ID_CAIXAPDV = r.ID_CAIXAPDV
  left join ESPECIE esp on esp.ID_ESPECIE = cr.ID_ESPECIE
  left join DOCFISCAL doc on doc.ID_DOCFISCAL = cr.ID_DOCFISCAL
  
  where (cr.CH_EXCLUIDO is null)
        and cr.DT_VENCIM between '2021.01.01' and '2021.01.05' and 
		cr.ID_FILIAL = '1'  
) rel_
order by 2,DT_EMISSA