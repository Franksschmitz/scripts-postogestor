/*
    IMPORTANTE - RODAR SEMPRE EM UM BACKUP PRIMEIRO E CONFERIR AS INFORMACOES	
	RODAR EM TODOS OS BANCOS - ESTE SCRIPT NAO REPLICA DADOS
*/	

DO $$DECLARE
    l_id_empresa_lo INTEGER;
    l_id_filial INTEGER;
    l_id_cfgfiscal FK;    
    l_id_imposto FK;     
    l_id_cst FK;
    l_id_item FK;
    l_id_natoper FK;
    l_data_ini DATE;
    l_data_fim DATE;    
    l_al_imposto NUMERIC(14,4);        
    l_ds_stecf VARCHAR(5);
    l_id_docfiscal fk;
    l_id_docfiscal_item fk;
    l_totalizador_ecf nomes15;
    l_tipo_imposto nomes;
    l_total_item valor;
	l_indice_aliquota varchar(2);
	l_numero_cfop varchar(20);
	l_numero_cst varchar(20);
BEGIN	    
   SELECT ID_EMPRESA$LO FROM EMPRESA$LO WHERE CH_LOCAL = 'T' LIMIT 1 INTO l_id_empresa_lo;
   perform set_config('myvars.ID_EMPRESA', l_id_empresa_lo::text, true); 
   perform set_config('myvars.DESATIVA_REPLICADOR', 'T', true);
   l_id_filial     = 1; -- Informar a ID_EMPRESA que deseja reprocessar
   l_id_cfgfiscal  = ''; -- Informar a ID_CFGFISCAL base
   l_id_imposto    = ''; -- Informar a ID_IMPOSTO que deseja reprocessar
   l_data_ini      = ''; -- 'yyyy-mm-dd'
   l_data_fim      = ''; -- 'yyyy-mm-dd'
   l_indice_aliquota = null; --indice da aliquota no ecf. Ex: 01
   l_numero_cfop = ''; -- numero da cfop. Ex: 5405
   l_numero_cst = ''; -- numero da cst. Ex: 060
   
   l_tipo_imposto = (select DS_TIPO from IMPOSTO where ID_IMPOSTO = l_id_imposto);
      
   --carrega os dados da configuracao fiscal
   SELECT cfi.AL_IMPOSTO,              
          cfi.ID_CST, 
          cfi.ID_NATOPER, 
          cfi.DS_STECF,
          case when cfi.AL_IMPOSTO > 0 then  l_indice_aliquota || cfi.DS_STECF || trunc(cfi.AL_IMPOSTO * 100) else cfi.DS_STECF || '1' end
   into  l_al_imposto,
         l_id_cst,
         l_id_natoper,
         l_ds_stecf,
         l_totalizador_ecf            
   FROM CFGFISCAL_IMPOSTO cfi 
   WHERE cfi.CH_EXCLUIDO IS NULL AND 
         cfi.ID_CFGFISCAL = l_id_cfgfiscal AND
         cfi.ID_IMPOSTO = l_id_imposto AND
         cfi.ID_ESTADO_DESTINO = cfi.ID_ESTADO_ORIGEM
   LIMIT 1;
   
   --navega todos os itens que possuem essa configuracao fiscal configurada                
   for l_id_item in 
     select distinct ic.ID_ITEM
     from ITEM_CFGFISCAL ic
     where ic.ID_CFGFISCAL = l_id_cfgfiscal and
           ic.CH_EXCLUIDO is null
   loop
      for l_id_docfiscal, l_id_docfiscal_item, l_total_item in
        select d.ID_DOCFISCAL, 
               di.ID_DOCFISCAL_ITEM,
               di.VL_BRUTO - coalesce(di.VL_DESCON, 0.0) +  coalesce(di.VL_ACRES, 0.0)         
        from DOCFISCAL d 
        left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL
        where d.CH_SITUAC = 'F' and                                            
              d.DT_EMISSA between l_data_ini and l_data_fim and
              d.ID_FILIAL = l_id_filial and 
              d.CH_EXCLUIDO is null and
              d.CH_TIPO <> 'VEN' and
              di.ID_ITEM = l_id_item and
			  exists(
			    select 1 from DOCFISCAL_ITEM_IMPOSTO dimp
				left join CST c on c.ID_CST = dimp.ID_CST
				left join NATOPER n on n.ID_NATOPER = dimp.ID_NATOPER
				where dimp.CH_EXCLUIDO IS NULL AND 
					  dimp.ID_DOCFISCAL_ITEM = di.ID_DOCFISCAL_ITEM and
					  dimp.ID_IMPOSTO = l_id_imposto and
					  c.NR_CST = l_numero_cst and
					  n.NR_NATOPER = l_numero_cfop
			  )
      loop
        update DOCFISCAL_ITEM_IMPOSTO set
            ID_CST = l_id_cst,             
            AL_IMPOSTO = l_al_imposto,
            DS_STECF = l_ds_stecf,
            VL_BASE = CASE when l_al_imposto = 0 then 0.0 
                           when VL_BASE <= 0 and l_al_imposto > 0 THEN l_total_item 
                       ELSE VL_BASE END,
            VL_IMPOSTO = cast(CASE WHEN VL_BASE <= 0 THEN l_total_item ELSE VL_BASE END * l_al_imposto / 100.00 as DECIMAL(18,4))       	
        where ID_DOCFISCAL = l_id_docfiscal and          
              ID_IMPOSTO = l_id_imposto and
              ID_DOCFISCAL_ITEM = l_id_docfiscal_item and 
              CH_EXCLUIDO is null and 
              ( 
                ID_CST is distinct from l_id_cst or
                AL_IMPOSTO is distinct from l_al_imposto or
                DS_STECF is distinct from l_ds_stecf or
                VL_BASE is distinct from (CASE WHEN VL_BASE <= 0 THEN l_total_item ELSE VL_BASE END) or 
                VL_IMPOSTO is distinct from cast(CASE WHEN VL_BASE <= 0 THEN l_total_item ELSE VL_BASE END * l_al_imposto / 100.00 as DECIMAL(18,4))                				 
              );
        if (l_tipo_imposto = 'ICMS') then 
          update DOCFISCAL_ITEM set 
             ID_NATOPER = l_id_natoper,
             DS_TOTALIZADOR_ECF = l_totalizador_ecf
          where ID_DOCFISCAL_ITEM = l_id_docfiscal_item and 
                (
                  ID_NATOPER is distinct from l_id_natoper or
                  DS_TOTALIZADOR_ECF is distinct from l_totalizador_ecf 
                );
          end if;                       
      end loop;
   end loop;   
   --atualiza os totais de impostos dos documentos fiscais   
   for l_id_item in 
     select distinct ic.ID_ITEM
     from ITEM_CFGFISCAL ic
     where ic.ID_CFGFISCAL = l_id_cfgfiscal and
           ic.CH_EXCLUIDO is null
   loop
      for l_id_docfiscal, l_id_docfiscal_item, l_total_item in
        select distinct d.ID_DOCFISCAL         
        from DOCFISCAL d 
        left join DOCFISCAL_ITEM di on di.ID_DOCFISCAL = d.ID_DOCFISCAL
        where d.CH_SITUAC = 'F' and                                            
              d.DT_EMISSA between l_data_ini and l_data_fim and
              d.ID_FILIAL = l_id_filial and 
              d.CH_EXCLUIDO is null and
              d.CH_TIPO <> 'VEN' and
              di.ID_ITEM = l_id_item
      loop
        update DOCFISCAL_IMPOSTO di set
            VL_IMPOSTO = 
              (select sum(VL_IMPOSTO) 
               from DOCFISCAL_ITEM_IMPOSTO dip
                where dip.ID_DOCFISCAL = di.ID_DOCFISCAL and 
                      dip.ID_IMPOSTO = di.ID_IMPOSTO and
                      dip.CH_EXCLUIDO is NULL)
        where di.ID_DOCFISCAL = l_id_docfiscal and 
              di.ID_IMPOSTO = l_id_imposto;   
      end loop;
   end loop; 
   perform set_config('myvars.DESATIVA_REPLICADOR', 'F', true);
END$$;
