do $$
declare  
  l_id_empresa integer;
  l_id_cartao fk;
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;

  l_id_cartao = '8-1';

  update cartao_mov set vl_valor=(vl_valor/100.0) 
    where id_cartao = l_id_cartao
    and ch_operac = 'C'
    and id_docfiscal is not null
    and ch_excluido is null;  
end
$$