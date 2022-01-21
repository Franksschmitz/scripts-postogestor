-- Select para buscar placa invalida com espaço ou traço no banco

SELECT ds_placa, * FROM docfiscal WHERE ds_placa LIKE '% %' OR ds_placa LIKE '%-%'