SET TERM ^ ;

do $$
declare  
  l_id_empresa integer;
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);
  
  update lanc set id_especie = '2-1' where id_especie = '23-5' and id_caixapdv = '1011-5';
  update caixapdv_fec set ch_excluido = 'T' where id_caixapdv = '1011-5' and id_especie = '23-5';  
end
$$
^

SET TERM ; ^