SET TERM ^ ;

do $$
declare  
  l_id_empresa integer;
  l_id_entidade fk;
  l_id_pais fk;
  l_id_estado fk;
  
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);
  
	for l_id_entidade, l_id_pais, l_id_estado in
	  select id_entidade, id_pais, id_estado from entidade_endereco
	    where ch_excluido is null
	
	loop
	
		update entidade 
		set id_estado = l_id_estado, id_pais = l_id_pais
			where id_entidade = l_id_entidade
			and id_pais is null
			and id_estado is null;
end loop;
end
$$
^

SET TERM ; ^