-- Select para buscar placa invalida com espaço ou traço no banco

select ds_placa, * from docfiscal where ds_placa like '% %' or ds_placa like '%-%'