do $$
declare  
  l_id_empresa integer;
  l_id_cartao fk;
  l_dh_ini datahora;
  l_dh_fim datahora;
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);
  perform set_config('myvars.DESATIVA_REPLICADOR', 'T', true);
  l_dh_ini = '2021-07-20 00:00:00'; --preencher no formato data/hora
  l_dh_fim = '2021-07-20 23:59:59.999'; --preencher no formato data/hora   
  for l_id_cartao in  
    select c.id_cartao
    from cartao c
        where c.CH_EXCLUIDO is null
        and c.CH_ATIVO = 'T'
        and c.CH_TIPO = 'F' 
  loop
    perform set_config('myvars.ATUALIZANDO_CARTAO', 'T', true);
    update cartao_mov set vl_valor=(vl_valor/100.0) 
        where id_cartao=l_id_cartao
        and ch_operac = 'C' 
        and id_docfiscal is not null
        and dh_movime between l_dh_ini and l_dh_fim
        and ch_excluido is null;  
    perform proc_atualiza_cartao(l_id_cartao, 
      '2000-01-01 00:00:00',
      0,
      'F'       
    );
    perform set_config('myvars.ATUALIZANDO_CARTAO', 'F', true);
  end loop;          
  perform set_config('myvars.DESATIVA_REPLICADOR', 'F', true); 
end
$$