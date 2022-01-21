SET TERM ^ ;

CREATE OR REPLACE FUNCTION public.proc_saldoconta(p_id_planoconta fk, p_id_filial integer, p_dt_ref timestamp without time zone)
 RETURNS TABLE(vl_saldo valor)
 LANGUAGE plpgsql
AS $function$
  declare l_dt_ref date;
  declare l_dt_saldo date;
  declare l_saldo_ant valor;
  declare l_natureza caracter;
  declare l_movimento valor;
BEGIN
  select CH_NATUREZA 
  from PLANOCONTA where ID_PLANOCONTA = p_id_planoconta
  into l_natureza;
  
  l_dt_ref = null;
  select DT_REF
  from SALDOCONTA$LO
  where ID_PLANOCONTA = p_id_planoconta and
        ID_FILIAL = p_id_filial and
        DT_REF < p_dt_ref and 
        DH_PROCESSADO is null and
        CH_EXCLUIDO is null         
  order by DT_REF
  into l_dt_ref;
  if (l_dt_ref is null) then 
    l_dt_ref = p_dt_ref;  
  end if;
  
  select s.VL_SALDO, s.DT_REF
  from SALDOCONTA$LO s
  where s.ID_PLANOCONTA = p_id_planoconta and
        s.ID_FILIAL = p_id_filial and
        s.DT_REF < l_dt_ref and
        s.CH_EXCLUIDO is null        
  order by s.DT_REF desc
  limit 1 
  into l_saldo_ant, l_dt_saldo;
  
  if (l_dt_saldo is null) then 
    select sum(case when l_natureza = l.CH_DEBCRE then l.VL_VALOR else -l.VL_VALOR end) 
    from LANC l
    where l.ID_PLANOCONTA = p_id_planoconta and
          l.ID_FILIAL = p_id_filial and
          l.DH_LANC < p_dt_ref and
          l.CH_EXCLUIDO is null
    into l_movimento;
  else
    select sum(case when l_natureza = l.CH_DEBCRE then l.VL_VALOR else -l.VL_VALOR end) 
    from LANC l
    where l.ID_PLANOCONTA = p_id_planoconta and
          l.ID_FILIAL = p_id_filial and
          l.DH_LANC >= (l_dt_saldo + 1) and l.DH_LANC < p_dt_ref and
          l.CH_EXCLUIDO is null
    into l_movimento;
  end if;
    
  vl_saldo = coalesce(l_saldo_ant, 0) + coalesce(l_movimento, 0);
  
  return next;
END;
$function$
^

SET TERM ; ^