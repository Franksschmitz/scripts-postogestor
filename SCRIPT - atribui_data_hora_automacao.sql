/*
      ATENÇÃO - ESTE SCRIPT NÃO REPLICA DADOS - RODAR EM TODOS OS BANCOS
*/


SET TERM ^ ;

do $$
declare  
  l_id_empresa integer;
  l_dh_inicio timestamp;
  l_dh_fim timestamp;
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true); 
  perform set_config('myvars.DESATIVA_REPLICADOR', 'T', true);
  
  l_dh_inicio = '2020-01-13 00:00:00';
  l_dh_fim = '2020-11-13 23:59:59.999';
  
  update abastecimento a
    set DH_EMISSAO_AUT = cast('2020-' || substring(a.DS_LINHA_AUT from 42 for 2) || '-' ||
            substring(a.DS_LINHA_AUT from 36 for 2) || ' ' ||
            substring(a.DS_LINHA_AUT from 38 for 2) || ':' || 
            substring(a.DS_LINHA_AUT from 40 for 2) || ':00' as timestamp) 
  where a.DH_EMISSAO_AUT is null and
        a.CH_EXCLUIDO is null and
        a.DT_EMISSAO between l_dh_inicio and l_dh_fim and
        a.DT_EMISSAO > '2020-01-01 00:00:00' and
        ds_linha_aut like 'a2%';
  perform set_config('myvars.DESATIVA_REPLICADOR', 'F', true);
end
$$
^

SET TERM ; ^
