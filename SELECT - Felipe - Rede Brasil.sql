SELECT  
        crp.id_concirecpag, 
        crp.dt_pagame, 
        crp.ch_situac, 
        crp.dt_emissa, 
        crp.dt_vencim, 
        crp.vl_valor,      
        coalesce(crp.nr_autorizacao,'')as nr_autorizacao, 
        coalesce(crp.nr_nsu,'') as nr_nsu,                    
        crp.ch_tef, 
        crp.id_filial, 
        crp_bai.id_conciliacao, 
        coalesce(con_movi.ds_descricao,'') as ds_descricao,
        crp.per_taxa as taxa_venda,                                                                           
        crp_bai.per_taxa as taxa_aplicada,                                                                    
        con_movi.vl_pertaxa as taxa_contratada                                                                
FROM concirecpag as crp                                                                                       
inner join concirecpag_bai as crp_bai on (crp.id_concirecpag = crp_bai.id_concirecpag)                                                
inner join conciliacao_movi as con_movi on (crp_bai.id_conciliacao_movi = con_movi.id_conciliacao_movi)                                 		                                                                           
    where crp.ch_excluido is null 
    and con_movi.ch_excluido is null  
    and crp_bai.ch_excluido is null                                                                        
    and crp.id_filial =:id_filial                                                                       
    and crp.dt_pagame between :dataini and :datafin and                                                      
	     (                                                                                                    
		crp.per_taxa - crp_bai.per_taxa	> 0.01 or                                                          
	        crp.per_taxa - crp_bai.per_taxa	< -0.01                                                            
	     )                                                                                                    
order by crp.dt_pagame