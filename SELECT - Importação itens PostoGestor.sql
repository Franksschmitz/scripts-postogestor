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
    CAST((
           SELECT
                CASE
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'R,'             THEN 'R'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'C,'             THEN 'C'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'M,'             THEN 'M'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'U,'             THEN 'U'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'S,'             THEN 'S'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'P,'             THEN 'P'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'I'              THEN 'I'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'R,M,'           THEN 'R,M'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'R,P,'           THEN 'R,P'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'U,S,'           THEN 'U,S'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'R,U,'           THEN 'R,U'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'R,U,M,'         THEN 'R,U,M,'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'R,U,P,'         THEN 'R,U,P'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = 'R,M,P,'         THEN 'R,M,P'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = ''               THEN 'R'
                    WHEN ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END)) = NULL             THEN 'R'
                    ELSE ((CASE WHEN x.rev = 'T' THEN 'R,' ELSE '' END) || (CASE WHEN x.comb = 'T' THEN 'C,' ELSE '' END) || (CASE WHEN x.uso = 'T' THEN 'U,' ELSE '' END) || (CASE WHEN x.mat = 'T' THEN 'M,' ELSE '' END) || (CASE WHEN x.serv = 'T' THEN 'S,' ELSE '' END) || (CASE WHEN x.prod = 'T' THEN 'P,' ELSE '' END) || (CASE WHEN x.imob = 'T' THEN 'I' ELSE '' END))
                END AS TP
           FROM (   SELECT
                        it.id_item AS COD,
                        it.ch_revenda AS REV,
                        it.ch_combustivel AS COMB,
                        it.ch_usoconsumo AS USO,
                        it.ch_material AS MAT,
                        it.ch_servico AS SERV,
                        it.ch_produto AS PROD,
                        it.ch_imobilizado AS IMOB
                    FROM item it
                        WHERE it.ch_ativo = 'T'
                        AND it.ch_excluido IS NULL 
                ) x 
                WHERE x.cod = i.id_item
            ) AS VARCHAR(14)
        ) AS TIPO,
    m.ds_marca AS NOME_MARCA,
    i.ch_estneg AS ESTOQUE_NEGATIVO,
    CAST((CASE 
            WHEN i.ch_limlocalarm = 'T' THEN 'S'
            ELSE 'N'
    END) AS VARCHAR(1)) AS LIMITA_LOCAL_ARMAZENAGEM
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