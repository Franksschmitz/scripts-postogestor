SET TERM ^ ;

do $$
declare 
  l_ID_EMPRESA integer;
  l_ID_BOMBA_ERRADO_1 fk;
  l_ID_BOMBA_ERRADO_2 fk;
  l_ID_BOMBA_ERRADO_3 fk;
  
  l_ID_BOMBA_CERTO_1 fk;
  l_ID_BOMBA_CERTO_2 fk;
  l_ID_BOMBA_CERTO_3 fk;
  
begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_ID_EMPRESA;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);  
    
  l_ID_BOMBA_ERRADO_1 = '14-1';
  l_ID_BOMBA_ERRADO_2 = '15-1';
  l_ID_BOMBA_ERRADO_3 = '16-1';
  
  l_ID_BOMBA_CERTO_1 = '29-7';
  l_ID_BOMBA_CERTO_2 = '30-7';
  l_ID_BOMBA_CERTO_3 = '31-7';
  
  update ABASTECIMENTO set
	ID_BOMBA = l_ID_BOMBA_CERTO_1
  where ID_BOMBA = l_ID_BOMBA_ERRADO_1
		and ID_BICO in ('18-7','19-7')
        and DT_EMISSAO between '2019-08-22 09:10:00' and '2019-08-26 23:59:59'		
        and CH_EXCLUIDO IS NULL;
        
   update ABASTECIMENTO set
	ID_BOMBA = l_ID_BOMBA_CERTO_2
  where ID_BOMBA = l_ID_BOMBA_ERRADO_2
		and ID_BICO in ('20-7','21-7')
        and DT_EMISSAO between '2019-08-22 09:10:00' and '2019-08-26 23:59:59'	
        and CH_EXCLUIDO IS NULL;
		
   update ABASTECIMENTO set
	ID_BOMBA = l_ID_BOMBA_CERTO_3
  where ID_BOMBA = l_ID_BOMBA_ERRADO_3
		and ID_BICO in ('22-7','23-7')
        and DT_EMISSAO between '2019-08-22 09:10:00' and '2019-08-26 23:59:59'
        and CH_EXCLUIDO IS NULL;		
		    		
end
$$
^

SET TERM ; ^