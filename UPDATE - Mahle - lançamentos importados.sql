UPDATE lanc SET id_tipolanc = '33-1', dt_vencim =:VENCIMENTO --Preencher no formato 01/01/2021
    WHERE id_filial =:EMPRESA   --Preencher no formato 
    AND id_entidade =:ENTIDADE  --Preencher no formato 
    AND ch_situac = 'A'
    AND id_tipolanc is null
    AND dt_vencim between '2021-04-01' and '2021-04-30'
    AND id_planoconta in ('381-1','382-1')