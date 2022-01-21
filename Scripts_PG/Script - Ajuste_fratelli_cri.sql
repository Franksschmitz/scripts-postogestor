SET TERM ^ ;

do $$

declare
  l_ID_EMPRESA integer;
  l_ID_ITEM_ERRADO fk;
  l_ID_ITEM_CERTO fk;
  l_ID_LOCAL_ERRADO fk;
  l_ID_LOCAL_CERTO fk; 
 
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_ID_EMPRESA;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);  
  
  l_ID_ITEM_ERRADO = '4521-1';
  l_ID_ITEM_CERTO = '6078-1';
  
  l_ID_LOCAL_ERRADO = '20-1';
  l_ID_LOCAL_CERTO = '7-1';
  

update movest_item 
set id_item = l_ID_ITEM_CERTO, id_localarm = l_ID_LOCAL_CERTO
where id_item = l_ID_ITEM_ERRADO
and id_localarm = l_ID_LOCAL_ERRADO
and id_empresa = '13'
and dt_movime between '2017-11-01 00:00:01' and '2017-11-30 23:59:59'
and ch_excluido is null
and id_docfiscal_item in (  
                            select id_docfiscal_item from docfiscal_item a
                            left join docfiscal b on b.id_docfiscal = a.id_docfiscal
                            where a.id_item = l_ID_ITEM_CERTO
                            and b.ch_situac = 'F'
                            and a.id_empresa = '13'
                            and b.dt_emissa between '2017-11-01 00:00:01' and '2017-11-30 23:59:59' 
 									  );
end
$$
^

SET TERM ; ^