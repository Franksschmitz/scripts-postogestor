-- SCRIPT exclusivo replicador HANGAR

do $$
declare  
  l_id_empresa integer;
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);
  perform set_config('myvars.DESATIVA_REPLICADOR', 'T', true);
  insert into docfiscal(id_docfiscal, id_empresa, id_seq) values ('784679-2', 2, 784679);  
  perform set_config('myvars.DESATIVA_REPLICADOR', 'F', true); 
end
$$

-- Comando 2 Hangar para ficar registrado:

update lote$rep set id_lote_seq = 4000751 
where ds_chave_temp = '{EE27867A-220D-41BF-85FF-E7D45B94D658} - ID: 4001379';