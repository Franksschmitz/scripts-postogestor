UPDATE reajuste SET ch_excluido = 'T'
WHERE ch_situac = 'P'
AND id_filial =:Empresa -- Inserir o código da empresa no PostoGestor: 1, 2, etc.
AND ch_excluido is null
AND dh_libage BETWEEN :Data_ini AND :Data_fim -- Preencher no formato: 01/01/2021