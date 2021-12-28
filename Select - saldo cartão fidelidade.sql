
--Conferir no banco o saldo de um cartão fidelidade

SELECT cm.VL_SALDO
            FROM cartao_mov AS cm, cartao AS c
            WHERE c.id_cartao = cm.id_cartao
                AND c.CH_TIPO = 'F'
                AND cm.CH_EXCLUIDO IS NULL
                AND c.id_entidade = :id_entidade
                AND c.NR_CARTAO = :nr_cartao
            ORDER BY cm.DH_MOVIME DESC 
            LIMIT 1