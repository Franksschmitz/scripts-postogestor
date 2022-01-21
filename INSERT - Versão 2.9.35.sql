SET TERM ^ ;

do $$
declare  
  l_id_empresa integer;
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);  
   
  insert into CAMPO(ID_CAMPO,ID_EMPRESA,ID_SEQ,CH_EXCLUIDO,DS_USUARIO,REC_VERSION,ID_USUARIO_M,CH_ATIVO,DS_CAMPO,DS_IDENT,CH_OPERAC,CH_TIPO) 
  values('13-' || l_id_empresa,l_id_empresa,13,null,null,null,null,'T','VALOR MULTA','VL_MULTA','E','B');  
end
$$
^

SET TERM ; ^ 


update VERSAO set VERSAO_SCRIPT_POS_M = 57;