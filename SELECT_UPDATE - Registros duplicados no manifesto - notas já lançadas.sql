
-- SELECT para buscar registros duplicados no manifesto referentes a notas que já foram lançadas no sistema

SELECT * FROM manifestacao 
    WHERE ch_faturado <> 'T'
    AND ch_excluido IS NULL
    AND ds_chavenfe IN ( SELECT ds_chavenfe FROM nft WHERE ch_excluido IS NULL );



--UPDATE para remover os registros duplicados

UPDATE manifestacao SET ch_faturado = 'T'
    WHERE ch_faturado <> 'T'
    AND ch_excluido IS NULL
    AND ds_chavenfe IN ( SELECT ds_chavenfe FROM nft WHERE ch_excluido IS NULL );