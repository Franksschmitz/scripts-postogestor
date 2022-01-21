/*
   ATENÇÃO - REVISAR OS PARAMETROS ANTES DE EXECUTAR
   EXECUTAR PRIMEIRO EM UM BACKUP E CONFERIR AS INFORMAÇÕES
*/

SET TERM ^ ;

do $$
declare
  lsIdDoc fk; 
  l_id_empresa integer;	
  l_id_imposto fk;
  l_aliq_imposto valor;
  l_dt_ini date;
  l_dt_fim date;
  l_id_filial integer;
  l_tipo_doc nomes;
BEGIN	
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_id_empresa;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true); 	
  
  l_id_imposto = ''; --colocar aqui o codigo do imposto
  l_aliq_imposto = '0.0'; --colocar aqui aliquota do imposto
  l_dt_ini = '2020-01-01'; --colocar aqui data inicial
  l_dt_fim = '2020-01-01'; --colocar aqui data final
  l_id_filial = '1'; --colocar aqui codigo da filial
  l_tipo_doc = 'NFE'; --colocar aqui tipo do documento fiscal    
  
    for lsIdDoc in
      select d.ID_DOCFISCAL
      from DOCFISCAL d 
      where d.CH_SITUAC = 'F' and d.DT_EMISSA between l_dt_ini and l_dt_fim and
           d.ID_FILIAL = l_id_filial and 
		   d.CH_TIPO = l_tipo_doc and 
		   d.CH_EXCLUIDO is null and
           d.CH_TIPO <> 'VEN'    
      loop
      
      update DOCFISCAL_ITEM_IMPOSTO set 
      AL_IMPOSTO = l_aliq_imposto,
      VL_IMPOSTO = cast(VL_BASE * l_aliq_imposto / 100.00 as DECIMAL(18,4))       	
      where ID_DOCFISCAL = lsIdDoc and ID_IMPOSTO = l_id_imposto and CH_EXCLUIDO is null and
            AL_IMPOSTO > 0 and (AL_IMPOSTO <> l_aliq_imposto or VL_IMPOSTO <> cast(VL_BASE * l_aliq_imposto / 100.00 as DECIMAL(18,4))); 
      
      
      update DOCFISCAL_IMPOSTO di set
      	VL_IMPOSTO = 
         (select sum(VL_IMPOSTO) 
          from DOCFISCAL_ITEM_IMPOSTO dip
          where dip.ID_DOCFISCAL = di.ID_DOCFISCAL and dip.ID_IMPOSTO = di.ID_IMPOSTO and
                dip.CH_EXCLUIDO is NULL)
      where di.ID_DOCFISCAL = lsIdDoc and di.ID_IMPOSTO = l_id_imposto;      
   end loop;
end;$$
^

SET TERM ; ^