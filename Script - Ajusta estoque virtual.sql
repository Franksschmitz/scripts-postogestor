/*
   ATENÇÃO - RODAR O SCRIPT EM TODOS OS BANCOS POIS ESTE SCRIPT NÃO REPLICA DADOS
*/
SET TERM ^ ;

do $$
declare  
  l_id_empresa integer;  
  l_id_item fk;
  l_qt_movime quantidade;  
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true); 
  perform set_config('myvars.DESATIVA_REPLICADOR', 'T', true);
  update MOVVIR m set CH_EXCLUIDO = 'T'                                  
  where m.ch_excluido is null
      and m.CH_TIPO = 'E' 	  
      and exists(select 1 from ORDCOMPRA_ITEM oi where oi.ID_ORDCOMPRA = m.ID_ORDCOMPRA and oi.ID_ITEM = m.ID_ITEM and oi.CH_EXCLUIDO = 'T')    
      and coalesce((select count(1) 
           from ORDCOMPRA_ITEM oi 
           where oi.ID_ORDCOMPRA = m.ID_ORDCOMPRA and 
                 oi.ID_ITEM = m.ID_ITEM and 
                 oi.CH_EXCLUIDO is null
           ),0) <= 1; 
  for l_id_item, l_id_empresa , l_qt_movime in 
    select m.ID_ITEM, 
	       m.ID_FILIAL,
           sum(case when m.CH_TIPO = 'E' then m.QT_MOVIME else -m.QT_MOVIME end) as QT_SALDO  
    from MOVVIR m
    where m.CH_EXCLUIDO is null           
    group by 1,2
  loop
    update ITEM_ESTVIR 
      set QT_VIRTUAL = l_qt_movime
    where ID_ITEM = l_id_item and
          ID_FILIAL = l_id_empresa and
          CH_EXCLUIDO is null;    
  end loop;   
  perform set_config('myvars.DESATIVA_REPLICADOR', 'F', true); 
end
$$
^

SET TERM ; ^
