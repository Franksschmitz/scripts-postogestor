SELECT
    i.id_item AS CODIGO,
    i.ds_item AS NOME,
    i.id_grupoitem AS CODIGO_GRUPO,
    i.nr_codbar AS CODIGO_BARRAS,
    CASE
        WHEN ic.vl_precus = NULL THEN 0
        ELSE ic.vl_precus
    END AS PRECO_CUSTO,
    COALESCE(
				(
					SELECT 
						vl_preco
					FROM item_preco
						WHERE ch_excluido IS NULL
						AND id_item = i.id_item
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
						AND id_item = i.id_item
						AND id_tipopreco = (
                                                SELECT id_tipopreco FROM tipopreco 
                                                    WHERE ds_tipopreco = 'A VISTA' 
                                                LIMIT 1)
				)
			) AS PRECO_VENDA,
    i.qt_entra AS QUANT_ENTRADA,
    uc.ds_sigla AS UNIDADE_ENTRADA,
    uv.ds_sigla AS UNIDADE_VENDA,
    c.nr_ncm AS NCM,
    CASE
        WHEN i.nr_cest = NULL THEN c.nr_cest
        ELSE i.nr_cest
    END AS CEST,
    CASE
        WHEN i.ch_combustivel = 'T' THEN 'C'
        WHEN i.ch_usoconsumo = 'T' THEN 'U'
        WHEN i.ch_material = 'T' THEN 'M'
        WHEN i.ch_servico = 'T' THEN 'S'
        WHEN i.ch_produto = 'T' THEN 'P'
        WHEN i.ch_imobilizado = 'T' THEN 'I'
        ELSE 'R'
    END AS TIPO,
    m.ds_marca AS NOME_MARCA,
    i.ch_estneg AS ESTOQUE_NEGATIVO,
    CASE 
        WHEN i.ch_limlocalarm = 'T' THEN 'S'
        ELSE 'N'
    END AS LIMITA_LOCAL_ARMAZENAGEM
FROM item i
LEFT JOIN item_custo ic ON i.id_item = ic.id_item
LEFT JOIN unidade uc ON i.id_unidade_e = uc.id_unidade
LEFT JOIN unidade uv ON i.id_unidade_s = uv.id_unidade 
LEFT JOIN classfiscal c ON i.id_classfiscal = c.id_classfiscal
LEFT JOIN tabanp t ON i.id_tabanp = t.id_tabanp
LEFT JOIN marca m ON i.id_marca = m.id_marca
    WHERE i.ch_ativo = 'T'
    AND i.ch_excluido IS NULL
    AND ic.ch_excluido IS NULL
    AND uc.ch_excluido IS NULL
    AND uv.ch_excluido IS NULL
    AND c.ch_excluido IS NULL
    AND t.ch_excluido IS NULL
    AND uc.ch_ativo = 'T'
    AND uv.ch_ativo = 'T'
    AND ic.id_filial =:Empresa
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
ORDER BY 2