UPDATE abastecimento SET ch_ativo = 'F', ch_excluido = 'T'
    WHERE id_empresa =:Empresa
    AND ch_situac = 'P'
    AND ch_excluido IS NULL
    AND ch_ativo = 'T'
    AND CAST(dt_emissao AS DATE) BETWENN :Data_Inicio AND :Data_Fim