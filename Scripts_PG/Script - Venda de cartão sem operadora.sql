SET TERM ^ ;

do $$
declare 
    l_id_empresa integer;
    l_id_especie fk;
begin
    select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
    perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true); 
    
    for l_id_especie in
        select ID_ESPECIE
        from ESPECIE
        where CH_EXCLUIDO is null and 
        CH_ATIVO = 'T' and
        CH_TIPO = 'T' 
      --  and CH_TEF <> 'T' -- Comentar essa linha se tambem quiser alterar vendas em TEF
    loop

        update DOCFISCAL_BAIXA db
        set ID_OPERATEF =
            (select co.ID_OPERATEF 
            from CARTAOTEF_OPE co 
            where co.ID_CARTAOTEF = db.ID_CARTAOTEF and 
            co.CH_PADRAO_POS = 'T' and 
            co.CH_EXCLUIDO is null
            limit 1) 
        where db.ID_ESPECIE = l_id_especie and
        db.CH_EXCLUIDO is null and
        db.ID_OPERATEF is null; 

        update CONCIRECPAG crp
        set ID_OPERATEF = 
            (select co.ID_OPERATEF 
            from CARTAOTEF_OPE co 
            where co.ID_CARTAOTEF = crp.ID_CARTAOTEF and 
            co.CH_PADRAO_POS = 'T' and 
            co.CH_EXCLUIDO is null
            limit 1)
        where crp.ID_ESPECIE = l_id_especie and
        crp.CH_EXCLUIDO is null and
        crp.ID_OPERATEF is null; 
    
    end loop; 
end
$$
^

SET TERM ; ^