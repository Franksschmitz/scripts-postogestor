SELECT
    nr_comanda,
    id_filial,
    nr_referencia
FROM comanda
    WHERE ch_excluido IS NULL
    AND ch_ativo = 'T'