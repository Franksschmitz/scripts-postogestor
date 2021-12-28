-- RETORNA PREÇO GERAL SE NAO TIVER PREÇO DIFERENCIADO NA FILIAL

SELECT 
    COALESCE(
				(
					SELECT 
						vl_preco
					FROM item_preco
						WHERE ch_excluido IS NULL
						AND id_item = :Item
						AND id_filial = :Empresa
						AND ch_predif = 'T'
						AND ch_tipo = 'F'
						AND id_tipopreco = (
                                                SELECT id_tipopreco FROM tipopreco 
                                                    WHERE ds_tipopreco = 'A VISTA' 
                                                LIMIT 1)
				),
		
				(	
					SELECT 
						vl_preco
					FROM item_preco
						WHERE ch_excluido IS NULL
						AND ch_tipo = 'G'
						AND id_item = :Item
						AND id_tipopreco = (
                                                SELECT id_tipopreco FROM tipopreco 
                                                    WHERE ds_tipopreco = 'A VISTA' 
                                                LIMIT 1)
				)
			) AS PRECO_VENDA
FROM item 
WHERE id_item = :Item
