do $$

declare 
  declare l_ID_EMPRESA integer;
  declare l_NR_DOCUME varchar(30);
  declare l_ID_TITULO fk;
  declare l_ID_LANC fk;
  
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_ID_EMPRESA;
		
  
  for l_ID_LANC, l_ID_TITULO, l_NR_DOCUME in 
		select 
		   a.id_lanc,
		   b.id_titulo,
		   b.nr_docume
		from lanc a
		left join titulo b on a.id_titulo_ref = b.id_titulo
		where a.ch_excluido is null
		and b.ch_excluido is null
		and b.ch_status = '3'
    loop
	  update lanc
	  set nr_docume = l_NR_DOCUME
	  where id_lanc = l_ID_LANC
	  and id_titulo_ref = l_ID_TITULO;

  end loop;
end
$$;