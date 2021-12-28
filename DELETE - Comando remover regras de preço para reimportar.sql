-- Comando remover regras de pre�o para reimportar:

SET TERM ^ ;

do $$declare
  declare EMPRESA integer;
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into EMPRESA;  
  perform set_config('myvars.ID_EMPRESA', EMPRESA::text, true);

  delete from REGRAPRECO_GRUPOENT;  
  delete from REGRAPRECO_ENTIDADE;
  delete from REGRAPRECO_ESPECIE;
  delete from REGRAPRECO_FILIAL;
  delete from REGRAPRECO_APL_BAI;
  delete from REGRAPRECO_APL;
  delete from REGRAPRECO;
  
  delete from IMPID where DS_TABELA = 'REGRAPRECO';
end$$;
^

SET TERM ; ^

alter sequence GEN_REGRAPRECO restart with 1;
alter sequence GEN_REGRAPRECO_APL restart with 1;
alter sequence GEN_REGRAPRECO_APL_BAI restart with 1;
alter sequence GEN_REGRAPRECO_ENTIDADE restart with 1;
alter sequence GEN_REGRAPRECO_ESPECIE restart with 1;
alter sequence GEN_REGRAPRECO_FILIAL restart with 1;
alter sequence GEN_REGRAPRECO_GRUPOENT restart with 1;
