
SET TERM ^ ;

do $$
declare 
  l_ID_EMPRESA integer;
  l_ID_ITEM_ERRADO fk;
  l_ID_ITEM_CERTO fk;

begin
  select ID_EMPRESA$LO from EMPRESA$LO where CH_LOCAL = 'T' limit 1 into l_ID_EMPRESA;
  perform set_config('myvars.ID_EMPRESA', l_id_empresa::text, true);  
  perform set_config('myvars.ATUALIZANDO_ESTOQUE', 'T', true);
  perform set_config('myvars.DESATIVA_REPLICADOR', 'T', true);
    
  l_ID_ITEM_ERRADO = '11563-1'; 
  l_ID_ITEM_CERTO = '9119-1'; 

  l_ID_LOCAL_ERRADO = '217-1';
  l_ID_LOCAL_CERTO = '217-1';
  
 update MOVEST_ITEM mi set 
    ID_LOCALARM = l_ID_LOCAL_CERTO,
    ID_ITEM = l_ID_ITEM_CERTO    
  where ID_LOCALARM = l_ID_LOCAL_ERRADO and
        ID_ITEM = l_ID_ITEM_ERRADO and        
        CH_EXCLUIDO IS NULL and
		ID_DOCFISCAL_ITEM IS NOT NULL and
		exists(
		  select 1 
		  from MOVEST m 
		  left join DOCFISCAL d on d.ID_DOCFISCAL = m.ID_DOCFISCAL
		  left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL
		  left join ABASTECIMENTO ab on ab.ID_ABASTECIMENTO = di.ID_ABASTECIMENTO
		  where m.ID_MOVEST = mi.ID_MOVEST and 
		        di.CH_EXCLUIDO is null and
				di.ID_DOCFISCAL_ITEM = mi.ID_DOCFISCAL_ITEM
		);  
        
  update ABASTECIMENTO set
    ID_LOCALARM = l_ID_LOCAL_CERTO,
	ID_ITEM = l_ID_ITEM_CERTO
  where ID_LOCALARM = l_ID_LOCAL_ERRADO and
        ID_ITEM = l_ID_ITEM_ERRADO and        
        CH_EXCLUIDO IS NULL;
        
  update DOCFISCAL_ITEM di set 
    ID_LOCALARM = l_ID_LOCAL_CERTO,
	ID_ITEM = l_ID_ITEM_CERTO
  where ID_LOCALARM = l_ID_LOCAL_ERRADO and
        ID_ITEM = l_ID_ITEM_ERRADO and        
        CH_EXCLUIDO IS NULL and
		ID_ABASTECIMENTO IS NOT NULL AND
		exists(
		  select 1 
		  from ABASTECIMENTO ab
		  where ab.ID_ABASTECIMENTO = di.ID_ABASTECIMENTO
		);  
  perform proc_atualiza_estoque(
	l_ID_LOCAL_ERRADO, 
	l_ID_ITEM_ERRADO, 
	'1900-01-01 00:00:00',    
	'', 
	0);
  perform proc_atualiza_estoque(
	l_ID_LOCAL_CERTO, 
	l_ID_ITEM_CERTO, 
	'1900-01-01 00:00:00',    
	'', 
	0);
  perform set_config('myvars.DESATIVA_REPLICADOR', 'F', true);  
  perform set_config('myvars.ATUALIZANDO_ESTOQUE', 'F', true);  		
end
$$
^

SET TERM ; ^