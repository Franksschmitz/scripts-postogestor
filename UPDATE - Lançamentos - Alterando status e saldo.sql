UPDATE lanc 
            SET ch_situac = 'L', 
                vl_saldo = '0', 
                vl_pago = vl_valor, 
                dt_baixa = dt_vencim,
                dt_ultbai = dt_vencim
WHERE id_filial =:Empresa
AND id_entidade =:Codigo_Entidade
AND id_especie =:Especie
AND ch_excluido is null
AND dh_lanc BETWEEN :DATA_INICIO AND :DATA_FIM