SET TERM ^ ;

do $$
declare  
  l_id_empresa integer;
  l_id_integracao fk;
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);
  l_id_integracao = ''; --COLOCAR AQUI CODIGO DA INTEGRACAO ECONOMIA CIRCULAR  
  update ENTIDADE_INTEGRACAO set CH_EXCLUIDO = 'T' where ID_INTEGRACAO = l_id_integracao;
end
$$
^

SET TERM ; ^