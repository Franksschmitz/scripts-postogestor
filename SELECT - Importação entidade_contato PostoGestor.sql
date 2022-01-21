SELECT
    id_contato,
    ds_contato,
    ds_fone,
    ds_celular,
    ds_cargo,
    ds_email,
    CONCAT(
            CASE
                WHEN ch_principal = 'T' THEN 'P,'
                ELSE '' 
            END,
            CASE
                WHEN ch_cobranca = 'T' THEN 'C,'
                ELSE '' 
            END,
            CASE
                WHEN ch_envioxml = 'T' THEN 'E'
                ELSE '' 
            END
    ) AS TIPO 
FROM entidade_contato
    WHERE ch_excluido IS NULL
